# Architecture & Performance Rules

## ⚖️ The 16ms Rule

Any operation expected to take >16ms MUST be moved to a background Isolate or `compute()`.
- No heavy JSON parsing on Main UI thread.
- No Drift queries on Main UI thread — use `DriftBackgroundIsolate` or `DatabaseConnection.daemon`.
- LLM prompt construction on isolates.
- Vector DB searches on isolates.

## 🧬 Clean Architecture

- **Data Layer**: Drift DAOs and API Clients (motus_hub).
- **Domain Layer**: Pure Dart Entities and Use Cases (shared_core). Zero Flutter dependencies.
- **Presentation Layer**: BLoCs and Widgets (mobile / desktop clients).

## 🚫 No Location Tracking

Under no circumstances should Motus access or infer the user's GPS/cellular location. The only discovery mechanism is manual equipment registration via conversation.

## 🧪 The Scientific Method Requirement

Every exercise recommendation must be wrapped in a `Hypothesis` object.
The agent must verify the `CertaintyScore` before moving a body segment from "Red" to "Yellow".
User overrides disable chains (`certainty_score = -1.0`).

## 🧪 Informed Autonomy

Never block user action. Always present choices with biomechanical rationale.
Adjust `SafetyMargin` on low recovery — suggest alternatives, do not forbid.
The user is the Principal Investigator; Motus is the lab partner.

## 🧪 Physics Over Hallucination

Motus MUST use tool endpoints for ALL biomechanical math.
- `calculate_torque_load(bodyWeight, angle, leverLength)` → returns `double torqueNm`
- `get_progression_step(exerciseId, currentIntegrity)` → returns exercise details
- Never estimate numbers in natural language.

## 📝 Commit Conventions

All commits MUST follow [Conventional Commits](https://www.conventionalcommits.org/).

```
<type>(<scope>): <description>
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`, `revert`

**Scope** (optional but preferred): `shared`, `mobile`, `desktop`, `hub`, `db`, `core`, `features/*`.

**Rules**:
- Subject ≤100 characters, imperative, no trailing period.
- Body describes *why*, not *what*. Blank for trivially obvious changes.
- Breaking changes referenced in footer as `BREAKING CHANGE: `.
- Cross-reference planning docs with `Refs: project_state.md Phase X`.

## 🚫 Anti-Patterns to Avoid

| Anti-Pattern | Correct Alternative |
|---|---|
| `setState()` for BLoC state changes | `BlocBuilder` / `StreamBuilder` |
| Direct Drift query in widget | Use Repository/UseCase layer |
| `print()` for debugging | Structured logging |
| Hardcoded strings in widgets | Use `AppLocalization` |
| Nested callbacks (callback hell) | `async`/`await` + named functions |
| Large files (>400 lines) | Split into smaller, focused libraries |
| God BLoCs (>10 events, >10 states) | Split into smaller BLoCs |
| Free-form commit messages | Conventional Commits format |
| Hard-coding equipment names | Use EquipmentRegistry enum/table |
| LLM-guessed biomechanics | Use tool-calculated values |
| Binary color transitions (0↔1) | Ghost alpha floor (min ~0.1) |
| Diagonal tether lines | Manhattan routing (90° elbows only) |
| Full-screen on desktop | Floating callout windows on desktop |

## 📐 3D Model & Shader Requirements

- Use layered GLB (Skeletal, Muscular, Cardiovascular).
- Data-driven heatmap mapping from Drift `SymptomLog` via vertex groups.
- X-Ray dissolve transition with `u_ghostAlpha` uniform.
- Mesh names must match `BodySegment` IDs from `shared_core`.
- Polygon count target: < 150,000 triangles.
- No high-res textures needed — procedural shaders handle all visualization.

## 📐 Desktop UI Tether Requirements

- Manhattan routing (straight lines, sharp elbows).
- Dynamic segment creation/collapse based on window distance.
- Grid-snapping (8px/16px grid).
- Occlusion state: dashed grey when node is hidden.
- Docking: snap to screen edges → sidebar panel.
- "Draw itself" animation: constant-velocity path extraction, linear easing.
- Collision avoidance: windows fan out, do not overlap.

## 📐 Mobile UI Requirements

- FAB state machine with slide-to-lock mic.
- Proposal window stems from FAB → blooms to full screen.
- Flow windows: full-screen, high contrast, massive typography.
- Haptic confirmation: double-pulse on spawn, long pulse on validation.

## 🧪 Context Window Management

The Motus Hub context orchestrator must:
1. Compress `InjuryVault` and `EquipmentRegistry` into a minified JSON object for the System Prompt.
2. Execute a Vector Search for relevant `ResearchNotes` before every LLM call.
3. Truncate and summarize chat history once it exceeds 25% of the model's total token limit.

## 🧪 Data Point Source Type

Every data point in the database must include a `SourceType` enum:
- `manual` — User-reported (symptom, equipment, nutrition, sleep, etc.)
- `computed` — Engine-calculated (torque, integrity score, certainty)
- `vision` — Computer Vision-derived (future feature)
- `rag` — Retrieved from research vector store

This enables Motus to track confidence levels per data point.

## 💾 Memory Leak Prevention

- Every `StreamSubscription` must be stored, cancelled, and set to null in BLoC `close()`.
- Every `AnimationController` must be disposed in `close()`.
- Every `Image`/`Picture`/`Canvas` must be disposed on widget dispose.
- No static globals except dependency injection container.

## 📊 Logging & Observability

- All domain use cases log: event, input params, result, duration (ms).
- Use `logging` package (not `print()`) for structured logs.
- Error stack traces captured for all `Failure.unknown`.

---

**Document version**: 2.0
**Last updated**: 2026-05-11
