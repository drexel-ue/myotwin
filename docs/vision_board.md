# MyoTwin — Vision Board (Future Features)

Features discussed during the deep-architecture phase but explicitly excluded from V1. Parked here so V1 developers don't build them and future developers have the architectural hints needed.

## UI/UX — Parked

### Mechanical Explosion Transition
- **Scope**: "Iron Man HUD" style disassembly of the 3D anatomy model.
- **Architecture Hint**: Model must be rigidly segmented into logical parent groups. Radial offset from spine's Core Node. Pushes rigid groups outward in parallel. See `product_spec.md` Section 4.4.
- **Phase**: 2
- **Dependencies**: X-ray dissolve shader must be stable first.

### Cardiovascular Mode
- **Scope**: Dedicated Layer 2 in the GLB with flow-based shaders for heart/vessel visualization.
- **Architecture Hint**: Pulse-synced shader uniforms (`u_pulsePhase`, `u_pulseIntensity`). Requires HR data source.
- **Phase**: Post-V1
- **Dependencies**: HR monitor integration.

### AR Muscle Overlay
- **Scope**: Project MyoTwin heatmap onto the user's live camera feed.
- **Architecture Hint**: Requires ARKit/ARCore + camera frame processing.
- **Phase**: Post-V1

### Automated Scholar Scout (Research Scout)
- **Scope**: motus_hub automatically polls UC Figshare/Scholar@UC APIs for new biomechanical research, parses into Principles, adds to Vector DB.
- **Architecture Hint**: Dart HTTP client polling `api.figshare.com`. OAI-PMH for Scholar@UC. PDF parsing pipeline.
- **Phase**: 2+
- **Dependencies**: Error-tolerant PDF parsing. Start with manual ingestion in V1.

### Calendar-Driven Context
- **Scope**: Motus "listens" for calendar events. On meeting end → notification. During "Focus" blocks → silent.
- **Architecture Hint**: OAuth2 service in motus_hub for Google/Outlook API polling. Derived metadata only (e.g., "Seated block duration: 45 min").
- **Phase**: 2+
- **Dependencies**: OAuth2 credentials (Google/O365).

### Computer Vision — Snapshot Assessment
- **Scope**: User propped in front of camera performs a movement; MediaPipe tracks 33 joint landmarks to compute exact ROM.
- **Architecture Hint**: `SourceType.vision` on all CV data points. Confidence Score ~0.7 for new data. No video storage — only coordinate stream.
- **Phase**: 3+

### Computer Vision — Live Form Audit
- **Scope**: Camera stays active during structural loading; real-time AR overlay with corrective cues.
- **Architecture Hint**: Real-time MediaPipe Pose Landmarker. Audio interruption must be bulletproof.
- **Phase**: 3+

### Live Audio-Dialog State Machine
- **Scope**: Hands-free conversation while hanging from rings — wake word detection, context-aware audio routing.
- **Phase**: Post-V1

### High-Fidelity Mace Physics
- **Scope**: Real-time 3D visualization of mace torque and rotational forces.
- **Phase**: Post-V1
- **Dependencies**: Mace mass/distribution data. Rotational physics for eccentric axis.

## Biological Layers — Post-V1

### Sleep Integration
- **Scope**: Pull sleep data. Compute CNS Readiness Score. Pulsing "Recovery Aura" visual on model.
- **Architecture Hint**: `NoiseLog` table for sleep entries. `u_recoveryIntensity` shader uniform.
- **Phase**: Post-V1

### Diet Integration
- **Scope**: Track "Restoration Nutrients" (collagen, Vit C, proline, omega-3). Inflammatory Index. Tissue Synthesis Shader layer on GLB.
- **Architecture Hint**: `NoiseLog` with food/nutrient entries. Dietary triggers for correlation with symptom flare-ups.
- **Phase**: Post-V1

### Recovery Forecast Engine
- **Scope**: Composite widget in the Anatomical Detail View: "Integrity: 0.7. Sleep: Poor. Diet: Inflammatory. Forecast: Prioritize anti-inflammatory."
- **Architecture Hint**: Requires `RecoveryForecaster` use case aggregating InjuryVault, NoiseLog, TrainingLog.
- **Phase**: Post-V1

---

**Document version**: 1.0
**Last updated**: 2026-05-11
