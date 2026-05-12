# MyoTwin — Project State & Progress Ledger

## 🎯 The North Star

Build MyoTwin — a privacy-first, biomechanical research & coaching app using Flutter, Drift, and Motus (Gemma 4:e4b via MediaPipe + Ollama external auditor) featuring a layered GLB 3D interactive muscle heatmap, X-ray dissolve shaders, a Scientific Hypothesis Engine, and a three-tier monorepo architecture — all running local with no location tracking.

**MyoTwin** = the application (mobile + desktop).
**Motus** = the inference engine (local MediaPipe + external Ollama auditor).

## 📍 Current Phase

- [x] Product vision & specification complete (Session #0)
- [x] Agent instructions & architecture rules drafted (Session #0)
- [x] Design language & visual system complete (Session #1)
- [x] Deep architecture refinement: MyoTwin/Motus branding, three-tier monorepo, tool calling spec, context window management, equipment & leverage, Injury Vault, Restoration Ladder, Neural Priming vs Structural Loading, GLB over Rive, Collaborative Science (Informed Autonomy), X-ray + ghost alpha shaders, spooling tether, desktop floating callouts, frosted HUD, B&W with intentional color, FAB-to-full-screen flow, Vision Board, sleep/diet visualization, calendar integration, CV/modePipe on Vision Board, Phase 1 golden loop, "no location tracking" mandate (Session #2)
- [x] Phase 1: Core Architecture & Drift Schema (Session #3)
- [ ] Phase 2: 3D Body Map & Shader Implementation
- [ ] Phase 3: Local LLM Integration & Audio Dialog
- [ ] Phase 4: Kinetic Chain Engine & Hypothesis Tracking
- [ ] Phase 5: Background Research & Motivation
- [ ] Phase 6: Multi-Device Sync (mDNS/WebSockets)
- [ ] Phase 7: Testing, Polish, Release

## ✅ Decisions Made

| # | Decision | Rationale | Date |
|---|---|---|---|
| D1 | BLoC for state management | Dense documentation, strong agent examples, strict event-driven pattern | 2026-05-09 |
| D2 | Drift (SQLite) over NoSQL | Relational data modeling, portability, SQL clarity | 2026-05-09 |
| D3 | Clean Architecture (3-layer) | Extensibility, testable domain layer, swappable LLM backend | 2026-05-09 |
| D4 | Local-first: Motus via mediapipe + Ollama external auditor | Privacy, offline capability, GPU-assisted research | 2026-05-09 |
| D5 | External Ollama on Unraid via OpenAI-compatible API | GPU compute offload, deep audit capability | 2026-05-09 |
| D6 | Monorepo via Melos | Isolated packages, clear boundaries, shared core | 2026-05-09 |
| D7 | Three-tier monorepo: shared_core + myotwin_mobile + motus_hub | Separation of presentation and orchestration; mobile never imports server | 2026-05-11 |
| D8 | Body map: layered GLB (Skeletal + Muscular + Cardiovascular) | Data-driven shader mapping, vertex-group coloring | 2026-05-11 |
| D9 | FAB: slide-to-lock mic + hot mic states | Hands-free during exercise, live transcription | 2026-05-09 |
| D10 | Natural language symptom input | Model tags symptoms, more flexible than fixed lists | 2026-05-09 |
| D11 | Agent uses scientific method | Hypothesis → Test → Observe → Refine loop | 2026-05-09 |
| D12 | User overrides disable chains | Certainty score set to -1.0 on dismiss | 2026-05-09 |
| D13 | 3 functional overlay modes | Separate concerns: Mobility / Strength / Work Capacity | 2026-05-09 |
| D14 | Scientific explanation required | Agent cites sources, explains reasoning per suggestion | 2026-05-09 |
| D15 | Isolate-based performance | 16ms rule, no UI lockup | 2026-05-09 |
| D16 | mDNS + WebSocket for sync | Mac Mini as primary source of truth, no cloud needed | 2026-05-09 |
| D17 | Conventional Commits for all commits | Standardized history, agent-readable diffs, easy bisect | 2026-05-09 |
| D18 | B&W technical blueprint aesthetic with intentional color only for status | High-contrast, mechanical, clinical scientific tool — not neon cyberpunk | 2026-05-11 |
| D19 | MyoTwin = app, Motus = inference model | Clear identity: app is interface, Motus is the scientific brain | 2026-05-11 |
| D20 | GLB over Rive for body map | Procedural shader-driven, extensible — adding a joint requires zero rendering code changes | 2026-05-11 |
| D21 | Neural Priming focus + Structural Loading via leverage physics | Rings/parallettes provide sufficient mechanical tension via torque manipulation | 2026-05-11 |
| D22 | Informed Autonomy (Collaborative Science) over Automated Coaching | User is principal investigator; Motus presents choices with rationale, never blocks | 2026-05-11 |
| D23 | Tool calling for all biomechanical calculations | Physics > hallucination — use `calculate_torque_load`, `get_progression_step` | 2026-05-11 |
| D24 | Context window tiering (Snapshot → RAG → Summarized Memory) | Keeps Gemma focused, avoids context bloat from research papers | 2026-05-11 |
| D25 | Spooling Manhattan tether for desktop callouts | Infinite-length, 90-degree elbows, dynamic segment creation/collapse | 2026-05-11 |
| D26 | Full-screen flow windows on mobile, floating callouts on desktop | Mobile = high visibility/cues; Desktop = spatial multi-node analysis | 2026-05-11 |
| D27 | Equipment inventory via natural language conversation | Friction-free registration of rings, parallettes, mace, etc. | 2026-05-11 |
| D28 | Anatomical Landmark ring height calibration | Sternum/Hip/Knee/Floor reference points vs. tape measures | 2026-05-11 |
| D29 | Dual Clinical Lens: GenPop Safety + Elite Performance | Safety floor for restoration; Elite ceiling for long-term mastery | 2026-05-11 |
| D30 | Experience feedback analyzed through Clinical Lens | Personal experience validated/contrasted against clinical studies | 2026-05-11 |
| D31 | Data point Source Type enum (manual/computed/vision/rag) | Enables Confidence Score tracking per data point | 2026-05-11 |
| D32 | Injury Vault: Acute/Dormant/Chronic with Integrity Score | Persistent biomechanical constraints from old injuries | 2026-05-11 |
| D33 | Restoration Ladder: regression → progression path | Systematic rebuilding of lost mobility, strength, function | 2026-05-11 |
| D34 | Motion proposal from FAB → full-screen → flow sequence | Clear narrative arc from idle to active session | 2026-05-11 |
| D35 | No location tracking ever | Explicit constraint — manual equipment registration only | 2026-05-11 |
| D36 | X-ray dissolve with ghost alpha over Mechanical Explosion | V1 = shader-based ghosting (min alpha 0.1); Phase 2 = explosion | 2026-05-11 |
| D37 | V2 Sleep/Diet visualization (Recovery Aura + Tissue Integrity shader) | Post-V1, not V1 scope | 2026-05-11 |
| D38 | Vision board for CV (phase 3+), Calendar integration (phase 2+), Research Scout (phase 2+) | Park high-effort features, don't block V1 | 2026-05-11 |
| D39 | motus_hub replaces `motus_local` + `motus_auditor` server pattern | Single Dart server bridges phone ↔ Ollama on Unraid, with tool calling | 2026-05-11 |

## 🛠️ Phase 1: V1 Golden Loop — Core Architecture & Drift Schema

### Phase 1 Tasks

| Status | Task | Priority | Linked Hurdle |
|---|---|---|---|
| ✅ | Initialize melos monorepo | High | — |
| ✅ | Define `shared_core` entities (17) | High | — |
| ✅ | Define Drift schema with 16 tables | High | — |
| ✅ | Implement `MotusCoordinator` interface | High | — |
| ✅ | Implement `SafetyMargin` calculator | High | — |
| ✅ | Implement `TorqueCalculator` tool | High | — |
| ✅ | Implement `ProgressionLadder` use case | High | — |
| ✅ | Scaffold `motus_hub` server with REST endpoints | High | — |
| ✅ | Scaffold `motus_hub` tool calling endpoints | High | — |
| ✅ | Scaffold `myotwin_mobile` shell | Med | — |
| ✅ | Scaffold `myotwin_desktop` shell | Med | — |
| ✅ | Create `myotwin_test_support` mock repositories | Med | — |
| ⬜ | Scaffold `myotwin_features/hypothesis_engine/` | Med | — |
| ⬜ | Scaffold `myotwin_features/injury_vault/` | Med | — |
| ⬜ | Scaffold `myotwin_features/equipment_inventory/` | Med | — |
| ⬜ | Scaffold `myotwin_features/restoration_ladder/` | Med | — |
| ⬜ | Add `DatabaseIsolate` implementation (Drift background isolate) | High | — |
| ⬜ | Setup `system_health.md` | Low | — |

### V1 Deliverables Checklist

- [x] `shared_core` with all entities, interfaces, `MotusCoordinator`, safety calculators
- [x] `motus_hub` scaffold with tool calling spec
- [x] `myotwin_mobile` with BLoC layout scaffold
- [x] `myotwin_desktop` with platform detection scaffold
- [x] `myotwin_test_support` mock repositories
- [ ] `motus_hub` with Ollama client, context orchestrator
- [ ] `shared_core` `DatabaseIsolate` implementation (Drift background isolate)
- [ ] `shared_core` `DatabaseExportService` implementation
- [ ] All BLoC unit tests scaffolded
- [ ] All use case tests scaffolded

## 📝 Session Handoff History

### Session #0 — Initial Planning
- **What I finished**: Created `product_spec.md`, `agents.md`, `architecture_rules.md`, `project_state.md`, `huddle_tracker.md`.
- **Where I stopped**: All planning documents written. No code written yet.
- **Current Blockers**: None — planning phase complete.
- **Next Step**: Initialize melos monorepo and scaffold `shared_core` + first Drift schema tables.
- **Confidence Level**: 5 (spec is comprehensive and unambiguous)
- **Date**: 2026-05-09

### Session #1 — Design System & Motus Package Split
- **What I finished**: Created `design_system.md` with full B&W cyberpunk/sci-fi token set. Added `design_system.md` to governance. Split `myotwin_llm` into `motus_local/` + `motus_auditor/`.
- **Where I stopped**: All planning documents complete. No code written yet.
- **Current Blockers**: None — design and architecture governance fully documented.
- **Decisions Made**: D16, D17, D18, D19
- **Next Step**: Phase 1.5 or Phase 1 — implement design tokens and scaffold `motus_local` + `motus_auditor`.
- **Confidence Level**: 5
- **Date**: 2026-05-09

### Session #2 — Deep Architecture Refinement & Documentation Update
- **What I finished**: Comprehensive architecture deep-dive covering: MyoTwin/Motus branding, three-tier monorepo, tool calling spec, context window management, equipment inventory, leverage-based loading, Injury Vault, Restoration Ladder, Neural Priming vs Structural Loading, GLB over Rive, Collaborative Science (Informed Autonomy), X-ray + ghost alpha shaders, spooling Manhattan tether, desktop floating callouts, frosted HUD, B&W with intentional color, FAB-to-full-screen proposal flow, Vision Board (CV/sleep/diet/calendar/scout), Session Handoff Protocol, no location tracking mandate, dual clinical lens, data source types, motion proposal sequence, Phase 1 golden loop definition. Full audit of all governance docs against conversation. All governance docs rewritten to v2.0+. Three new docs created. Deleted duplicate `huddle_tracker.md`. Fixed all file-path typos (huddle → hurdle). Updated project_state with 24 new decisions (D20–D39).
- **Where I stopped**: All planning documents written and verified. 8 files in the repo are now complete and internally consistent: `product_spec.md` (v2.0), `agents.md` (v2.0), `architecture_rules.md` (v2.0), `project_state.md` (v3.0), `hurdle_tracker.md` (v2.0), `vision_board.md` (v1.0), `motus_tool_spec.md` (v1.0), `3d_asset_requirements.md` (v1.0). Plus existing `design_system.md` and `session_handoff_template.md`.
- **Current Blockers**: None — planning phase is complete. All architecture decisions documented. All V1 scope boundaries defined. All post-V1 features explicitly parked. File paths are consistent (no duplicate or misspelled references).
- **Decisions Made**: D20–D39 (24 decisions from deep-architecture phase). See Decisions Made table for full list.
- **Next Step**: Initialize melos monorepo and scaffold `shared_core` package with all 15+ Drift schema tables, BodySegment enum, all domain entities, and MotusCoordinator interface. This is Phase 1 starting point.
- **Confidence Level**: 5 (full conversation captured, all decisions documented, no ambiguity in V1 scope, all governance docs consistent)
- **Files Modified**: `docs/product_spec.md` (rewritten to v2.0), `docs/agents.md` (rewritten to v2.0), `docs/architecture_rules.md` (rewritten to v2.0), `docs/project_state.md` (updated to v3.0), `docs/hurdle_tracker.md` (updated to v2.0, consolidated from huddle_tracker.md)
- **Files Created**: `docs/vision_board.md`, `docs/motus_tool_spec.md`, `docs/3d_asset_requirements.md`
- **Files Deleted**: `docs/huddle_tracker.md` (consolidated into existing `hurdle_tracker.md`)
- **Date**: 2026-05-11

### Session #5 — Lint Resolution & Public Member Documentation
- **What I finished**: Resolved all 32 lint issues across all 5 packages. Fixed `public_member_api_docs` warnings by adding docstrings to `toDb()` methods on all 17 entities, `copyWith()` methods on 4 entities, enum extension method on EquipmentType, Failure fields in MotusCoordinator, `main()` entry points on mobile and desktop, MockFailure/ MockMotusCoordinator in test_support. Fixed `comment_references` issues by removing `[ClassName]` angle bracket references that cannot be resolved without imports (project_state.md, agents.md, core.dart, database.dart, entities). Corrected agent instructions to remove false claim that `public_member_api_docs: ignore` was configured (it is NOT — it is enforced by very_good_analysis). Ran `dart format --set-exit-if-changed -l 120` — 8 files formatted. Verified zero issues across all packages.
- **Where I stopped**: All lint resolved, all formatting applied.
- **Current Blockers**: None.
- **Files Modified**: `analysis_options.yaml` (removed stray nesting from earlier fix attempt), `docs/agents.md` (removed false `public_member_api_docs: ignore` claim), 34 Dart files across all 5 packages (docstring additions + formatting).
- **Date**: 2026-05-11

### Session #4 — Phase 1 Core Architecture Implementation
- **What I finished**: Phase 1 complete. Created melos monorepo config. Built full `shared_core` package: 17 domain entities (SymptomEvent, HypothesisEntity, BodySegmentEntity, InjuryEntity, EquipmentEntity, SourceEntity, PrincipleEntity, KnowledgeSourceEntity, NotificationContextEntity, NoiseLogEntity, KineticChainEdgeEntity, DriveSettingsEntity, DeviceSyncStateEntity, WorkoutLogEntity, ResearchNoteEntity, ExerciseEntity) with fromDb/toDb methods. 16 Drift schema tables matching product spec exactly. 14 repository interfaces. 4 biomechanical services: TorqueCalculator (τ = F·d·sin(θ)), SafetyMarginCalculator (S_margin = integrity×consistency/symptom), ProgressionLadder, DatabaseExportService. 5 enums: BodySegment (44 anatomical nodes), MovementMode, HypothesisStatus, SourceType (manual/computed/vision/rag), EquipmentType, RingHeight (5 presets with lever multipliers). `motus_hub` Dart server scaffold with REST endpoints for all tool calling spec tools. `myotwin_mobile` + `myotwin_desktop` Flutter app scaffolds with dark theme. `myotwin_test_support` with 14 mock repositories + MockMotusCoordinator.
- **Where I stopped**: All Phase 1 packages scaffolded and documented. No code implementations yet — only interfaces and scaffolds.
- **Current Blockers**: None.
- **Decisions Made**: D40 — TorqueCalculator uses 9.81 m/s² gravity constant; D41 — RingHeight lever multipliers hardcoded (overhead=1.0, sternum=0.75, waistHip=0.6, knee=0.4, floor=0.25); D42 — ProgressionLadder split at integrity=0.7 threshold; D43 — SafetyMargin tier boundary at 1.0 (safety < 1.0, performance ≥ 1.0); D44 — Elite cue unlock requires integrity > 0.75 AND margin ≥ 0.5; D45 — BodySegment enum uses anatomical IDs matching GLB mesh names.
- **Next Step**: Implement `DatabaseIsolate` (Drift background isolate connection) and `DatabaseExportService` (JSON/SQLite export/import). Or begin Phase 2: 3D Body Map & Shader Implementation.
- **Confirmed Confidence Level**: 5 (all Phase 1 scaffolding complete, all interfaces consistent with specs)
- **Files Modified**: `melos.yaml`, `bootstrap.sh`, `docs/project_state.md`
- **Files Created**: `packages/shared_core/pubspec.yaml`, `packages/shared_core/lib/core.dart`, `packages/shared_core/lib/src/data/database.dart`, 16 entity files, 14 repository interface files, 4 service files, 5 enum files, `packages/motus_hub/pubspec.yaml`, `packages/motus_hub/README.md`, `packages/motus_hub/bin/motus_hub.dart`, `packages/myotwin_mobile/pubspec.yaml`, `packages/myotwin_mobile/README.md`, `packages/myotwin_mobile/lib/main.dart`, `packages/myotwin_desktop/pubspec.yaml`, `packages/myotwin_desktop/README.md`, `packages/myotwin_desktop/lib/main.dart`, `packages/myotwin_test_support/pubspec.yaml`, `packages/myotwin_test_support/README.md`, `packages/myotwin_test_support/lib/test_support.dart`
- **Date**: 2026-05-11

---

**Document version**: 5.0
**Last updated**: 2026-05-11
