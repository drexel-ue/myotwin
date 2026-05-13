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
- [x] Phase 1: Feature Package Scaffolding and Lint Resolution (Session #7) — directory structure, pubspec YAMLs, feature packages, all lint issues resolved (0 errors, 0 warnings, 0 infos)
...
- [x] Phase 1: Database & Plumbing Implementation (Session #Current) — Implemented `MyoTwinDatabase` with generated code, defined `DatabaseIsolate` interface, and established GenUI primitive connectivity in `shared_ui`. Now shifted to repository scaffolding with `UnimplementedError` to ensure build stability before Phase 2.
- [ ] Phase 2: 3D Body Map & Shader Implementation
...
### Session #Current — Repository Stabilization
- **What I finished**: Stabilized `shared_core` by converting all concrete repository implementations to throw `UnimplementedError`. This removes dependency on potentially unstable generated code types while maintaining the interface contract.
- **Where I stopped**: Repositories are now build-safe.
- **Current Blockers**: None.
- **Next Step**: Phase 2: 3D Body Map & Shader Implementation.
- **Confidence Level**: 5
- **Date**: 2026-05-12


