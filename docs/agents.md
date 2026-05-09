# MyoTwin — Agent Instructions (`agents.md`)

## Role

You are a **Senior Flutter & Biomechanical Systems Architect** building a biomechanical research and coaching application. You must adhere to every constraint below.

## 1. Documentation-First Coding

- **Every class** must have a docstring explaining its responsibility.
- **Every BLoC event and state** must be documented.
- Every public method must have a docblock with `Purpose`, `Parameters`, `Returns`, and `Throws` (if applicable).
- Maintain `system_health.md` within the codebase to track architectural drift, TODOs, and known issues.

## 2. Architecture Compliance

- All features follow **Clean Architecture**: Data → Domain → Presentation.
- Domain layer must be a pure Dart library (zero Flutter dependencies).
- Each feature in `packages/myotwin_features/` must contain:
  - `data/` — repository implementation, DAOs, API clients.
  - `domain/` — repository interface, use cases, domain entities.
  - `presentation/` — BLoC(s), widgets.

## 3. Data Integrity (Drift/SQLite)

- Schema lives in `packages/myotwin_db/`. Must include at minimum these tables:

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
  | `KineticChainEdge` | Weighted edges between body segment nodes |
  | `BodySegment` | Nodes in the kinetic graph |
  | `DriveSettings` | Global and per-node intensity/drive values |
  | `DeviceSyncState` | Last-sync timestamps for multi-device |

- Implement `DatabaseExportService` for JSON/SQLite file export/import.
- All Drift queries run on the **background isolate**.

## 4. Model Orchestration

The app (**MyoTwin**) contains a local AI model named **Motus** — they are not the same thing. MyoTwin is the application; Motus is the inference engine that powers Motus is the model that lives inside the app, not the app itself.

- **`ModelCoordinator`** decides between:
  - Motus (local inference via mediapipe) for fast chat and real-time interaction.
  - External Ollama server for background research and deep audit.
- All LLM calls wrap in `Result<T, Failure>` — no UI hangs.
- Implement `ExternalModelAvailability` check with automatic fallback.

## 5. Prompt Engineering

### 5.1 Prompt — Motus (Local Model)

Motus is the local AI model that lives inside the MyoTwin app. It handles all real-time chat and direct user interaction.

```
You are Motus, the AI engine behind MyoTwin. You are a biomechanical coaching
agent. You use the scientific method to track the user's physical state and
recommend exercises. When the user reports symptoms, tag them into categories:
Stiffness, Sharp Pain, Dull Ache, Weakness. Track body segments involved.
Update the kinetic chain graph mentally. Cite principles and sources when
proposing movement changes. Keep responses concise. Use audio-friendly language
since the user may be exercising. Always speak as Motus, the AI that lives
inside the MyoTwin app. You are not MyoTwin — you are Motus.
```

### 5.2 Prompt — MyoTwin (App Identity)

The application itself is **MyoTwin** — the wrapper, UI, and orchestrator. Motus is **Motus**.

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
```

## 6. UI/UX — The "Magic"

### 6.1 Fab Interaction Flow

```
            ┌──────────────┐
            │   FAB State   │
            └──────┬───────┘
                   │
         ┌─────────┼──────────┐
    Single Tap  Long Press  Long Press
                 │          + Slide
         ┌───────┴───┐      │
         ▼           ▼   ┌──┴──────┐
      Chat Sheet    STT    Lock Mic
                   Session   "Hot"
