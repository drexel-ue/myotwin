# Motus CLI: Developer Guide & Walkthrough

This guide is designed to teach you how to rebuild the Motus CLI from scratch. It assumes **no prior knowledge of Rust**. We will walk through the tools, concepts, and architecture that make up this Terminal User Interface (TUI) application.

---

## 1. Introduction & Setup

### What is Motus CLI?
Motus CLI is a command-line tool built to automate the creation of a specialized Medical AI. It allows you to:
1. Search and download medical textbooks via Anna's Archive.
2. Extract text from PDFs/EPUBs and format it into conversational datasets using Gemini.
3. Train a LoRA adapter on a base AI model using those datasets via Modal (a cloud GPU provider).

### What is Rust?
Rust is a blazingly fast and memory-safe systems programming language. It is widely loved for building CLI tools because it compiles down to a single binary (no Python virtual environments or runtime dependencies required for the end user!).

**Key Tools:**
- **rustup**: The installer for Rust.
- **rustc**: The Rust compiler.
- **cargo**: Rust's package manager and build system (similar to `npm` or `pip`). You use `cargo build` to compile your code and `cargo run` to execute it.

**Getting Started with Rust**
1. Install Rust via [rustup.rs](https://rustup.rs/).
2. Install the **rust-analyzer** extension in VS Code for autocomplete and inline errors.
3. Read the first few chapters of [The Rust Programming Language (The Book)](https://doc.rust-lang.org/book/) to understand ownership, borrowing, and basic syntax.

---

## 2. Core Concepts & Dependencies

To build a TUI in Rust, we rely on several key open-source libraries (called "crates" in Rust). These are defined in our `Cargo.toml` file.

### Terminal User Interfaces (TUIs)
- **[Ratatui](https://ratatui.rs/)**: The framework we use to draw the user interface. It provides widgets like `Paragraph`, `List`, and `Block`.
- **[Crossterm](https://docs.rs/crossterm/latest/crossterm/)**: Handles the low-level terminal interactions. It allows us to:
  - Enter the **Alternate Screen**: A separate terminal buffer so we don't overwrite your bash history.
  - Enable **Raw Mode**: Disables standard terminal features (like echoing typed characters or waiting for `Enter` to send input) so we can instantly capture keypresses like `Up` and `Down`.

### Asynchronous Rust (Async/Await)
Because our CLI makes network requests (downloading gigabytes of PDFs, talking to Gemini, etc.), we cannot pause the entire program while waiting for a response. If we did, the UI would freeze!
- **[Tokio](https://tokio.rs/)**: An asynchronous runtime for Rust. It allows us to run tasks in the background (`tokio::spawn`) while our main thread continues to redraw the UI and listen for keypresses at 60 FPS.

### Data Handling
- **[Serde](https://serde.rs/)**: The absolute standard for serializing and deserializing data in Rust. We use it to parse the JSON responses from Anna's Archive and Gemini.
- **[Reqwest](https://docs.rs/reqwest/latest/reqwest/)**: A high-level HTTP client for making API requests.

### Python & Virtual Environments (venvs)
While the core CLI is built in Rust, we use Python for specific tasks like parsing PDFs (via `PyMuPDF`) and running AI frameworks (via `modal` and `unsloth`).
- **What is Python?** A popular scripting language heavily used in AI and data science.
- **What is a venv?** A "Virtual Environment". Because Python installs dependencies globally by default, different projects can clash. A `venv` is an isolated folder (often named `.venv`) that contains a specific project's Python interpreter and libraries, keeping your main system clean.

---

## 3. Project Architecture (How It Works)

If you were to rebuild this CLI step-by-step, you would follow this exact architecture.

### Step 1: Managing State (`app.rs`)
In Ratatui, the UI is a pure reflection of your application state. We define this state in `src/app.rs`.

We use an `enum` to track which screen the user is currently on:
```rust
pub enum CurrentScreen {
    MainMenu,
    ApiKeysList,
    DatasetGen,
    // ...
}
```

We then create an `App` struct that holds all the data our UI needs to render:
```rust
pub struct App {
    pub current_screen: CurrentScreen,
    pub search_input: String,
    pub search_results: Vec<Book>,
    pub pending_search: bool,
    // ...
}
```
Whenever the user types a letter, we simply append it to `app.search_input`. When they press Enter, we set `app.pending_search = true`.

### Step 2: The Event Loop (`main.rs`)
The heart of the CLI is the `run_app` loop in `src/main.rs`. It runs infinitely until `app.should_quit` is true.

In every iteration of the loop, it does three things:
1. **Draw the UI:** Calls `terminal.draw(|f| ui::draw(f, app))` to render the screen.
2. **Handle Background Tasks:** Checks if any background tasks need to be spawned. For example, if `app.pending_search` is true, it uses `tokio::spawn` to start the Anna's Archive search in the background.
3. **Listen for Events:** Uses a `tokio::select!` block to listen for two things simultaneously:
   - **Keyboard Input**: If the user presses a key, it updates the `App` state.
   - **Messages from Background Tasks**: Background tasks communicate with the main loop using an MPSC (Multi-Producer, Single-Consumer) channel. When a search finishes, the background task sends an `AppAction::SearchDone(results)` message to the main loop, which then updates `app.search_results`.

### Step 3: Rendering the UI (`ui.rs`)
The `ui::draw` function takes a `Frame` (the terminal screen) and our `App` state. It looks at `app.current_screen` and decides what widgets to draw.

```rust
match app.current_screen {
    CurrentScreen::MainMenu => {
        let list = List::new(app.main_menu_items.clone())
            .block(Block::default().title("Main Menu").borders(Borders::ALL));
        f.render_widget(list, chunks[0]);
    }
    // ...
}
```

**Immediate Mode Rendering:**
Ratatui is an "immediate mode" GUI. This means it completely redraws the screen on every frame based on the current state. You don't "update" a widget; you just change the state, and the widget is drawn differently on the next frame.

### Step 4: Suspending the TUI for Modal Auth
A complex challenge in TUI development is running interactive terminal commands (like `modal token new` which opens a web browser). If we run it while Ratatui is active, the terminal outputs will clash.

To solve this in `main.rs`, we:
1. Temporarily `disable_raw_mode()` and `LeaveAlternateScreen`.
2. Spawn the `modal` python script synchronously using `std::process::Command`.
3. Wait for the user to finish in their browser.
4. `enable_raw_mode()` and `EnterAlternateScreen` to seamlessly restore the TUI.

---

## 4. Integration Deep-Dives

### Anna's Archive (`annas_archive.rs`)
We interact with Anna's Archive using standard HTTP `GET` requests via the `reqwest` crate. Since the API returns JSON, we use `serde_json` to parse it into strongly-typed Rust structs (like `Book`). For downloading, we stream the response body in chunks to update the progress bar in the UI.

### Dataset Generation (`dataset_gen.rs`)
To teach an AI specialized medical knowledge, we cannot just feed it raw PDF text; AI models learn best from structured, conversational data (e.g., a "User" asks a question, the "Assistant" answers). This process involves:
- **Chunking**: Breaking a massive book into smaller, manageable pieces (chunks) so the AI can process them.
- **Cleaning**: Removing gibberish, page numbers, or corrupted text from the raw PDF extraction.
- **Formatting**: Structuring the clean text into JSONL (JSON Lines) format with a strict schema that the AI expects during training.

We use a hybrid approach here to accomplish this. Since Python has excellent PDF extraction libraries (like `PyMuPDF`), we bundled a Python script (`extract_pdf.py`) into our Rust project.
1. Rust spawns the Python script as a subprocess to extract text chunks from the PDF.
2. Rust captures the JSON output from the Python script.
3. Rust makes asynchronous HTTP requests to the Gemini API (`gemini-2.5-flash`) to format those raw chunks into clean, conversational Q&A data.

### LoRA Training via Modal (`lora_train.rs`)
Training a Large Language Model (LLM) like LLaMA from scratch costs millions of dollars. Instead, we use **Fine-Tuning**.
- **What is a LoRA?** Low-Rank Adaptation (LoRA) is a technique that freezes the original AI model and only trains a tiny, separate "adapter" module on top of it. Think of the base model as a general doctor, and the LoRA adapter as a specialized textbook they carry. It makes training extremely fast and cheap!

Modal allows us to run these heavy GPU workloads in the cloud as if they were local functions on our machine.
1. We bundled `train_lora_modal.py` which contains the Unsloth training logic (Unsloth makes LoRA training up to 2x faster).
2. Rust executes `python -m modal run ./python/train_lora_modal.py` to trigger the cloud training.
3. Rust streams the standard output (`stdout`) of this process in real-time, parsing the logs and displaying them in the Ratatui scrollable log viewer.

---

## 5. Further Reading
If you want to dive deeper into building TUIs with Rust, here are the best resources:
- [Ratatui Tutorial](https://ratatui.rs/tutorials/hello-world/): An excellent step-by-step guide to building your first TUI.
- [Tokio Tutorial](https://tokio.rs/tokio/tutorial): The best way to learn async Rust.
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/): Great for looking up syntax and standard library patterns.
