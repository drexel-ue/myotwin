# MyoTwin — Governance

## Current State

| Item | Value |
|---|---|
| **Phase** | Phase 1 complete (core scaffolding). Phase 2: 3D Body Map & Shader Implementation |
| **Last Modified** | 2026-05-14 |
| **Next Task** | 3D Body Map & Shader Implementation (Phase 2) |
| **Confidence** | 5 — scaffolding complete, lint clean, all decisions documented |

### In Progress
<!-- Active work items. Empty means nothing is currently in-flight. -->

### Next Up
1. **Phase 2: 3D Body Map & Shaders** — Layered GLB rendering, vertex-group heatmap shader, X-ray dissolve (ghost alpha), Manhattan tether lines, desktop floating callouts with clip-mask reveal

---

## Decisions Log

Decisions are permanent architectural commitments. New decisions go here at the end of the list.

| # | Decision | Rationale | Date |
|---|---|---|---|
| D1 | BLoC for state management | Dense documentation, strong agent examples, strict event-driven pattern | 2026-05-09 |
| D2 | Drift (SQLite) over NoSQL | Relational data modeling, portability, SQL clarity | 2026-05-09 |
| D3 | Clean Architecture (3-layer) | Extensible, testable domain layer, swappable LLM backend | 2026-05-09 |
| D4 | Local-first: Motus via mediapipe + Ollama external | Privacy, offline capability, GPU-assisted research | 2026-05-09 |
| D5 | External Ollama on Unraid via OpenAI-compatible API | GPU compute offload, deep audit capability | 2026-05-09 |
| D6 | Monorepo via Melos | Isolated packages, clear boundaries, shared core | 2026-05-09 |
| D7 | Three-tier monorepo: shared_core + myotwin_mobile + motus_hub | Separation of presentation and orchestration; mobile never imports server | 2026-05-11 |
| D8 | Body map: layered GLB (Skeletal + Muscular + Cardiovascular) | Data-driven shader mapping, vertex-group coloring | 2026-05-11 |
| D9 | FAB: slide-to-lock mic + hot mic states | Hands-free during exercise, live transcription | 2026-05-09 |
| D10 | Natural language symptom input | Model tags symptoms, more flexible than fixed lists | 2026-05-09 |
| D11 | Agent uses scientific method | Hypothesis → Test → Observe → Refine loop | 2026-05-09 |
| D12 | User overrides disable kinetic chains | Certainty score set to -1.0 on dismiss | 2026-05-09 |
| D13 | 3 functional overlay modes | Mobility / Strength / Work Capacity — separate concerns | 2026-05-09 |
| D14 | Scientific explanation required | Agent cites sources, explains reasoning per suggestion | 2026-05-09 |
| D15 | Isolate-based performance | 16ms rule, no UI lockup | 2026-05-09 |
| D16 | mDNS + WebSocket for sync | Mac Mini as primary source of truth, no cloud needed | 2026-05-09 |
| D17 | Conventional Commits for all commits | Standardized history, agent-readable diffs, easy bisect | 2026-05-09 |
| D18 | B&W technical blueprint aesthetic with intentional color only for status | High-contrast, mechanical, clinical — not neon cyberpunk | 2026-05-11 |
| D19 | MyoTwin = app, Motus = inference model | Clear identity: app is interface, Motus is the scientific brain | 2026-05-11 |
| D20 | GLB over Rive for body map | Procedural shader-driven, extensible — adding a joint requires zero rendering code changes | 2026-05-11 |
| D21 | Neural Priming focus + Structural Loading via leverage physics | Rings/parallettes provide sufficient mechanical tension via torque manipulation | 2026-05-11 |
| D22 | Informed Autonomy over Automated Coaching | User is principal investigator; Motus presents choices with rationale, never blocks | 2026-05-11 |
| D23 | Tool calling for all biomechanical calculations | Physics > hallucination | 2026-05-11 |
| D24 | Context window tiering (Snapshot → RAG → Summarized Memory) | Keeps Gemma focused, avoids context bloat | 2026-05-11 |
| D25 | Spooling Manhattan tether for desktop callouts | Infinite-length, 90-degree elbows, dynamic segment creation/collapse | 2026-05-11 |
| D26 | Full-screen flow windows on mobile, floating callouts on desktop | Mobile = high visibility; Desktop = spatial multi-node analysis | 2026-05-11 |
| D27 | Equipment inventory via natural language | Friction-free registration | 2026-05-11 |
| D28 | Anatomical Landmark ring height calibration | Sternum/Hip/Knee/Floor reference vs tape measures | 2026-05-11 |
| D29 | Dual Clinical Lens: GenPop Safety + Elite Performance | Safety floor + elite ceiling | 2026-05-11 |
| D30 | Experience feedback analyzed through Clinical Lens | Personal experience validated against clinical studies | 2026-05-11 |
| D31 | Data point Source Type enum (manual/computed/vision/rag) | Enables Confidence Score tracking per data point | 2026-05-11 |
| D32 | Injury Vault: Acute/Dormant/Chronic with Integrity Score | Persistent biomechanical constraints | 2026-05-11 |
| D33 | Restoration Ladder: regression → progression path | Systematic rebuilding | 2026-05-11 |
| D34 | Motion proposal sequence: FAB → full-screen → flow | Clear narrative arc from idle to active session | 2026-05-11 |
| D35 | No location tracking ever | Explicit constraint | 2026-05-11 |
| D36 | X-ray dissolve: ghost alpha over Mechanical Explosion | V1 = shader-based ghosting (min alpha 0.1); Phase 2 = explosion | 2026-05-11 |
| D37 | V2 Sleep/Diet visualization | Post-V1 scope | 2026-05-11 |
| D38 | Vision board for CV (phase 3+), Calendar (phase 2+), Research Scout (phase 2+) | Park high-effort features, don't block V1 | 2026-05-11 |
| D39 | motus_hub replaces motus_local + motus_auditor | Single Dart server bridges phone ↔ Ollama with tool calling | 2026-05-11 |
| D40 | TorqueCalculator uses 9.81 m/s² gravity constant | Standard physics | 2026-05-11 |
| D41 | RingHeight lever multipliers hardcoded (overhead=1.0, sternum=0.75, waistHip=0.6, knee=0.4, floor=0.25) | Practical presets over real measurement | 2026-05-11 |
| D42 | ProgressionLadder split at integrity=0.7 threshold | Evidence-based restoration boundary | 2026-05-11 |
| D43 | SafetyMargin tier boundary at 1.0 | Safety < 1.0, Performance ≥ 1.0 | 2026-05-11 |
| D44 | Elite cue unlock requires integrity > 0.75 AND margin ≥ 0.5 | Dual gate for elite content | 2026-05-11 |
| D45 | BodySegment enum uses anatomical IDs matching GLB mesh names | Zero-mapping, direct shader binding | 2026-05-11 |
| D46 | Replaced MediaPipe LLM inference with llamadart (llama.cpp) | Clean Dart API, pure native assets (no CMake), better iOS/Apple Silicon integration, LoRA support, tool calling, cross-platform |
| D47 | On-device model: Gemma 4 E2B (~2.1B params, Q4_K_M) | Fits iPhone RAM (~250–500 MB via Neural Engine), ~11 tok/s, 8K context, sufficient for real-time interaction. E4B (~5 GB) reserved for desktop/macOS only |
| D48 | Multi-model architecture with LoRA adapters | One base model + domain-specific adapters (fitness_coach, medical_advisor, biomechanics_expert). Adapters loaded dynamically per call, not three separate models in memory |
| D49 | Intent-driven adapter routing | Lightweight classification (~5ms) selects appropriate LoRA adapter. Routes to fitness, medical, or biomechanics expertise per query |
| D50 | llamadart native backends: Metal/CoreML default on iOS | iOS uses Metal via llamadart consolidation (non-configurable). Server-side and Linux/Windows use Vulkan. All cross-platform, no manual native edits required |
| D51 | Model sourcing: HuggingFace GGUF files via `hf://` protocol | llamadart downloads/models cached via `ModelSource.parse('hf://owner/repo/model-Q4_K_M.gguf')`. Bundle small LoRA adapters with app, cache base model on first run |

