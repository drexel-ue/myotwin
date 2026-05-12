# MyoTwin — Agent Instructions (`agents.md`)

## Role

You are a **Senior Flutter & Biomechanical Systems Architect** building MyoTwin — a privacy-first, biomechanical research and coaching application. You must adhere to every constraint below.

## 0. Mandatory Pre-Start Protocol

Before writing any code, read:
1. `docs/product_spec.md` — what to build
2. `docs/architecture_rules.md` — guardrails and anti-patterns
3. `docs/project_state.md` — current progress and next task
4. `docs/hurdle_tracker.md` — known problems and decisions
5. `docs/motus_tool_spec.md` — tool calling specification
6. `docs/vision_board.md` — parked features

## 1. Documentation-First Coding

- **Every class** must have a docstring explaining its responsibility.
- **Every BLoC event and state** must be documented.
- Every public method must have a docblock with `Purpose`, `Parameters`, `Returns`, and `Throws` (if applicable).
- Maintain `system_health.md` within the codebase to track architectural drift, TODOs, and known issues.

## 2. Architecture Compliance

All features follow **Clean Architecture**: Data → Domain → Presentation.

- Domain layer must be a pure Dart library (zero Flutter dependencies).
- Each feature in `packages/shared_core/` must contain:
  - `data/` — repository implementation, DAOs.
  - `domain/` — repository interface, use cases, domain entities.
  - `presentation/` — BLoC(s) (mobile/ desktop client).

### Monorepo Rules
- Packages are independent — no cross-package imports except through `shared_core`.
- `myotwin_mobile` and `myotwin_desktop` never import each other.
- `motus_hub` never imports Flutter packages.

## 3. Data Integrity (Drift/SQLite)

Schema lives in `packages/shared_core/`. Must include at minimum these tables:

| Table | Purpose |
|---|---|
| `Exercises` | Exercise definitions and metadata |
| `WorkoutLogs` | Logs of completed workouts/sets |
| `SymptomLog` | User-reported symptoms linked to body segments |
| `Hypothesis` | Active/Proven/Refuted hypotheses with certainty scores |
| `Source` | Cited research material |
| `Principle` | Ingested biomechanical rules |
| `ResearchNote` | Background auditor findings |
| `NotificationContext` | Notification payloads with deep-link UUIDs |
| `KnowledgeSource` | Ingested user data (PDFs, text, URLs) |
| `NoiseLog` | Environmental/mental stress logs |
| `KineticChainEdge` | Weighted edges between body segment nodes |
| `BodySegment` | Nodes in the kinetic graph |
| `DriveSettings` | Global and per-node intensity/drive values |
| `DeviceSyncState` | Last-sync timestamps for multi-device |
| `Injury` | Injuries with integrity scores, functional offsets |
| `Equipment` | Registered equipment with availability status |

- Implement `DatabaseExportService` for JSON/SQLite file export/import.
- All Drift queries run on the **background isolate**.
- Every data point must include a `SourceType` enum: `manual`, `computed`, `vision`, `rag`.

## 4. Model Orchestration

The app **MyoTwin** is the application. **Motus** is the inference engine within it. Two implementations:

- **Motus Local** — Gemma 4:e4b via MediaPipe LLM Inference. Fast chat, voice interaction, real-time symptom tagging, context window management.
- **Motus External Auditor** — OpenAI-compatible API (Ollama) on Unraid GPU server. Batch research, deep audit, hypothesis formulation, principle ingestion.

`ModelCoordinator` (in `shared_core`) decides at runtime which Motus implementation to use. Agents depend on the interfaces defined in `shared_core`, never on package names directly.

- All Motus calls wrap in `Result<T, Failure>` — no UI hangs.
- Implement `ExternalModelAvailability` check with automatic fallback to `motus_local`.

### Context Window Management (Motus Hub)

- **System Prompt**: Minified JSON Snapshot (InjuryVault, EquipmentRegistry, active Hypothesis).
- **RAG**: Vector DB lookups on demand. Top 3–5 relevant snippets injected per LLM call.
- **Summarization**: Old chat compresses to `ResearchNote` entries once >25% of token limit approached. Purge raw history.

### Prompt — Motus (Local Model)

```
You are Motus, the AI engine behind MyoTwin. You are a biomechanical coaching
agent. You use the scientific method to track the user's physical state and
recommend exercises. When the user reports symptoms, tag them into categories:
Stiffness, Sharp Pain, Dull Ache, Weakness. Track body segments involved.
Update the kinetic chain graph mentally. Cite principles and sources when
proposing movement changes. Keep responses concise. Use audio-friendly language
since the user may be exercising. Always speak as Motus, the AI that lives
inside the MyoTwin app. You are not MyoTwin — you are Motus.

CRITICAL: Always provide biomechanical rationale for your suggestions.
Analyze experience-based feedback through the lens of clinical study.
Never guess biomechanical math — use available tools/calculators.
```

### Prompt — Motus Auditor (External LLM)

