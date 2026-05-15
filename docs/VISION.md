# MyoTwin — Vision & Backlog

Features organized by interaction mode: **Reactive**, **Proactive**, **Adaptive**. Each feature includes a description, current phase, and dependencies.

> This is a living backlog. Features move from ideas → planned → in-progress → done. Add new features here, prune completed ones.

---

## Reactive — The User Calls, the System Responds

Features triggered by explicit user input (taps, voice, gestures, 3D interactions).

### Surface System (Core) ⭐
The entire GenUI surface architecture — CatalogItems, DataModel, SurfaceController, intent records, surface lifecycle.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: None (foundation)

### 3D Body Twin ⭐
Persistent interactive GLB model with layered mesh, vertex-group-driven heatmap, X-ray dissolve shader.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: GLB anatomy model (see `3D_ASSET_REQUIREMENTS.md`)

### FAB Interaction Pipeline
Single point of entry: tap → chat, long-press → STT, long-press+slide → hot-mic.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: 3D Body Twin (for FAB positioning)

### Context Surface (Node Tap + Panel Slide)
Tap anatomical node → surface with injury history, symptom logs, kinetic chains, regression ladder.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: 3D Body Twin, Surface System, Drift database

### Chat Surface
Text or voice conversation with Motus. Terminal-style data stream animation. FAB trigger.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: Surface System, Motus local

### Symptom Tagging (Natural Language)
User reports symptoms in prose → Motus categorizes (Stiffness / Sharp Pain / Dull Ache / Weakness) and tags body segments.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: Motus local, Drift database

### Hypothesis Engine
Scientific method lifecycle: Motus proposes → user performs → feedback → certainty score update. Surface renders hypothesis with rationale, regression/progression options, and user validation controls.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: Motus local, Drift database, Surface System

### Equipment Inventory
Natural language registration of equipment. Motus extracts equipment type, availability, configuration (ring height, weight, etc.) and stores in Drift.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: Motus local, Drift database

### Kinetic Chain Visualization
Chains draw themselves as dashed lines on the 3D body model. Stroke width and color reflect certainty. User can dismiss (sets certainty to -1.0).
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: 3D Body Twin, Hypothesis Engine

### Injury Vault
Persistent injury history with integrity scores. Status tracking: Acute / Dormant / Chronic. Surface shows full narrative, associated hypotheses, and recovery progress.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: Drift database, Surface System

### Injury Ladder
Systematic regression → progression path. Driven by integrity score threshold (0.7). Motus proposes next step with biomechanical rationale.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: Injury Vault, Motus calculator tools

---

## Proactive — The System Anticipates, the User Decides

Features where Motus initiates contact with the user based on its analysis of data.

### Heuristic Notification Engine ⭐
Motus evaluates session data post-workout and decides: notify now, notify later, or never. The heuristic considers time since last session, symptom trends, drive levels, user's learned active windows.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: Hypothesis Engine, Session analysis

### IntentRecord / Notification Payloads
Notifications carry a `source_intent_record_id` mapping to a pre-populated database object. Tapping a notification opens a Surface with Motus's full reasoning chain already loaded.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: IntentRecord architecture (PRODUCT.md)

### Grease-the-Groove Notifications
Motus schedules micro-interventions during optimal windows: *"Left shoulder is tight, 3min of band dislocates now would help."* These are low-friction, high-value nudges placed in user's idle/transition windows.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: Heuristic Notification Engine

### Session Analysis & Summary
Post-workout, Motus generates a research note: session summary, key insights, symptom changes, hypothesis updates. Stored in Knowledge Graph as ResearchNote.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: Session logging, Motus local

### Knowledge Retrieval Integration
Motus checks the local knowledge base before responding. Vector DB lookups for clinical research, Principles extracted from past research notes. Results injected into surface payloads.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: Knowledge Graph, Vector DB

### Desktop Notification Callouts
Desktop-specific: floating callout windows with tether lines from anatomical nodes. Spooling Manhattan routing. Frosted HUD. Context-specific interventions displayed spatially.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: Surface System, Desktop app

---

## Adaptive — The System Learns, Evolves, and Specializes

Features where Motus builds deeper understanding over time.

### Personalized Knowledge Graph ⭐
Motus builds a growing knowledge graph of *you*: recovery patterns, preferred training windows, symptom clusters, response rates to different intervention types. Stored using JSONB columns in Drift — evolving without migrations.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: Drift database (JSONB support), all reactive features