---

## Architecture Rules

### 1. GenUI Construction

The app does not use static routes. It uses a Registry of `CatalogItems` dynamically instantiated by Motus.

- **Schema First**: Every `CatalogItem` defines a `dataSchema` using `json_schema_builder`.
- **Data Binding**: Widgets bind to `DataModel` paths. Never pass raw strings/ints to constructors.
- **Idempotent**: Same `surfaceId` → same UI on re-render.
- **Safe Destruction**: `dispose()` must tear down all `StreamSubscription`s, `AnimationController`s, and `DataModel` bindings.

### 2. Monorepo Rules

- Packages are independent — no cross-package imports except through `shared_core`.
- `myotwin_mobile` and `myotwin_desktop` never import each other.
- `motus_hub` never imports Flutter packages.

### 3. Performance

- **16ms rule**: Any operation >16ms → background Isolate or `compute()`.
- All Drift queries on background isolate via `DatabaseIsolate`.
- LLM prompt construction/parsing in `motus_hub`, not on UI thread.

### 4. Data Integrity

- Schema in `shared_core`. 16+ Drift tables matching product spec.
- Every data point includes `SourceType`: manual, computed, vision, rag.
- Result<T, Failure> pattern for all LLM/DB calls.
- JSONB columns for evolving, Motus-shaped data (Goal metadata, dynamic fields, feedback patterns).

