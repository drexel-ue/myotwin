# Architecture & Performance Rules

## ⚖️ Rules

### 16ms Rule
Any operation expected to take >16ms MUST be moved to a compute() call or a dedicated Isolate.
- No heavy JSON parsing on Main UI thread.
- No Drift queries on Main UI thread — use `compute()` or `DriftBackgroundIsolate`.
- LLM prompt construction on isolates.

### Reactive UI
The 3D Body Map MUST listen to a `Stream` from the BLoC. Use `StreamBuilder` or `BlocBuilder`.
**Never** use `setState()` for global heatmap updates.

### Result Pattern
All LLM calls, network requests, and database imports/exports MUST return `Result<T, Failure>`.
- Use from `fpdart` package.
- No try/catch without wrapping — errors must be modeled as Failure types.
- UI displays "Research Pending" when external model unreachable.

### Thread Safety
- Drift DAOs must run on background isolate via `DatabaseConnection.daemon`.
- No shared mutable state between isolates — use message passing only.

### Debounce Policy
- Heatmap color updates: debounced to 150ms.
- Voice transcription finalization: debounced to 200ms.
- Hypothesis score updates: debounced to 300ms.

### Context Window Management
- Chat history kept to last 20 turns in active prompt.
- Older history summarized into `ResearchNote` entries periodically (every ~30 turns).
- Summarization uses the external auditor model to reduce token usage.

### Clean Architecture Strictness
- Domain layer imports zero packages from Flutter ecosystem.
- Feature packages are independent — no cross-feature imports except through domain interfaces in `myotwin_core`.
- Data layer depends on domain interfaces (dependency inversion).

### Memory Leak Prevention
- Every `StreamSubscription` must be stored, cancelled, and set to null in BLoC `close()`.
- Every `AnimationController` must be disposed in `close()`.
- Every `Image`/`Picture`/`Canvas` must be disposed on widget dispose.
- No static globals except dependency injection container.

### Logging & Observability
- All domain use cases log: event, input params, result, duration (ms).
- Use `logging` package (not `print()`) for structured logs.
- Error stack traces captured for all `Failure.unknown`.

## 📝 Commit Conventions

All commits MUST follow [Conventional Commits](https://www.conventionalcommits.org/).

```
<type>(<scope>): <description>
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`, `revert`

**Scope** (optional but preferred): `db`, `core`, `llm`, `app`, or full feature path like `features/hypothesis_engine`.

**Rules**:
- Subject ≤100 characters, imperative, no trailing period.
- Body describes *why*, not *what*. Blank for trivially obvious changes.
- Breaking changes referenced in footer as `BREAKING CHANGE: `.
- Cross-reference planning docs with `Refs: project_state.md Phase 1`.

### Bad examples (reject)

```
"fixed stuff"
"update db"
"WIP"
"lol"
```

### Good examples (accept)

```
feat(db): add hypothesis engine use cases
refactor(llm): extract prompt builder from coordinator
test(hypothesis_engine): add certainty score unit tests
chore: bump drift to 11.0.0
```

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

---

**Document version**: 1.1
**Last updated**: 2026-05-09