### Adaptive Notification Timing
Motus learns when YOU're most responsive to nudges. Tracks dismissal rates, engagement windows, correlation between notification type and response. Gradually optimizes scheduling.
- **Phase**: V1 (initial) → Phase 2 (refined)
- **Status**: Planned
- **Dependencies**: Heuristic Notification Engine, IntentRecord feedback tracking

### Server-Side Research Pipeline ⭐
Client Motus reports patterns/questions to server Motus. Server conducts deep research via LLM + knowledge sources. Returns ResearchNotes and extracted Principles. Synced back to client locally.
- **Phase**: V1
- **Status**: Planned
- **Dependencies**: motus_hub server, Ollama, Knowledge Graph sync

### Recovery Forecast Engine
Composite widget: *"Integrity: 0.7. Sleep: N/A. Training Load: Rising. Forecast: Prioritize recovery today."* Aggregates available data streams into a single insight.
- **Phase**: Phase 2
- **Status**: Backlog
- **Dependencies**: Injury Vault, Training Logs, Recovery data

### Sleep Integration (Future)
Pull sleep data → compute CNS Readiness Score → visual "Recovery Aura" on 3D model. Drives heuristic scheduling to avoid pushing during poor recovery.
- **Phase**: Phase 3+
- **Status**: Backlog
- **Dependencies**: Sleep API, Sensor integration

### Diet / Nutrition Tracking (Future)
Track restoration nutrients (collagen, Vit C, proline, omega-3). Correlate with inflammatory markers and symptom flare-ups. Tissue synthesis shader layer on GLB.
- **Phase**: Phase 3+
- **Status**: Backlog
- **Dependencies**: Food logging, API integration (optional)

### Computer Vision Movement Audit (Future)
Camera snapshot → MediaPipe tracking → exact ROM measurement. Confidence ~0.7. No video storage, only coordinate stream. Surface shows "Your shoulder external rotation: 95° (expected: 110°)."
- **Phase**: Phase 3+
- **Status**: Backlog
- **Dependencies**: Camera integration, MediaPipe Pose

### Calendar Integration (Future)
Motus listens for calendar events. Seated block → no notifications. Focus time → silent training suggestions. Meeting ended → mobility nudge.
- **Phase**: Phase 3+
- **Status**: Backlog
- **Dependencies**: Calendar API, OAuth2 credentials

### High-Fidelity Mace Physics (Future)
Real-time 3D visualization of rotational torque, eccentric loading. Mace mass/distribution data drives shader parameters.
- **Phase**: Phase 3+
- **Status**: Backlog
- **Dependencies**: Equipment inventory (mace data), Physics engine

### AR Muscle Overlay (Future)
Project 3D heatmap onto user's live camera feed. Overlay fatigue patterns on their own body.
- **Phase**: Post-V1
- **Status**: Backlog
- **Dependencies**: ARKit/ARCore, Camera frame processing

### Cardiovascular Mode (Future)
Dedicated Layer 2 in GLB with flow-based shaders. Pulse-synced to heart rate data.
- **Phase**: Post-V1
- **Status**: Backlog
- **Dependencies**: HR monitor integration

### Automated Scholar Scout (Future)
motus_hub periodically samples known research repositories (Figshare, Google Scholar) for biomechanical papers relevant to user's injury profiles. Parses → extracts Principles → adds to Vector DB.
- **Phase**: Post-V1
- **Status**: Backlog
- **Dependencies**: PDF parsing pipeline, Knowledge Graph

### Live Audio-Dialog State Machine (Future)
Hands-free conversation while training. Wake word detection. Context-aware audio routing (interruptible during exercise, passive during rest).
- **Phase**: Post-V1
- **Status**: Backlog
- **Dependencies**: Audio engine, Wake word detection

---

## Phase Summary

| Phase | Focus | Key Features |
|---|---|---|
| **V1** | Core experience | Surface system, 3D twin, chat, FAB, symptom tagging, hypothesis engine, injury vault, notifications, knowledge graph, basic server sync |
| **2** | Intelligence deepening | Recovery forecasting, refined adaptive timing, enhanced desktop features |
| **3+** | Multi-modal integration | Computer vision, calendar, AR, sleep/diet, live audio |
| **Post-V1** | Advanced features | Cardiovascular mode, automated research scout, high-fidelity physics |

---

**Document version**: 1.0
**Last updated**: 2026-05-14