### 5. Clean Architecture

```
Data Layer:    Drift DAOs + API Clients (motus_hub)
Domain Layer:  Pure Dart Entities + Use Cases (shared_core)
Presentation:  CatalogItem builders + Surface controllers (mobile/desktop)
```

### 6. Surface Anti-Patterns

| Anti-Pattern | Correct Alternative |
|---|---|
| `Navigator.push(new Page())` | `SurfaceController.createSurface(id)` |
| Passing raw `String`/`int` to widgets | Binding to `DataModel` paths via `context.data['path']` |
| Hardcoding widgets in `ListView` | AI's `A2uiMessage` defining layout |
| Manually parsing JSON in UI layer | `A2uiParserTransformer` in Transport layer |

### 7. 3D & Shader Requirements

- Heatmap: vertex-group-driven emissive color interpolation.
- Manhattan routing: all tether lines use 90° elbows.
- X-ray dissolve: `u_ghostAlpha` uniforms.

### 8. Physics Over Hallucination

Motus MUST use tool calling for all biomechanical calculations. No estimating torque, leverage, ROM, or progression steps in natural language.

- `calculate_torque_load` for force calculations.
- `get_progression_step` for ladder navigation.
- `calculate_safety_margin` for injury-aware difficulty scaling.

### 9. Motus Inference with llamadart

All local LLM inference uses **llamadart** (Flutter plugin for llama.cpp):

- **On-device model**: Gemma 4 E2B Q4_K_M via `hf://ggml-org/gemma-4-E2B-it-GGUF:gemma-4-E2B-it-Q4_K_M.gguf`
- **iOS runtime**: Metal (CoreML) via llamadart — automatic native assets, no manual CMake
- **Minimum iOS version**: 16.4 (llamadart native compilation requirement)
- **LoRA adapters**: Loaded dynamically per invocation — fitness, medical, biomechanics advisors
- **Tool calling**: Built-in via llamadart's `ChatSession.create(tools: [...])`
- **Multimodal**: Not used on iOS (E2B drops vision/audio). Reserved for desktop/E4B or server.
- **Lifecycle**: Explicit `await engine.dispose()` — always release native resources
- **KV-cache persistence**: `stateSaveFile`/`stateLoadFile` for fast context resume
- **Embeddings**: `engine.embed()` for knowledge graph vector storage

### 10. Model Orchestration (Multi-Model)

Motus uses intent classification to route queries to specialized adapters:

```
User input → Intent Classifier → Load appropriate LoRA adapter → Generate response → Reset adapter
```

- **Classification prompt**: ~50 tokens → ~5ms on E2B
- **Active adapter per call**: One adapter at a time (~150 MB), swapped between calls
- **Total memory**: Base model (~250–500 MB) + one adapter (~150 MB) = ~400–650 MB
- **Server Motus**: Multiple full models (7B–70B params) on GPU for deep research, knowledge sync
- **Knowledge graph sync**: Motus reports patterns → Server researches → Client updates knowledge graph

---

## Agent Instructions

### Role

You are a **Senior Flutter & GenUI Architect** building MyoTwin — a privacy-first, biomechanical research and coaching application. You are responsible for both development and orchestration of GenUI surfaces.

### Mandatory Pre-Start Protocol

Before writing any code, read:
1. `docs/PRODUCT.md` — what to build
2. `docs/GOVERNANCE.md` — guardrails and rules
3. `docs/VISION.md` — feature backlog
4. `docs/DESIGN_SYSTEM.md` — visual specs
5. `docs/MOTUS_TOOL_SPEC.md` — tool calling spec
6. `docs/3D_ASSET_REQUIREMENTS.md` — GLB model requirements
7. `docs/SESSION_HANDOFF_TEMPLATE.md` — handoff format
8. `docs/SYSTEM_HEALTH.md` — arch drift, todos, known issues

### Documentation Requirements

- Every class: docstring explaining responsibility.
- Every BLoC event and state: documented.
- Every public method: docblock with Purpose, Parameters, Returns, Throws.

### Scientific Method Directive

**Informed Autonomy, not Automated Coaching.** Never force the user to stop working. Always present choices with rationale.

When Motus generates a recommendation:
1. Provide biomechanical rationale.
2. Offer regression + progression options.
3. Explain the clinical lens (GenPop Safety / Elite Performance).
4. Ask for validation feedback.

### Knowledge Retrieval Protocol

1. **Internal codebase** (`ccc`) — primary search tool.
2. **External frameworks** (`context7`) — Flutter, Dart, library docs.
3. **Fallback** (`grep`/`read`) — only if tools fail.

