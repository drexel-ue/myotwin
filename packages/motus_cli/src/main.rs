use crossterm::{
    event::{self, Event},
    execute,
    terminal::{disable_raw_mode, enable_raw_mode, EnterAlternateScreen, LeaveAlternateScreen},
};
use ratatui::{
    backend::{Backend, CrosstermBackend},
    Terminal,
};
use std::{error::Error, io};

mod app;
mod ui;
mod dataset_gen;
mod annas_archive;
mod lora_train;

use app::App;
use crossterm::event::{EventStream, KeyCode, KeyModifiers};
use tokio_stream::StreamExt;
use tokio::sync::mpsc;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    dotenvy::dotenv().ok();

    // Setup terminal
    enable_raw_mode()?;
    let mut stdout = io::stdout();
    execute!(stdout, EnterAlternateScreen)?;
    let backend = CrosstermBackend::new(stdout);
    let mut terminal = Terminal::new(backend)?;

    // Create app state and run loop
    let mut app = App::new();
    let res = run_app(&mut terminal, &mut app).await;

    // Restore terminal
    disable_raw_mode()?;
    execute!(
        terminal.backend_mut(),
        LeaveAlternateScreen
    )?;
    terminal.show_cursor()?;

    if let Err(err) = res {
        println!("{:?}", err);
    }

    Ok(())
}

enum AppAction {
    SearchProgress(f64),
    SearchDone(Result<Vec<crate::annas_archive::Book>, String>),
    DownloadProgress(f64),
    DownloadDone(Result<String, String>),
    DatasetMessage(crate::dataset_gen::DatasetGenMessage),
    DatasetDone(Result<String, String>),
    TagRecommendation(Result<String, String>),
    LoraMessage(crate::lora_train::LoraTrainMessage),
    LoraDone(Result<String, String>),
}

fn notify(title: &str, message: &str) {
    let script = format!("display notification \"{}\" with title \"{}\" sound name \"Glass\"", message, title);
    let _ = std::process::Command::new("osascript")
        .arg("-e")
        .arg(&script)
        .spawn();
}

