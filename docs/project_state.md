# MyoTwin — Project State & Progress Ledger

## 🎯 The North Star

Build a privacy-first, biomechanical research & coaching app using Flutter, Drift, and Motus (the local inference model with external auditor support) featuring a 3D interactive muscle heatmap and a Scientific Hypothesis Engine — all running offline with multi-device sync.

## 📍 Current Phase

- [x] Product vision & specification complete
- [x] Agent instructions & architecture rules drafted
- [x] Design language & visual system complete
- [ ] Phase 1: Core Architecture & Drift Schema (Next)
- [ ] Phase 1.5: Theme Implementation & Design Tokens
- [ ] Phase 2: 3D Body Map & Shader Implementation
- [ ] Phase 3: Local LLM Integration & Audio Dialog
- [ ] Phase 4: Kinetic Chain Engine & Hypothesis Tracking
- [ ] Phase 5: Research Audit Loop (Background Tasks)
- [ ] Phase 6: Multi-Device Sync (mDNS/WebSockets)
- [ ] Phase 7: Testing, Polish, Release

## ✅ Decisions Made

| # | Decision | Rationale | Date |
|---|---|---|---|
| D1 | BLoC for state management | Dense documentation, strong agent examples, strict event-driven pattern | 2026-05-09 |
| D2 | Drift (SQLite) over NoSQL | Relational data (exercise → feedback → pain), portability, SQL clarity | 2026-05-09 |
| D3 | Clean Architecture (3-layer) | Extensibility, testable domain layer, swappable LLM backend | 2026-05-09 |
| D4 | Local-first: Motus via mediapipe, Motus external auditor on Ollama | Privacy, no external dependency, works offline, GPU-assisted research | 2026-05-09 |
| D5 | External Ollama for research | GPU compute offload, deep audit capability | 2026-05-09 |
| D6 | Monorepo via melos | Isolated packages, clear boundaries, shared core | 2026-05-09 |
| D7 | Body map: 3D muscle model (GLB) | Rotation, vertex-based heatmap, anatomical accuracy | 2026-05-09 |
| D8 | FAB: slide-to-lock mic | Hands-free during exercise, live transcription, intuitive | 2026-05-09 |
| D9 | Natural language symptom input | Model tags symptoms, more flexible than fixed lists | 2026-05-09 |
| D10 | Agent uses scientific method | Hypothesis → Test → Observe → Refine loop | 2026-05-09 |
| D11 | User overrides disable chains | Certainty score set to -1.0 on dismiss | 2026-05-09 |
| D12 | 3 overlay modes (Mobility / Strength / Work Capacity) | Separate concerns, different heat/chain semantics per mode | 2026-05-09 |
| D13 | Scientific explanation in suggestions | Agent cites sources and explains reasoning | 2026-05-09 |
| D14 | Isolate-based performance | 16ms rule, no UI lockup | 2026-05-09 |
| D15 | mDNS + WebSocket for sync | Mac Mini as primary source of truth, no cloud needed | 2026-05-09 |
| D16 | Conventional Commits for all commits | Standardized history, agent-readable diffs, easy bisect | 2026-05-09 |
| D18 | MyoTwin = app, Motus = inference model | Clear identity: MyoTwin is the application wrapper; Motus is the AI model running inside it | 2026-05-09 |

## 🛠️ Commit Convention

All commits MUST follow Conventional Commits format:

```
<type>(<scope>): <description>
```

| Type | Use |
|---|---|
| `feat` | New functionality |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code restructuring (no new features) |
| `perf` | Performance improvement |
| `test` | Adding/updating tests |
| `chore` | Build tooling, deps, CI |
| `ci` | CI config changes |
| `build` | Build system/dependency changes |
| `revert` | Revert a commit |

**Scope**: package name or layer (`db`, `core`, `llm`, `app`, or full feature path).
- Subject ≤100 chars, imperative, no period.
- Body explains *why*, not *what*. Blank for trivially obvious changes.
- Reference planning docs in footer: `Refs: project_state.md Phase 1`.

---

## 🛠️ Task Breakdown

### Phase 1.5: Theme Implementation & Design Tokens

| Status | Task | Priority | Linked Hurdle |
|---|---|---|---|
| ⬜ | Create `design_system.md` with tokens (palette, typography, shape, motion, widget specs) | High | — |
| ⬜ | Implement `app_theme.dart` with full `ThemeData` | High | — |
| ⬜ | Implement reusable themed components (buttons, elevated cards, FAB variants, chat bubbles, navigation) | High | — |
| ⬜ | Add Google Fonts (Space Mono, JetBrains Mono) to pubspec | Med | — |
| ⬜ | Add SVG assets (grid background, scanlines, noise overlay) | Low | — |
| ⬜ | Implement FAB animation states (rest → hover → active → hot → locked) | High | — |
| ⬜ | Implement scan-in and holographic transition animation classes | High | — |

