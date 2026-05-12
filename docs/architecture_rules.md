# Architecture & GenUI Rules

## 🧬 GenUI Construction Rules

The application does not use static routes for features. Instead, it uses a **Registry of CatalogItems** that are dynamically instantiated.

### 1. The Catalog Protocol (Widget Assembly)
Every `CatalogItem` in the `myotwin_mobile` and `myotwin_desktop` packages must follow these rules:
- **Schema First**: Every item **must** define a `dataSchema` using `json_schema_builder`.
- **Data Binding**: Widgets must use `context.dataContext.subscribe...` methods. **NEVER** pass raw strings or ints directly; always bind to the `DataModel` path.
- **Identity**: Each `CatalogItem` must be idempotent. Re-rendering with the same `surfaceId` must yield the same UI.
 
### 2. Surface Lifecycle
- **Spawn**: Triggered by `A2uiMessage` (`createSurface`).
- **Hydration**: The `SurfaceController` populates the `DataModel` with the payload provided by the AI.
- **Destruction**: When a user dismisses a window or a session ends, all `StreamSubscription`s, `AnimationController`s, and `DataModel` bindings within that surface **must** be disposed in the `dispose()`/`close()` method.

## ⚖️ The 16ms Rule (Performance)
Any operation expected to take >16ms MUST be moved to a background Isolate or `compute()`.
- No heavy JSON parsing or `json_schema_builder` logic on the Main UI thread.
- No Drift queries on Main UI thread.
- LLM prompt construction and parsing must occur in `motus_hub` or a background isolate.

## 🧬 Clean Architecture
- **Data Layer**: Drift DAOs and API Clients (motus_hub).
- **Domain Layer**: Pure Dart Entities and Use Cases (`shared_core`). Zero Flutter dependencies.
- **Presentation Layer**: `CatalogItem` builders and `Surface` controllers (mobile/desktop clients).

## 🧪 The Scientific Method & Probabilistic UI
- **Hypothesis-Driven**: Every interaction that alters a body segment's state must be wrapped in a `Hypothesis` object.
- **Probabilistic Updates**: UI elements (like the Heatmap) must reflect the uncertainty in the `certainty_score`.
- **Informed Autonomy**: Never block user action. Present choices with biomechanical rationale.

## 🚫 Anti-Patterns to Avoid (GenUI Edition)
| Anti-Pattern | Correct Alternative |
|---|---|
| `Navigator.push(new Page())` | `SurfaceController.createSurface(id)` |
| Passing `String` parameters to widget constructors | Binding to `DataModel` paths via `context.data['path']` |
| Hardcoding widget placement in a `ListView` | Using the AI's `A2uiMessage` to define layout |
| Manually parsing JSON in the UI layer | Using `A2uiParserTransformer` in the `Transport` layer |

## 📐 3D & Shader Requirements
- **Anatomical Heatmap**: Vertex-group-driven emissive color interpolation.
- **Manhattan Routing**: All tether lines must use 90° elbow routing.
- **X-Ray Dissolve**: Transition must use `u_ghostAlpha` uniforms.

## 📝 Commit Conventions
All commits MUST follow [Conventional Commits](https://www.conventionalcommits.org/).
`type(scope): description`
**Scope**: `shared`, `mobile`, `app-ui`, `catalog`, `db`, `hub`, `core`.

---
**Document version**: 2.0 (GenUI)
**Last updated**: 2026-05-12
