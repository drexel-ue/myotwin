# MyoTwin — Product Specification (GenUI Edition)

## 1. Vision & Core Objective

**MyoTwin** is a privacy-first, local-only **Generative UI** application for functional strength, work capacity, and mobility coaching. It treats the user's physical state as an N=1 clinical trial, utilizing a **3D Digital Twin** as the primary interface and the **Motus** agent as the intelligence layer.

The application does not use predefined, static screens. Instead, it utilizes a **Surface-based architecture** via `genui`. The UI is dynamically assembled by the **Motus** agent using a library of structured **CatalogItems** (widgets) based on the current biomechanical context.

Core capabilities:
- **3D Digital Twin**: A persistent, interactive GLB model representing the user's physiological state.
- **GenUI Orchestration**: The UI is a collection of "Surfaces" (Chat, Context, Action) generated in real-time by the AI.
- **Motus local inference**: Gemma 4:e4b via MediaPipe for fast chat, voice interaction, and real-time symptom tagging.
- **Motus external auditor**: Ollama via OpenAI-compatible API for deep research and hypothesis formulation.
- **Privacy-First**: All data stays local. No telemetry. No cloud dependency.

## 2. Tech Stack (GenUI Optimized)

| Layer | Technology |
|---|---|
| **UI Framework** | Flutter (latest stable) |
| **Generative UI Engine** | `genui` (Surface-based widget assembly) |
| **UI Vocabulary** | `json_schema_builder` (for CatalogItem schema definition) |
| **State Management** | `genui` `DataModel` (Reactive, path-based observable state) |
| **Database** | Drift (SQLite, background isolate) |
| **Local LLM** | Gemma 4:e4b via MediaPipe LLM Inference |
| **External LLM** | Ollama (OpenAI-compatible) on Unraid GPU server |
| **3D Engine** | Flutter GLB/GLTF (Layered mesh, shader-driven) |
| **Communication** | `bonsoir` (mDNS/Zeroconf) for local discovery |

## 3. Architecture: The Surface-Based Model

The application is organized into three layers of interaction:

### 3.1 The Viewport (The 3D Foundation)
A persistent, interactive 3D viewport containing the user's Digital Twin. This is the "ground truth" surface.

### 3.2 The Interaction Surface (The GenUI Layer)
A stack of transient, AI-generated surfaces managed by `SurfaceController`.
- **The Chat Surface**: Triggered by FAB. Handles text/speech interaction.
- **The Context Surface**: Triggered by 3D tapping. Displays the "Catalog" of information relevant to a specific anatomical node (e.g., `InjurySummaryCard`, `TrainingLogList`).
- **The Action Surface**: Triggered by Motus. Overlays mission-critical instructions (e.g., `ProtocolFollower`, `PosturalCheck`).

### 3.3 The Catalog (The Widget Vocabulary)
A collection of `CatalogItem` primitives that the AI can instantiate.
- **Anatomical Primitives**: `MetricCard`, `TrendGraph`, `KinothecialLink`.
- **Interaction Primitives**: `ActionBtn`, `InputForm`, `Checklist`.
- **Data Primitives**: `TimestampedLog`, `IntensitySlider`.

## 4. UI/UX — The "Cyberpunk" Aesthetic

### 4.1 Design System Reference
- **Palette**: Black & white high-contrast. Deep blacks (#000000), pure whites (#FFFFFF). Biological status indicated via color temperature (heatmaps, inflammation).
- **Motion**: "Mechanical/Glitch" aesthetic. Constant-velocity path extraction. Linear easing. "Draw itself" animations for window spawning.
- **Typography**: Monospaced `JetBrains Mono` for data/labels.

### 4.2 The FAB Interaction Pipeline
The FAB is the single entry point for all Motus interactions.
- **Single Tap**: Opens the `Chat Surface`.
- **Long Press**: Activates `Speech-to-Text` (STT) mode.
- **Long Press + Slide**: Activates "Hot Mic" (Continuous STT + TTS loop).

### 4.3 3D Interaction & Context
Tapping an anatomical node on the 3D model triggers a `genui` event:
1. **Context Retrieval**: System fetches all `Drift` logs/hypotheses for that `node_id`.
2. **Surface Assembly**: The `SurfaceController` assembles a `Context Surface`.
3. **Dynamic Generation**: The AI selects `CatalogItems` (e.ly. `InjuryDetailCard` if an injury is present) based on the retrieved data.

## 5. Functional Modules

### 5.1 The Scientific Hypothesis Engine
Every movement suggestion is a test of a hypothesis.
- **Hypothesis**: `id`, `target_node`, `statement`, `certainty_score` (0.0–1.0).
- **Workflow**: Motus proposes $\rightarrow$ User performs $\rightarrow$ Feedback recorded $\rightarrow$ Score updated.

### 5.2 The Knowledge Ingestion (RAG)
- **Inputs**: PDFs, text, URLs, and user-provided notes.
- **Processing**: Motus Hub parses and indexes via Vector DB.
- **Usage**: Context is injected into the `System Prompt` and `CatalogItem` descriptions during the conversation.

### 5.3 The Injury & Recovery Vault
- **States**: Acute, Dormant, Chronic.
- **Integrity Score**: A physiological real-time score (0.0–1.0) that influences the `S_margin` (Safety Margin) in movement recommendations.

## 6. Non-Functional Requirements
- **Latency**: 16ms rule for UI. All heavy processing (LLM/SQL) on background isolates.
- **Privacy**: Zero-Cloud. Zero-Telemetry. Local-only.
- **Relity**: `Result<T, Failure>` pattern for all LLM/DB calls.

---
**Document version**: 2.0 (GenUI Transition)
**Last updated**: 2/12/2026
