# MyoTwin — Product Specification

## 1. Vision & Core Objective

A privacy-first, local-only Flutter application for functional strength, work capacity, and mobility coaching. The app functions as a proactive biomechanical research agent that:

- Schedules exercises and movements throughout the day based on real-time user feedback.
- Tracks symptoms, builds kinetic chain hypotheses, and adjusts recommendations using the scientific method.
- Runs Motus (the local inference model) on-device via mediapipe with the ability to call out to an external GPU server (Ollama, OpenAI-compatible) for deep research.
- Persists all data locally via Drift (SQLite) in the Application Documents Directory.
- Syncs across devices on the same local network (phone + Mac Workstation).

## 2. Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (latest stable) |
| State Management | BLoC (event/driver pattern) |
| Database | Drift (SQLite, with background isolate) |
| Local LLM | Motus (mediapipe inference) |
| External LLM | Motus external auditor (Ollama, OpenAI-compatible) |
| Background Tasks | workmanager |
| Routing | GoRouter (deep-link support) |
| Speech | speech_to_text (platform-native STT) |
| Speech Output | flutter_tts |
| Notifications | flutter_local_notifications |
| 3D Model | GLB/GLTF (loaded via flutter_vtk or custom import) |
| Local Discovery | bonsoir (mDNS/Zeroconf) |
| Networking | web_socket_channel, dio |
| Error Handling | fpdart (Result<T, Failure>) |
| Vector Search | langchain_dart (local vector store) |
| Monorepo | melos |

## 3. Architecture — Clean Architecture

All features are organized into three layers:

- **Data Layer** — Drift DAOs, API clients (Motus local / Motus external auditor), file imports/exports, background sync.
- **Domain Layer** — Pure Dart entities, repository interfaces, use cases (no Flutter deps).
- **Presentation Layer** — BLoC event/state pairs, widgets (3D Body Map, Chat Sheet, Dossier View).

## 4. Functional Requirements

### 4.1 Magic FAB & Interaction

- **Bottom-anchored FAB** with three interaction modes:
  - **Single tap** → opens chat bottom sheet.
  - **Long press** → activates STT while held.
  - **Long press + slide up (thumb drag)** → locks mic "hot" for hands-free dialgue; release by tapping the FAB again.
- **Live transcription** streams into the UI as the user speaks.
- **Visual feedback**: FAB morphs/pulses while "hot."
- **Audio dialog mode**: TTS drives a back-and-forth conversation so the user never needs to look at the phone while on the pull-up bar.

### 4.2 3D Body Map (Primary UI)

- Anatomical muscle model (GLB) that the user can rotate and pinch zoom.
- Vertex groups for each muscle/symptom hotspot.
- **Heatmap overlay** using emissive color interpolation driven by Drift symptom logs.
- **Functional overlay modes** (toggled via buttons):

| Mode | Heat Represents | Chains Represent |
|---|---|---|
| Mobility | Joint restriction & stiffness | Compensatory patterns (e.g. tight hip → arching lower back) |
| Functional Strength | Muscle fatigue & recovery | Synergistic loops (e.g. grip limiting pull-up volume) |
| Work Capacity | Systemic fatigue / HR zones | Peripheral vs. central fatigue |

- **Kinetic chain overlay**: Bezier curves between connected nodes.
  - Thickness = strength of correlation.
  - Opacity = certainty score (0.0–1.0).
- Tapping a segment opens a detail / dossier view.
- Tapping a chain navigates to chat with agent theory.

### 4.3 Proactive Notification System

- Agent decides **when** to notify based on post-session feedback.
- **Dynamic scheduling**: Agent creates a `NotificationContext` entry in Drift with deep-link UUID.
- Notifications use `flutter_local_notifications`.
- On tap → deep link via GoRouter opens the chat bottom sheet with full context pre-injected (e.g. "I noticed your shoulder was tight 2 hours ago; let's try a hang.").
- Agent may schedule follow-up "follow-ups" immediately after the conversation ends ("How'd that feel?").

### 4.4 Scientific Hypothesis Engine

Every movement suggestion is a test of a hypothesis. Data model:

- **Hypothesis** — `id`, `target_node`, `linked_nodes[]`, `statement`, `certainty_score` (0.0–1.0), `status` (Active, Proven, Refuted, Blacklisted).
- **Source** — `id`, `title`, `author`, `link`, `key_takeaway`, `relationship_to_hypothesis`.
- **Principle** — ingested rules from user-uploaded content (e.g. "Joint-by-Joint Approach").
- Every recommendation is wrapped in a `Hypothesis` object.
- Agent updates certainty scores over time based on user feedback (positive / negative / neutral).

### 4.5 Symptom & Feedback Tracking

- User provides feedback via **natural language** (chat or voice).
- Local LLM tags symptoms: category (Stiffness, Sharp Pain, Dull Ache, Weakness), body part(s), intensity.
- All symptoms feed into the kinetic graph.

### 4.6 Research & Audit Loop (Background)

- `workmanager` triggers periodic background tasks.
- Background task:
  1. Pings local Ollama GPU server for **deep audit**.
  2. Sends symptom logs, hypothesis data, and user-uploaded research material.
  3. Auditor returns updated hypotheses, research notes, and citations.
  4. Writes results into Drift (`ResearchNote`, `Hypothesis`, `Source`).
- Periodically (e.g. every 24h) auditor summarizes findings into a human-readable note.

### 4.7 Knowledge Ingestion

- User can drop PDFs, text snippets, URLs into the app.
- Background auditor parses content into `Principle` entries.
- User can converse: "How should I use this paper on shoulder mobility in my case?"

### 4.8 Data Portability

- Drift database stored in `ApplicationDocumentsDirectory`.
- Export/Import feature: serializes database to `.db` or JSON file.
- `DatabaseExportService` handles backup and restore.

### 4.9 Multi-Device Local Sync

- mDNS discovery via `bonsoir`.
- Mac Mini acts as primary source of truth (stores master `.db`).
- WebSocket sync for logs pushed from phone → Mac, research notes pulled from Mac → phone.
- Graceful degradation: if Mac is offline, phone operates in local-only mode.

### 4.10 Drive / Intensity Settings

- **Global Drive**: user sets overall intensity (e.g. "I'm in a 2-week deload" or "I'm feeling a 3 today").
- Drive is calculated **per-node** (different modes have different intensity levels).
- High symptom heat → regress or avoid movements automatically.
- User can toggle Drive or tell the agent via chat.

## 5. Non-Functional Requirements

| Category | Requirement |
|---|---|
| Performance | 16ms rule — no operation exceeding ~16ms on main isolate. Heavy work offloaded to isolates. |
| Reliability | All LLM calls wrapped in `Result<T, Failure>`. Silent fallback to local-only when external server unreachable. |
| Privacy | All data local. No telemetry. Zero cloud dependency. |
| Memory | Context window janitor — old chat summarized into research notes, then purged. |
| Frame Budget | 3D heatmap color updates debounced to 150ms. |
| Thread Safety | Drift background isolate for all heavy queries. |

## 6. Folder Structure (Monorepo)

```
myotwin/
├── melos.yaml
├── packages/
│   ├── myotwin_core/          # Domain layer: entities, value types, repository interfaces
│   ├── myotwin_db/            # Data layer: DriftDAOs, schema, export service
│   ├── motus_local/           # Motus local inference: mediapipe, context window management, streaming
│   ├── motus_auditor/         # Motus external GPU: Ollama client, batch research, prompt builders
│   ├── myotwin_features/      # Feature packages (one per BLoC group)
│   │   ├── body_map/
│   │   ├── chat/
│   │   ├── hypothesis_engine/
│   │   ├── knowledge_ingestion/
│   │   ├── kinetic_chains/
│   │   ├── notifications/
│   │   ├── research_audit/
│   │   ├── symptom_tracker/
│   │   └── workout_scheduler/
│   ├── myotwin_app/           # Presentation: widgets, navigation, FAB, shell
│   └── myotwin_test_support/  # Shared mocks & fakes
├── docs/
│   ├── product_spec.md
│   ├── agents.md
│   ├── architecture_rules.md
│   ├── project_state.md
│   └── hurdle_tracker.md
├── system_health.md
└── README.md
```

---

**Document version**: 1.0
**Last updated**: 2026-05-09