```

- FAB uses `AnimatedContainer` + `GestureDetector` for visual morphing.
- While "hot", FAB pulses and changes color (e.g., green → cyan).
- Mic activates in both press modes. Tap FAB again to stop in locked mode.

### 6.2 Chat Bottom Sheet

- Opens as a full-width bottom sheet.
- Messages include:
  - Text (user + agent)
  - Exercise recommendations (with "Do Now" / "Remind Me" CTA)
  - Theory explanations (when agent proposes a link)
- Context injection: when deep-link opened, first message explains why agent reached out.

### 6.3 3D Body Map

- GLB model with named vertex groups per muscle.
- Heatmap colors driven by symptom log frequency/intensity.
- Kinetic chains drawn as Bezier curves (thickness = correlation strength, opacity = certainty).
- Tapping a segment → dossier view.
- Tapping a chain → chat with agent theory.

### 6.4 Dossier View

- Shows:
  - Symptom history for that segment.
  - Active hypotheses with uncertainty (e.g., "Likely", "Uncertain", "Unlikely").
  - Research notes with cited sources.
  - Agent's "theory" behind current recommendations.
  - "Dismiss Chain" / "Break Link" buttons for user overrides.

## 7. Performance Guardrails

- **16ms Rule**: Any operation >16ms goes to an isolate or is broken into async chunks.
- **Debouncing**: Heatmap color updates debounced to 150ms.
- **Isolate Manager**: All JSON parsing, heavy SQL queries, LLM prompt construction on isolates.
- **Reactive UI**: Body map listens to BLoC stream, not `setState()`.
- **Graceful Degradation**: If external GPU unreachable, silently switch to local-only with "Research Pending" status.
- **Memory Management**: All `StreamSubscription` and `AnimationController` disposed in BLoC `close()`.
- **Context Window Janitor**: Old chat summarized into research notes, then purged.
- **Frame Budget**: 60 FPS target. No synchronous work inside render callbacks.

## 8. Testing Requirements

- Every BLoC must have a unit test.
- Every use case must have a unit test with fakes.
- Widget tests for: FAB state machine, ChatBottomSheet, BodyMap interaction, Dossier view.
- Integration test: full session flow (FAB press → voice input → exercise recommendation).
- All tests use `package:test` and `package:checks`.

## 9. Commit Convention (Conventional Commits)

- **All commits MUST follow Conventional Commits** — never use free-form commit messages.
- Format: `<type>(<scope>): <description>`
- Type must be one of:

  | Type | When to use |
  |---|-|
  | `feat` | New feature or functionality |
  | `fix` | Bug fix |
  | `docs` | Documentation-only changes |
  | `style` | Formatting, semicolons, no code change |
  | `refactor` | Code change that neither fixes a bug nor adds a feature |
  | `perf` | Performance improvement |
  | `test` | Adding or updating tests |
  | `chore` | Build tooling, dependency updates, CI |
  | `ci` | CI configuration changes |
  | `build` | Changes to build system or dependencies (if not chore) |
  | `revert` | Reverting a previous commit |

- **Scope** (optional but preferred) indicates the package or layer: `db`, `features/hypothesis_engine`, `llm`, `app`, `core`, etc.
- **Subject line**: imperative mood, ≤100 characters, no period.
- **Body**: describe the *why*, not the *what*. Leave blank for trivially obvious changes.
- **Footer**: Use for breaking changes (prefix `BREAKING CHANGE: `) or issue references (e.g., `Refs: project_state.md Phase 1`).

### Examples

```
feat(db): add KineticChainEdge table to Drift schema

Linkage between body segments needs a weighted edge representation
to support uncertainty scoring.

Refs: project_state.md Phase 1
```

```
feat(app): wire FAB state machine to chat bottom sheet

Connects gesture states to BlocBuilder so FAB visual feedback
aligns with chat lifecycle.

Refs: project_state.md Phase 3
```

```
test(hypothesis_engine): add certainty_score update logic tests

Covers active → proven and active → refuted transitions.

Refs: project_state.md Phase 4
```

### Pre-commit Enforcements

If tooling is available, configure `commitlint` with rules:

```json
{
  "extends": ["@commitlint/config-conventional"],
  "rules": {
    "header-max-length": [2, "always", 100],
    "subject-case": [2, "always", ["lower-case-start"]]
  }
}
```

If not, manually validate commits against this spec before pushing.

## 10. Session Discipline

- **Before starting work**: Read `product_spec.md`, `architecture_rules.md`, and `project_state.md`.
- **Before committing updates to markdown files**: Read `project_state.md`, `hurdle_tracker.md`.
- **At end of session**: Update `project_state.md` and `hurdle_tracker.md`. Write a `Session Handoff` entry.
- **Track all architectural decisions**: Log them in `project_state.md` under "Decisions Made".

---

**Document version**: 1.1
**Last updated**: 2026-05-09
