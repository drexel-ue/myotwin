# New Developer Orientation Guide

Welcome to MyoTwin. This guide is designed to get you from "zero to hero" as a contributor. It assumes you have a basic understanding of Flutter but might be new to advanced topics like local LLMs, native 3D rendering, or unstructured data architectures.

---

## 1. The Learning Path (Recommended Reading)

To understand the project, read these documents in order:

1.  **[VISION.md](./VISION.md)**: **Start here.** Understand the "Why." Why does this app exist? What is the core experience we are aiming for?
2.  **[PRODUCT.md](./PRODUCT.md)**: The technical blueprint. Learn about the shift from "screens" to "surfaces" and how the AI interacts with the user.
3.  **[DESIGN_SYSTEM.md](./DESIGN_SYSTEM.md)**: The visual language. Understand our "Black & White Cyberpunk" aesthetic, HUD typography, and motion curves.
4.  **[Technical Feature Deep-Dives](./features/README.md)**: Once you have the context, explore the specific implementations:
    *   **3D Digital Twin**: How we render anatomy.
    *   **Biomechanical Intelligence**: How the AI "thinks."
    *   **Unstructured Data Strategy**: How we store complex AI data.
5.  **[GOVERNANCE.md](./GOVERNANCE.md)**: The rules of the road. Coding standards, package boundaries, and architecture mandates.

---

## 2. Core Technical Pillars

MyoTwin stands on three unique technical pillars. You should familiarize yourself with these concepts:

### A. Local LLM Inference (`llamadart`)
We do not use OpenAI or cloud APIs for real-time interaction. We run models directly on the device using `llamadart`.
*   **Concepts**: GGUF format, Quantization (Q4 vs Q8), LoRA adapters.
*   **External Reading**: [llamadart documentation](https://pub.dev/packages/llamadart) | [llama.cpp overview](https://github.com/ggerganov/llama.cpp).

### B. Native 3D Rendering (`flutter_scene`)
The Digital Twin is rendered using Flutter's high-performance Impeller engine.
*   **Concepts**: GLB/GLTF assets, PBR (Physically Based Rendering), Fragment Shaders.
*   **External Reading**: [flutter_scene intro](https://pub.dev/packages/flutter_scene) | [Impeller Architecture](https://docs.flutter.dev/perf/impeller).

### C. Unstructured Data Strategy
We avoid frequent SQL migrations by using a hybrid data model.
*   **Concepts**: JSONB columns, Drift TypeConverters, Dart 3.3 Extension Types.
*   **Why?**: This allows the AI's "brain" to evolve its data format without breaking the app's database.

---

## 3. Application Architecture: Service-Repository-Cubit

MyoTwin follows a strict layered decoupling pattern to ensure testability and high-signal traceability.

### The Flow of Responsibility
1.  **Services (Single-Concern)**: Low-level wrappers for external resources. 
    *   *Examples*: `LoggerService` (Diagnostics), `DatabaseService` (Drift), `MotusService` (Local LLM).
2.  **Repositories (Domain Orchestration)**: Orchestrate multiple services to manage a conceptual domain.
    *   *Examples*: `ChatRepository` (AI + Persistence), `SettingsRepository` (Prefs + FileSystem).
3.  **Cubits (UI State)**: Manage the immediate state of a widget tree and call Repositories for logic.
    *   *Example*: `ChatCubit` (isThinking, messageList).

### Logging & Diagnostics
We use [mason_logger](https://pub.dev/packages/mason_logger) via the `LoggerService` to create a "black box" for the application.
*   **Loggable Contract**: All state and domain models implement the `Loggable` interface, providing both detailed diagnostics and high-level summaries.
*   **Automatic Traceability**: The `MyoBlocObserver` automatically logs every state transition using these descriptive strings.

---

## 4. Knowledge Points & External Resources

If you encounter a concept that seems "alien," check these resources:

| Concept | Resource |
| :--- | :--- |
| **Monorepo Management** | [Melos Documentation](https://melos.invertase.dev/) |
| **State Management** | [Flutter BLoC / Cubit](https://bloclibrary.dev/) |
| **Structured Logging** | [mason_logger](https://pub.dev/packages/mason_logger) |
| **Reactive Database** | [Drift (formerly Moor)](https://drift.simonbinder.eu/) |
| **Service Discovery** | [Bonsoir (Zeroconf/mDNS)](https://pub.dev/packages/bonsoir) |
| **Vector Math** | [vector_math package](https://pub.dev/packages/vector_math) |

---

## 5. Setting Up Your HUD

1.  Run `melos bootstrap` to link all internal packages.
2.  Open **`packages/myotwin_app`**. This is the entry point for all platforms.
3.  Target **macOS** or **iPhone** (ensure Impeller is enabled).
4.  Launch and watch the "Cinematic Boot" sequence.
5.  **Audit the Logs**: Check your console for high-signal formatted output from the `LoggerService`.

---

**Questions?** Start a discussion in the [Decision Log](./GOVERNANCE.md#decision-log) or reach out to the lead architect. We're building the future of biomechanics — glad to have you on board.