### Phase 1: Core Architecture & Drift Schema

| Status | Task | Priority | Linked Hurdle |
|---|---|---|---|
| ⬜ | Initialize melos monorepo and create package scaffolding | High | — |
| ⬜ | Define `myotwin_core` entities (Symptom, Exercise, Hypothesis, Source, etc.) | High | — |
| ⬜ | Define Drift schema with all tables from agents.md | High | — |
| ⬜ | Implement `DatabaseIsolate` and `DatabaseExportService` | High | — |
| ⬜ | Create `ModelCoordinator` interface and default implementation | Medium | — |
| ⬜ | Scaffold `myotwan_features/hypothesis_engine/` | Med | — |
| ⬜ | Scaffold `myotwan_features/kindetic_chains/` | Med | — |
| ⬜ | Define BLoC events/states for `symptom_tracker` feature | Med | — |
| ⬜ | Setup `system_health.md` | Low | — |

### Phase 2: 3D Body Map

| Status | Task | Priority | Linked Hurdle |
|---|---|---|---|
| ⬜ | Load GLB model with named vertex groups | High | — |
| ⬜ | Implement heatmap color shader / vertex coloring | High | — |
| ⬜ | Kinetic chain Bezier curve overlay | High | — |
| ⬜ | Tap/rotate/zoom interaction events | Med | — |
| ⬜ | 3-mode overlay selector UI | Med | — |

### Phase 3: Local LLM & Audio

| Status | Task | Priority | Linked Hurdle |
|---|---|---|---|
| ⬜ | Implement Motus local inference client (mediapipe) | High | — |
| ⬜ | Implement Motus external auditor client (Ollama OpenAI-compatible) | High | — |
| ⬜ | FAB state machine widget with all gesture modes | High | — |
| ⬜ | Live transcription (speech_to_text) | High | — |
| ⬜ | TTS audio dialog mode (hands-free) | High | — |
| ⬜ | Chat bottom sheet with context injection | Med | — |

### Phase 4: Hypothesis Engine

| Status | Task | Priority | Linked Hurdle |
|---|---|---|---|
| ⬜ | UseCase: create Hypothesis from symptom patterns | High | — |
| ⬜ | UseCase: update certainty scores from feedback | High | — |
| ⬜ | Repository: Hypothesis persistence (Drift) | High | — |
| ⬜ | BLoC: hypothesis_engine (manage state for UI) | Med | — |
| ⬜ | Dossier View widget (symptom history, theories, sources) | Med | — |

### Phase 5: Background Research

| Status | Task | Priority | Linked Hurdle |
|---|---|---|---|
| ⬜ | workmanager setup for periodic task | High | — |
| ⬜ | Background auditor: fetch DB snapshot, send to Ollama | High | — |
| ⬜ | Parse auditor response, update hypotheses/notes | High | — |
| ⬜ | Dynamic notification scheduling | High | — |
| ⬜ | Notification deep-link via GoRouter | Med | — |

### Phase 6: Multi-Device Sync

| Status | Task | Priority | Linked Hurdle |
|---|---|---|---|
| ⬜ | bonsoir mDNS discovery widget | High | — |
| ⬜ | WebSocket server on Mac, client on phone | High | — |
| ⬜ | Database export/import for manual sync | Med | — |
| ⬜ | Conflict resolution strategy | Med | — |

### Phase 7: Testing & Polish

| Status | Task | Priority | Linked Hurdle |
|---|---|---|---|
| ⬜ | Unit tests for all BLoCs (Phase 1-4) | High | — |
| ⬜ | Widget tests: FAB, ChatSheet, BodyMap, Dossier | High | — |
| ⬜ | Integration test: full session flow | Med | — |
| ⬜ | Coverage target 80%+ | Med | — |
| ⬜ | Performance profiling (UI smoothness, memory) | Med | — |

## 📝 Session Handoff History

### 🔄 Session Handoff Protocol

#### Session #0 — Initial Planning
- **What I finished**: Created `product_spec.md`, `agents.md`, `architecture_rules.md`, `project_state.md`, `hurdle_tracker.md`.
- **Where I stopped**: All planning documents written. No code written yet.
- **Current Blockers**: None — planning phase complete.
- **Immediate Next Step**: Initialize melos monorepo and scaffold `myotwan_core` + first Drift schema tables.
- **Confidence Level**: 5 (spec is comprehensive and unambiguous)
- **Date**: 2026-05-09

---

**Document version**: 1.0
**Last updated**: 2026-05-09
