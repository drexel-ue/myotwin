# MyoTwin — Hurdle & Decision Log

## Active Hurdles

## [Hurdle #1] The GenUI Transition (The Great Pivot)
- **Discovery Date**: 2026-05-12
- **Description**: Transitioning the entire application architecture from static, page-based routing to a dynamic, `genui`-driven "Surface" architecture.
- **Root Cause**: Realization that a GenUI approach (using `CatalogItems`) better aligns with the "Motus" agent's ability to provide real-sme, context-aware feedback and 3D interaction.
- **Status**: `In Progress` (Redrafting documentation/governance).
- **Proposed Solution**: Redefine `product_spec`, `architecture_rules`, and `agents` to prioritize `Catalog` primitives and `Surface` instantiation.

## Completed Hurdles

| # | Description | Resolution | Date |
|---|---|---|---|
| 1 | Architecture choice | Selected BLoC + Clean Architecture + Drift for maximal agent support | 2026-05-09 |
| 2 | Local vs External LLM | Local first (Motus via mediapipe) + Motus external auditor on Ollama | 2026-05-09 |
| 3 | Database persistence | Drift in Application Documents Directory + export/import | 2026-05-09 |
| 4 | Body map approach | 3D GLB muscle model with vertex coloring, not flat SVG | 2026-05-09 |
| 5 | **GenUI Pivot** | Rewrote core architecture, agent, and product specs to support dynamic surfaces | 2026-05-12 |

## Past Decisions

| # | Decision | Rationale | Status |
|---|---|---|---|
| D1 | BLoC over Riverpod | More documentation for coding agents to follow | Resolved |
| D2 | Drift over Isar | Relational data modeling, portability | Resolved |
| D3 | Monorepo over single package | Clean architecture boundaries, independent versioning | Resolved |
| D4 | Natural language symptom tagging | More flexible than fixed lists; model does the tagging | Resolved |
| D5 | User-uploaded PDFs as knowledge | Agent reasons from user's own domain material | Resolved |
| D6 | **Surface-based UI** | Enabled real-time, context-dependent widget assembly via `genui` | Resolved |

## Known Issues (Post-Development)

> **This section is populated during development.**

---

**Document version**: 2.0
**Last updated**: 2026-05-12