async fn run_app<B: Backend>(terminal: &mut Terminal<B>, app: &mut App) -> io::Result<()> {
    let mut reader = EventStream::new();
    let (tx, mut rx) = mpsc::channel(32);

    loop {
        terminal.draw(|f| ui::draw(f, app)).unwrap();

        if app.pending_modal_auth {
            app.pending_modal_auth = false;
            
            // Suspend UI
            disable_raw_mode().unwrap();
            execute!(std::io::stdout(), crossterm::terminal::LeaveAlternateScreen).unwrap();
            
            println!("Starting Modal Authentication Flow...");
            println!("Please follow the instructions below to log into Modal in your browser.");
            println!("--------------------------------------------------");
            
            let status = std::process::Command::new("./python/.venv/bin/python")
                .arg("-m")
                .arg("modal")
                .arg("token")
                .arg("new")
                .status();
                
            println!("--------------------------------------------------");
            match status {
                Ok(s) if s.success() => {
                    println!("Successfully authenticated with Modal!");
                }
                _ => {
                    println!("Modal authentication failed or was cancelled.");
                }
            }
            
            println!("\nPress any key to return to Motus CLI...");
            
            // Wait for user to press any key before returning to TUI
            let _ = crossterm::event::read();
            
            // Restore UI
            enable_raw_mode().unwrap();
            execute!(std::io::stdout(), crossterm::terminal::EnterAlternateScreen).unwrap();
            terminal.clear().unwrap();
        }

        if app.pending_search {
            app.pending_search = false;
            let tx = tx.clone();
            let query = app.search_input.clone();
            
            let (prog_tx, mut prog_rx) = tokio::sync::mpsc::channel(32);
            let tx2 = tx.clone();
            tokio::spawn(async move {
                while let Some(prog) = prog_rx.recv().await {
                    let _ = tx2.send(AppAction::SearchProgress(prog)).await;
                }
            });

            tokio::spawn(async move {
                let res = crate::annas_archive::search_books(&query, Some(prog_tx)).await;
                let _ = tx.send(AppAction::SearchDone(res.map_err(|e| e.to_string()))).await;
            });
        }

        if app.pending_download {
            app.pending_download = false;
            let tx = tx.clone();
            let book = app.selected_book.clone().unwrap();
            let api_key = app.api_key_input.clone();
            
            let (prog_tx, mut prog_rx) = tokio::sync::mpsc::channel(32);
            let tx2 = tx.clone();
            tokio::spawn(async move {
                while let Some(prog) = prog_rx.recv().await {
                    let _ = tx2.send(AppAction::DownloadProgress(prog)).await;
                }
            });

            tokio::spawn(async move {
                let res = crate::annas_archive::download_book(&book, &api_key, Some(prog_tx)).await;
                let _ = tx.send(AppAction::DownloadDone(res.map_err(|e| e.to_string()))).await;
            });
        }
        
        if app.pending_tag_recommendation {
            app.pending_tag_recommendation = false;
            let tx = tx.clone();
            // Just use the filename part of the path
            let filename = std::path::Path::new(&app.dataset_path_input)
                .file_name()
                .unwrap_or_default()
                .to_string_lossy()
                .to_string();
            let api_key = std::env::var("GEMINI_API_KEY").unwrap_or_default();
            
            tokio::spawn(async move {
                let res = crate::dataset_gen::recommend_tags(&filename, &api_key).await;
                let _ = tx.send(AppAction::TagRecommendation(res.map_err(|e| e.to_string()))).await;
            });
        }

        if app.pending_dataset_gen {
            app.pending_dataset_gen = false;
            let tx = tx.clone();
            let file_path = app.dataset_path_input.clone();
            let tags_input = app.dataset_tags_input.clone();
            // Read GEMINI_API_KEY from environment
            let api_key = std::env::var("GEMINI_API_KEY").unwrap_or_default();
            
            let (prog_tx, mut prog_rx) = tokio::sync::mpsc::channel(32);
            let tx2 = tx.clone();
            tokio::spawn(async move {
                while let Some(msg) = prog_rx.recv().await {
                    let _ = tx2.send(AppAction::DatasetMessage(msg)).await;
                }
            });

            tokio::spawn(async move {
                let res = crate::dataset_gen::run_dataset_generation(&file_path, &api_key, &tags_input, Some(prog_tx)).await;
                let _ = tx.send(AppAction::DatasetDone(res.map_err(|e| e.to_string()))).await;
            });
        }
        
        if app.pending_lora_train {
            app.pending_lora_train = false;
            let tx = tx.clone();
            
            // Get selected datasets
            let dataset_paths: Vec<String> = app.selected_datasets.iter().map(|info| {
                format!("data/datasets/{}", info.name)
            }).collect();
            let lora_name = app.lora_name_input.clone();
            
            let (prog_tx, mut prog_rx) = tokio::sync::mpsc::channel(32);
            let tx2 = tx.clone();
            tokio::spawn(async move {
                while let Some(msg) = prog_rx.recv().await {
                    let _ = tx2.send(AppAction::LoraMessage(msg)).await;
                }
            });

            tokio::spawn(async move {
                let res = crate::lora_train::run_lora_training(dataset_paths, &lora_name, Some(prog_tx)).await;
                let _ = tx.send(AppAction::LoraDone(res.map_err(|e| e.to_string()))).await;
            });
        }

        tokio::select! {
            Some(Ok(event)) = reader.next() => {
                match event {
                    Event::Key(key) => {
                        if key.code == KeyCode::Char('c') && key.modifiers.contains(KeyModifiers::CONTROL) {
                            return Ok(());
                        }
                        app.handle_key_event(key);
                        if app.should_quit {
                            return Ok(());
                        }
                    }
                    Event::Resize(_, _) => {
                        // Let the loop tick to redraw immediately
                    }
                    _ => {}
                }
            }
            Some(action) = rx.recv() => {
                match action {
                    AppAction::SearchProgress(progress) => {
                        app.search_progress = progress;
                    }
                    AppAction::SearchDone(Ok(books)) => {
                        app.search_results = books;
                        app.sort_results();
                        if app.search_results.is_empty() {
                            app.error_message = Some("No books found.".to_string());
                            app.current_screen = crate::app::CurrentScreen::AnnasArchiveError;
                        } else {
                            app.current_screen = crate::app::CurrentScreen::AnnasArchiveResults;
                        }
                    }
                    AppAction::SearchDone(Err(e)) => {
                        app.error_message = Some(e);
                        app.current_screen = crate::app::CurrentScreen::AnnasArchiveError;
                    }
                    AppAction::DownloadProgress(progress) => {
                        app.download_progress = progress;
                    }
                    AppAction::DownloadDone(Ok(path)) => {
                        app.download_path = Some(path);
                        app.current_screen = crate::app::CurrentScreen::AnnasArchiveDone;
                        notify("Motus CLI", "Book downloaded successfully!");
                    }
                    AppAction::DownloadDone(Err(e)) => {
                        app.error_message = Some(e);
                        app.current_screen = crate::app::CurrentScreen::AnnasArchiveError;
                    }
                    AppAction::DatasetMessage(msg) => {
                        match msg {
                            crate::dataset_gen::DatasetGenMessage::Progress(p) => app.dataset_progress = p,
                            crate::dataset_gen::DatasetGenMessage::Log(log) => {
                                app.dataset_logs.push(log);
                                if app.dataset_auto_scroll {
                                    app.dataset_logs_state.select(Some(app.dataset_logs.len().saturating_sub(1)));
                                }
                            }
                        }
                    }
                    AppAction::TagRecommendation(res) => {
                        app.is_fetching_tags = false;
                        match res {
                            Ok(tags) => app.dataset_tags_input = tags,
                            Err(err) => app.dataset_tags_input = format!("Error: {}", err),
                        }
                    }
                    AppAction::DatasetDone(Ok(path)) => {
                        app.dataset_path_input = path; // Reuse this field to store output path for success screen
                        app.current_screen = crate::app::CurrentScreen::DatasetGenDone;
                        notify("Motus CLI", "Dataset generation complete!");
                    }
                    AppAction::DatasetDone(Err(e)) => {
                        app.error_message = Some(e);
                        app.current_screen = crate::app::CurrentScreen::DatasetGenError;
                    }
                    AppAction::LoraMessage(msg) => {
                        match msg {
                            crate::lora_train::LoraTrainMessage::Log(log_msg) => {
                                app.lora_logs.push(log_msg);
                                let len = app.lora_logs.len();
                                if len > 0 && app.lora_auto_scroll {
                                    app.lora_logs_state.select(Some(len - 1));
                                }
                            }
                        }
                    }
                    AppAction::LoraDone(Ok(path)) => {
                        app.lora_output_gguf = path;
                        app.current_screen = crate::app::CurrentScreen::LoraTrainDone;
                        notify("Motus CLI", "LoRA Adapter training complete!");
                    }
                    AppAction::LoraDone(Err(e)) => {
                        app.error_message = Some(e);
                        app.current_screen = crate::app::CurrentScreen::LoraTrainError;
                    }
                }
            }
        }

        if app.should_quit {
            return Ok(());
        }
    }
}