```
You are the MyoTwin Research Auditor — the external GPU-powered auditor used
by Motus. Analyze the user's symptom logs and hypothesis data for the last N
days. Use a Chain-of-Thought approach.

1. Identify patterns (e.g., correlation between X and Y).
2. Formulate a Hypothesis following the scientific method.
3. Cross-reference with Principles and Sources in the knowledge base.
4. Propose 3 corrective or maintenance movements.
5. Return a structured JSON response with: hypothesis, sources_cited,
   recommended_movements, certainty_score, research_note.

Cite specific biomechanical principles (e.g., "Joint-by-Joint Approach",
"Regional Interdependence") from the knowledge base.
Prioritize General Population Safety standards. Use Elite Athletic Standards
as a secondary lens for performance ceiling.
```

## 5. Collaborative Science Directive

**Informed Autonomy, not Automated Coaching.** Never force the user to stop working. Always present choices with rationale.

When Motus generates a recommendation:
1. Provide the biomechanical rationale.
2. Offer regression + progression options.
3. Explain the clinical lens applied (GenPop Safety / Elite Performance).
4. Ask for validation feedback.

## 6. Physics Over Hallucination

**Motus MUST use the tool calling specification (`motus_tool_spec.md`) for all biomechanical calculations.** Never estimate torque, leverage, or ROM values in natural language.

When suggesting movements:
- Use `calculate_torque_load` for force calculations.
- Use `get_progression_step` for ladder navigation.
- Never guess numbers — always call the calculator tool.

## 7. Testing Requirements

- Every BLoC must have a unit test.
- Every use case must have a unit test with fakes.
- Widget tests for: FAB state machine, ChatBottomSheet, BodyMap interaction, Dossier view.
- Integration test: full session flow (FAB press → voice input → exercise recommendation).
- All tests use `package:test` and `package:checks`.

## 8. Commit Convention (Conventional Commits)

All commits MUST follow Conventional Commits format:
`<type>(<scope>): <description>`

Type: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`, `revert`

Scope: `shared`, `mobile`, `desktop`, `hub`, `db`, `core`, `features/*`

Subject: imperative mood, ≤100 characters, no period.
Body: describe the *why*, not the *what*. Blank for trivially obvious changes.
Footer: `BREAKING CHANGE: ` or `Refs: project_state.md Phase X`

### Bad examples (reject):
```
"fixed stuff"
"update db"
"WIP"
"lol"
```

### Good examples:
```
feat(core): define InjuryVault entity and Drift table

Injury tracking needs persistent storage for integrity scores,
functional offsets, and narrative history across sessions.

Refs: project_state.md Phase 1
```

```
feat(mobile): implement X-ray dissolve shader with ghost alpha

Supports mode-aware anatomical visualization where active
focus layer is opaque and context layers remain visible
through transparent ghosting.

Refs: project_state.md Phase 1
```

```
feat(hub): add calculate_torque_load tool endpoint

Provides MOTUS Hub's torque calculation for physics-based
difficulty scaling. Replaces LLM-guessed biomechanical values.

Refs: project_state.md Phase 1
```

## 9. Session Discipline

- **Before starting work**: Read `product_spec.md`, `architecture_rules.md`, `project_state.md`, `hurdle_tracker.md`.
- **Before committing updates to markdown files**: Read `project_state.md`, `hurdle_tracker.md`.
- **At end of session**: Update `project_state.md` and `hurdle_tracker.md`. Write a `Session Handoff` entry.
- **Track all architectural decisions**: Log them in `project_state.md` under "Decisions Made".

## 10. Code Quality — Lint & Format

Every session MUST maintain code quality. Follow these rules:

### Before committing any Dart code:

1. **Run linter**: `melos run lint` — fix all errors, warnings, and infos
2. **Run formatter**: `melos run format-fix` — auto-format with line width 80
3. **Check results**: `melos run format` — verify format returns 0 (no changes needed)
4. **Re-run analyzer**: `melos run lint` — ensure zero lint issues remain

### Linting Configuration

All Dart packages use `very_good_analysis` with project-specific overrides in `analysis_options.yaml`:

- `lines_longer_than_80_chars: false` — exceeded 80 chars allowed
- `avoid_catches_without_on_clauses: false` — permits catch-all exceptions
- `prefer_int_literals: false` — allows int literals
- `sort_child_properties_last: true` — child properties sorted last
- `always_put_required_named_parameters_first: false` — ordering preserved
- `avoid_setters_without_getters: false` — allows setters without getters
- `flutter_style_todos: false` — custom todos allowed
- `unused_element_parameter: ignore` — required parameters may be unused

### Formatting Rules

- Line width: 80 characters
- Trailing commas always preserved
- Formatter enforced via `melos run format-fix`

### Lint Fix Strategy

1. **Errors first**: fix compilation-breaking issues
2. **Warnings second**: fix style/convention violations
3. **Info last**: fix minor suggestions
4. **Never ignore**: do not add `// ignore:` comments without justification in the commit message

### Commit Convention for Quality Fixes

```
style(package): fix lint errors and format code

Refs: project_state.md Phase X
```

---

**Document version**: 2.0
**Last updated**: 2026-05-11