### Index Freshness

- **Post-change trigger**: After any edit/write/git operation, trigger `ccc` re-indexing.
- **Verification**: Before marking complete, verify recent changes are searchable via `ccc`.

### Session Discipline

- Before starting work: read relevant docs above.
- At end of session: update `GOVERNANCE.md` (Current State, Next Up items).
- Track all decisions in the Decisions Log above.

---

## Commit Conventions

**Mandatory**: All commits follow [Conventional Commits](https://www.conventionalcommits.org/).

```
type(scope): description
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`, `revert`

**Preferred scopes**: `shared`, `mobile`, `desktop`, `hub`, `db`, `core`, `features/*`, `gen-ui`

**Subject**: imperative mood, ≤100 characters, no period.  
**Body**: describe the *why*, not the *what*. Blank for trivially obvious changes.  
**Footer**: `BREAKING CHANGE: ` or `Refs: GOVERNANCE.md`

### Good Examples

```
feat(core): define InjuryVault entity and Drift table

Injury tracking needs persistent storage for integrity scores
and functional offsets across sessions.

Refs: GOVERNANCE.md
```

```
feat(gen-ui): implement Context Surface with DataModel binding

Surface assembles when user taps an anatomical node, displaying
symptom history and kinetic chain data through the catalog system.

Refs: GOVERNANCE.md
```

### Code Quality — Lint & Format

Before committing any Dart code:
1. `dart analyze <target>` — fix all errors, warnings, infos
2. `dart format .` — auto-format
3. Verify zero issues remain

All packages use `very_good_analysis` with project-specific overrides in `analysis_options.yaml`. Page width: 120 characters. Trailing commas: always.

---

## Project State History (Condensed)

Sessions are condensed to key decisions and deliverables. Full context is in the Decisions Log above.

### Session #0 — Initial Planning (2026-05-09)
Created docs/ product spec, agent instructions, architecture rules, project state, hurdle tracker. Vision complete, no code written.

### Session #1 — Design System (2026-05-09)
Created DESIGN_SYSTEM.md — full B&W cyberpunk HUD token set (palette, typography, motion, widget specs). Split LLM layer into motus_local + motus_auditor (later consolidated to motus_hub).

### Session #2 — Deep Architecture Refinement (2026-05-11)
Comprehensive deep-dive: branding, monorepo, tool calling, context window management, equipment/leverage, injury vault, restoration ladder, neural priming vs structural loading, GLB/Rive decision, collaborative science, shaders, desktop callouts, vision board. 24 new decisions (D20–D39). 3 new docs created: vision_board.md, MOTUS_TOOL_SPEC.md, 3D_ASSET_REQUIREMENTS.md.

### Session #3 — Phase 1: Core Architecture (2026-05-11)
Melos monorepo initialized. shared_core: 17 entities, 16 Drift tables, 14 repo interfaces, 4 biomechanical services, 5 enums. motus_hub scaffold with REST endpoints. mobile + desktop app shells. test_support mock repos. 5 new decisions (D40–D45).

### Session #4 — Repo Stabilization (2026-05-12)
DriftBodySegmentRepository and DriftInjuryRepository with UnimplementedError placeholders. DatabaseIsolate interface defined. Project builds and analyzes without errors.

### Session #5 — Lint Resolution & Documentation (2026-05-11)
Resolved all 32 lint issues across 5 packages. Added docstrings to toDb(), copyWith(), main() entry points. Fixed comment_references. Verified 0 issues.

### Session #6 — Knowledge Retrieval Protocol (2026-05-12)
Added ccc/context7 fallback hierarchy to agent instructions. Index freshness protocol. Agents.md updated to 2.1.

### Session #7 — Documentation Consolidation (2026-05-14)
Redesigned doc structure from 10 scattered files to 6 focused documents: README.md, PRODUCT.md, DESIGN_SYSTEM.md, MOTUS_TOOL_SPEC.md, VISION.md, GOVERNANCE.md. New proactive/adaptive UX model with IntentRecord/Goal architecture. Session ledger condensed, current state table at top of GOVERNANCE.md.

---

## Known Hurdles

| Hurdle | Status | Notes |
|---|---|---|
| `DriftBodySegmentRepository` and `DriftInjuryRepository` logic not implemented | Open | Interfaces defined with `UnimplementedError` placeholders to unblock build |
| `DatabaseIsolate` implementation pending | Open | Interface defined, backend not coded |
| `DatabaseExportService` implementation pending | Open | Interface defined, backend not coded |
| GenUI package is highly experimental (API will change) | Known | Track Flutter/genui releases, prepare for migration friction |
| Ollama server availability required for research pipeline | Known | Local-first works without it; research features need network |

---

**Document version**: 1.0
**Last updated**: 2026-05-14
