# MyoTwin

**A biomechanical coaching app that thinks about you.**

🚀 **New to the project?** Read the **[Developer Orientation Guide](docs/ORIENTATION.md)** to get started.

No static screens. No navigation tabs. No walls of text from an AI. Just a 3D body model and an intelligence that assembles the right interface for *your* body, *right now*.

---

## The Experience

You stand in front of a black void. A 3D figure materializes — your anatomical twin. Heat maps pulse where your body is under strain. You tap a shoulder node, and a panel slides in with your injury history, symptom patterns, and a regression ladder if something's wrong. You press the FAB, speak while hanging from rings: *"left shoulder clicked on the support hold."* Motus tags the symptom, proposes an adjustment, renders it as widgets you can accept or modify.

After your workout, Motus evaluates the session. It notices shoulder symptoms climbing at 100% drive and schedules a notification: *"Try dropping left-side drive to 80% tomorrow. Here's why."* When you tap it, Motus has already pre-loaded the reasoning — the symptom logs, the integrity scores, the kinetic chain analysis — and presents a surface that explains it all.

This is **reactive** (the interface responds to what you touch), **proactive** (Motus nudges you when your data says it's useful), and **adaptive** (Motus learns your patterns, your response rates, your recovery cadence over weeks and months).

MyoTwin is built on the scientific method. Every suggestion is a hypothesis. Every outcome updates the certainty score. You are the principal investigator. Motus is your data analyst.

---

## Key Features

| Feature | Description |
|---|---|
| **3D Digital Twin** | Persistent, interactive GLB model with layered anatomical visualization, heatmap-driven biomechanical status, X-ray dissolve shaders |
| **Generative UI (GenUI)** | UI assembled at runtime by Motus from a widget catalog — surfaces, not screens. Chat, context, and action overlays driven by your biomechanical state |
| **Voice-First Interaction** | FAB long-press activates STT mode; hot-mic mode for hands-free use during exercise |
| **Heuristic Notifications** | Motus schedules contextual nudges based on session data, symptom trends, and learned behavior patterns — never during sleep, never when inappropriate |
| **Scientific Hypothesis Engine** | Every biomechanical suggestion is a hypothesis tracked with certainty scores, refined through user feedback |
| **Injury Vault & Recovery Ladder** | Track injuries (acute/dormant/chronic), integrity scores, and systematic regression/progression paths |
| **Knowledge Graph** | Principles, research findings, and evidence stored locally. Synced from server-side deep research |
| **Equipment Inventory** | Natural language registration of rings, parallettes, mace bells, and more |
| **Privacy-First** | Zero cloud dependency. Zero telemetry. All data local. No location tracking |

---

## Architecture

MyoTwin is a Flutter monorepo structured in three layers:

### Surface Architecture

```
Viewport (3D Body Twin, always present)
    ↑
   Interaction Surfaces (Chat, Context, Action — transient, AI-generated)
    ↑
   Catalog (Widget vocabulary: InjuryDetailCard, RegressionLadder, SymptomInput, etc.)
```

The application uses Flutter's [genui](https://github.com/flutter/genui) framework. Motus generates UI through the A2UI protocol — selecting `CatalogItem` definitions, binding them to reactive data paths, and composing surfaces via `SurfaceController`. User interaction state feeds back through `DataModel` to Motus.

### Intelligence Pipeline

```
Local Motus (Gemma 4 E2B via llamadart/llama.cpp)
    ↑↓
IntentRecords / KnowledgeGraph / ResearchSync
    ↑↓
Server Motus (Ollama GPU)
```

Local Motus handles real-time interaction, heuristic scheduling, and symptom tagging. Server Motus conducts deeper research and syncs findings (Principles, ResearchNotes) back to the client's local knowledge graph.

### Data Model

```
Drift Database (SQLite, background isolate)
       ↔  DataModelBridge  ↔
genui DataModel (reactive, path-based)
       ↔
GenUI Surfaces (user-facing widgets)
```

Core entities use strict relational schemas. Derivative, Motus-shaped data uses JSONB columns — allowing the dataset to evolve as Motus learns, without requiring migrations for every new insight.

### Monorepo Structure

```
myotwin/
├── packages/
│   ├── shared_core/    # Entities, interfaces, and unstructured JSON extension types
│   ├── myotwin_ui/      # High-fidelity HUD components, 3D anatomy viewport, and themes
│   ├── myotwin_app/     # Unified multi-platform application (iOS, Android, macOS)
│   ├── myotwin_catalog/ # Component gallery and interactive GenUI stories
│   └── motus_server/    # Dart-based orchestration hub for research and research sync
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (latest stable) |
| Generative UI | [genui](https://pub.dev/packages/genui) (A2UI protocol) |
| Schema Builder | [json_schema_builder](https://pub.dev/packages/json_schema_builder) |
| Database | [drift](https://pub.dev/packages/drift) (SQLite, background isolate) |
| Local Inference | Gemma 4 E2B (Unsloth Q4_K_M for mobile, Q8_0 for desktop) via llamadart |
| Server Inference | Ollama (OpenAI-compatible API) |
| 3D Rendering | [flutter_scene](https://pub.dev/packages/flutter_scene) (Native Impeller Engine) |
| Device Discovery | [bonsoir](https://pub.dev/packages/bonsoir) (mDNS/Zeroconf) |
| Build | Melos (monorepo management) |

---

## Getting Started

### Prerequisites

- Flutter ≥ 3.35.7
- Dart ≥ 3.x
- (Optional) Ollama server on local network for server-side inference

### Setup

```bash
# Bootstrap the melos monorepo
cd myotwin
melos bootstrap
```

### Run

```bash
# Run the application (all platforms)
cd packages/myotwin_app
flutter run
```

### Lint & Format

```bash
melos run:analyze
melos run:format
```

---

## Design System

MyoTwin uses a black-and-white cyberpunk / HUD aesthetic with deliberate color only for data visualization (heatmap intensity, error states, kinetic chain certainty). Full specification in [DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md).

---

## Documentation

### Core Specifications
| Document | Purpose |
|---|---|
| [docs/PRODUCT.md](docs/PRODUCT.md) | Product specification — GenUI architecture, surface types, Motus intelligence, data model |
| [docs/MULTI_MODEL_ARCHITECTURE.md](docs/MULTI_MODEL_ARCHITECTURE.md) | Multi-model LLM strategy — Gemma E2B + LoRA adapters (fitness, medical, biomechanics) |
| [docs/DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md) | Visual design tokens, palette, typography, motion, widget specs |
| [docs/MOTUS_TOOL_SPEC.md](docs/MOTUS_TOOL_SPEC.md) | Tool calling interface for Motus (calculators, database, UI orchestration) |
| [docs/GOVERNANCE.md](docs/GOVERNANCE.md) | Architecture rules, decision log, agent instructions, commit conventions |
| [docs/VISION.md](docs/VISION.md) | Feature backlog and roadmap |

### [Technical Feature References](docs/features/)
Deep-dives into specific implemented subsystems.
- [**3D Digital Twin**](docs/features/3d_digital_twin.md): Anatomy viewport, shaders, and heatmap logic.
- [**Biomechanical Intelligence**](docs/features/biomechanical_intelligence.md): Semantic context, kinetic chain awareness, and context switching.
- [**Interactive GenUI Model**](docs/features/interactive_genui_model.md): Hardware-inspired HUD interactions (FAB sliders, rotary menus).
- [**Unstructured Data Strategy**](docs/features/unstructured_data_strategy.md): Drift JSONB and Dart 3.3 Extension Type wrappers.
- [**3D Asset Pipeline**](docs/features/3d_asset_pipeline.md): Blender-to-Flutter workflow and optimization.

---

## Licensing

MyoTwin is open-source. See individual packages for specific licenses.

genui is under the BSD 3-Clause license (Google LLC).
