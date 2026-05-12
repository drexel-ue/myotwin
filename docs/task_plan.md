# MyoTwin: GenUI Pivot Plan

This plan outlines the architectural transformation of MyoTwin from a static, page-based Flutter application to a dynamic, generative UI (GenUI) architecture powered by the `genui` package.

## Phase 1: The Blueprint (Architecture & Governance)
*Goal: Redefify the fundamental rules of the application.*

- [x] **Initialize GenUI Document Suite** (Status: `completed`)
    - [x] Redraft `docs/product_spec.md`: Transition from "Screens/Routes" to "Surfaces/Catalogs".
    - [x] Redraft `docs/architecture_rules.md`: Define standards for `CatalogItem` creation and `DataModel` reactivity.
    - [x] Redraft `docs/agents.md`: Update instructions for the Agent to act as a UI orchestrator.
    - [x] Redraft `int_hurdle_tracker.md`: Log the transition challenges.

## Phase 2: The Primitive Registry (The Catalog)
*Goal: Build the "Vocabulary" of the app—the set of widgets the AI is allowed to use.*

- [x] **Define Core Catalog Vocabulary** (Status: `completed`)
    - [x] Design `CatalogItem` schemas for "Data Display" (e.g., `MetricCard`, `op_progress_bar`).
    - [x] Design `CatalogItem` schemas for "User Interaction" (e.g., `ActionBtn`, `InputForm`).
    - [x] Implement `CatalogItem` builders in `packages/shared_ui`.
    - [x] Integrated `json_schema_builder` for robust schema generation.

## Phase 3: The Data Backbone (Reactivity & Persistence)
*Goal: Bridge the gap between the offline-first Drift database and the reactive genui DataModel.*

- [ ] **Re-engineer Data Persistence & Reactivity** (Status: `pending`)
    - [ ] Implement a `DataModelBridge` to map `Drift` entities to `genui` `DataModel` paths.
    - [ ] Establish the reactive sync pipeline: `Dr drift -> Repository -> DataModel -> GenUI Surface`.

## Phase 4: The Reconstruction (Migration)
*Goal: Deconstruct existing modules and rebuild them as Catalog-driven features.*

- [ ] **Refactor Domain Logic into Catalog Patterns** (Status: `pending`)
    - [ ] Migrate `WorkoutLog` logic to `WorkoutLogCard` CatalogItem.
    - [ ] Migrate `Symptom/Exercise` logic to relevant `Catalog` primitives.
    - [ ] Verification of end-to-end flow using `motus_hub` (the AI agent proxy).

---
*Last Updated: 2026-05-12*

