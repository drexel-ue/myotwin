# MyoTwin — Product Specification

## 1. Vision & Core Objective

**MyoTwin** is a privacy-first, local-only Flutter application for functional strength, work capacity, and mobility coaching. It functions as a proactive **biomechanical research & coaching lab** that treats the user's physical state as an N=1 clinical trial.

The **Motus** agent lives inside MyoTwin. It is the inference engine — not the app itself. MyoTwin is the interface and orchestrator; Motus is the scientific brain.

Core capabilities:
- Schedules exercises and movements throughout the day based on real-time user feedback.
- Tracks symptoms, builds kinetic chain hypotheses, and adjusts recommendations using the scientific method.
- Runs **Motus local inference** (Gemma 4:e4b via MediaPipe) for fast chat, with automatic fallback to **Motus external auditor** (Ollama via OpenAI-compatible API on Unraid) for deep research.
- Persists all data locally via Drift (SQLite) in the Application Documents Directory.
- Syncs across devices on the same local network (phone + Mac workstation).
- All data stays local. No telemetry. No cloud dependency. No location tracking.

## 2. Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (latest stable) |
| State Management | BLoC (event/state pattern) |
| Database | Drift (SQLite, background isolate) |
| Local LLM | Gemma 4:e4b via MediaPipe LLM Inference |
| External LLM | Ollama (OpenAI-compatible) on Unraid GPU server |
| Monorepo | Melos |
| Error Handling | fpdart (`Result<T, Failure>`) |
| Routing | GoRouter (deep-link support) |
| Speech (Input) | speech_to_text (platform-native STT) |
| Speech (Output) | flutter_tts (TTS audio dialog) |
| Notifications | flutter_local_notifications |
| Local Discovery | bonsoir (mDNS/Zeroconf) |
| 3D Model | GLB/GLTF (layered mesh, shader-driven) |
| Background Tasks | workmanager |

## 3. Monorepo Architecture (3-Tier)

The project is a Melos-based monorepo. The architecture is three-tier, not monolithic:

| Package | Purpose |
|---|---|
| `shared_core` | Pure Dart domain layer: entities, value types, repository interfaces, Drift schema definitions, biomechanical logic engine, enums. Zero Flutter dependencies. |
| `myotwin_mobile` | Flutter mobile client: 3D anatomical viewer, X-Ray/Heatmap shaders, FAB interaction, full-screen flow mode, neural priming UI. |
| `motus_hub` | Dart server (runs on Unraid/Mac). Interfaces with Ollama, orchestrates LLM tool calling, manages Vector DB for research, schedules background audits, provides REST/WebSocket API to clients. |
| `myotwin_desktop` | Flutter desktop client: floating spatially-anchored callout windows, multi-node kinetic chain views, deep audit dashboard, knowledge ingestion manager. |

**Golden Rule**: Mobile and desktop are separate presentation layers on the same nervous system. They share `shared_core` via a package reference. They never import each other.

## 4. UI/UX — The "Magic" UI

### 4.1 Design System Reference

- **Palette**: Black & white high-contrast. Deep blacks (#000000–#1A1A1A), pure whites (#FFFFFF). Intentional color only for biological status indicators (heatmap, injury flags, validation states).
- **Typography**: Monospaced for data/labels (`JetBrains Mono`). Clean sans-serif for body (`Inter`, `Space Mono`).
- **Shape**: Frosted HUD aesthetic. Blurred black backdrops, ultra-thin white borders inset by 3–4px from frosted edge.
- **Motion**: Mechanical. Constant-velocity path extraction for tethers. Linear easing, no organic curves. "Draw itself" animation for window spawning.
- **Aesthetic**: Technical blueprint / mechatronic / clinical scientific tool. High-tech but disciplined.

### 4.2 FAB Interaction Flow

```
            ┌──────────────┐
            │   FAB State   │
            └──────┬───────┘
                   │
         ┌─────────┼──────────┐
    Single Tap  Long Press  Long Press + Slide Up
                 │             │
            Chat Sheet     STT Session    Lock Mic "Hot"
```

- **Tap FAB** → Motion proposal window stems from FAB, blooms to full screen. User accepts or generates alternative.
- **Long press** → Activates Speech-to-Text.
- **Long press + slide** → Locks mic "hot." Release by tapping FAB again. Pulsing FAB animation while hot.
- **Live transcription** streams into the chat view.

### 4.3 Proposal Flow (Mobile V1)

1. MOTUS FAB pulses (activates).
2. Line stems from FAB → blooms to full-screen Motion Proposal.
3. Proposal content: Intent (e.g. "Upper Cross Syndrome Mitigation"), Equipment ("Rings @ Hip Height"), Duration ("~4 min"), Rationale ("Based on 90m seated focus and neck heat").
4. Two large CTAs: "Begin Flow" / "Generate Alternative".
5. Upon acceptance → 3D model auto-rotates to first target muscle. Window blooms from that node → full-screen Action Window.
6. Completion → User taps "Done" or says "Done". Window implodes into node. Node color shifts (validated).
7. Next target spawns. Repeat sequence.

### 4.4 3D Body Map (Primary UI)

Anatomical GLB model, rotatable, pinch-zoomable.

**Layered Anatomy (Single GLB, distinct object groups):**
- Layer 0: Skeletal (ghost layer, always visible at low alpha).
- Layer 1: Musculoskeletal (Strength/Mobility mode heatmap).
- Layer 2: Cardiovascular (Work Capacity mode — V2).

**Heatmap Overlay:** Vertex-group-driven emissive color interpolation. Drift symptom log frequency/intensity drives color. Debounced to 150ms.

**Mode Overlay Selector (Mobile: FAB or floating toggle):**

| Mode | Heat Represents | Chains Represent |
|---|---|---|
| Mobility | Joint restriction & stiffness | Compensatory patterns (e.g. tight hip → arching lower back) |
| Functional Strength | Muscle fatigue & recovery | Synergistic loops (e.g. grip limiting pull-up volume) |
| Work Capacity | Systemic fatigue / HR zones | Peripheral vs. central fatigue |

**X-Ray / Dissolve Transition (V1 default):** Fragment shader-driven "ghosting" style. Minimum alpha floor (`u_ghostAlpha`, default 0.1). Active focus = 1.0 alpha. Context layers = ghostAlpha. Transition driven by `AnimationController` (500ms tween). "Dissolve" where muscles fade as veins pulse in.

**Mechanical Explosion (Vision Board):** Radial offset algorithm from spine's "Core Node." Pushes rigid groups outward in parallel. Phase 2 feature.

**Kinetic Chain Overlay:** Bezier curves between connected nodes. Thickness = correlation strength. Opacity = certainty score (0.0–1.0).

**Anatomical Detail View (Draggable Bottom Sheet):**
Upon tapping a node or chain:
- Vital signs: Current Heat, Integrity score.
- Injury flag from Vault (if chronic/acute).
- Motus insight: 2-sentence explanation ("Detected compensatory load...").
- Activity log: Last 3 interactions with the node.
- Kinetic chain view: Chain tension, weak link, restoration path.
- Research dossier: Cited sources, hypothesis history, principle citations.

### 4.5 Desktop UI — Floating Callout Windows

- **Platform detection**: `Platform.isDesktop` → bypass full-screen action overlay.
- **Floating HUD windows** at (x,y) nearest the target muscle node.
- **Spooling tether** (Manhattan routing): Straight 90-degree corner elbows only. Dynamic segment creation/collapse. No resistance when dragged. Grid-snapping (8px/16px).
- **Collision avoidance**: Windows fan out so they do not overlap.
- **Multi-node correlation**: Tap one node → spawn callouts for related nodes, draw tether lines between all three.
- **Occlusion handling**: When node is behind geometry, tether transitions to dashed gray (`Colors.white24`).
- **Docking**: Drag to screen edge → snap to sidebar. Tether becomes single horizontal line.
- **Window style**: Frosted HUD (dark glassmorphism). White inset border (1pt) inset 4px from frosted edge. Corner brackets. Status glow on data updates.

**Draw animation**: Line "shoots" at constant velocity (e.g. 500px/s). Micro-pause at each elbow ("change gears"). On contact with window, white inset border draws perimeter, frosted pane fades in. Leading edge pure white with 2px glow.

## 5. Functional Modules

### 5.1 The Scientific Hypothesis Engine

Every movement suggestion is a test of a hypothesis.

**Data model:**
- **Hypothesis**: `id`, `target_node`, `linked_nodes[]`, `statement`, `certainty_score` (0.0–1.0), `status` (Active, Proven, Refuted, Blacklisted).
- **Source**: `id`, `title`, `author`, `link`, `key_takeaway`, `relationship_to_hypothesis`.
- **Principle**: Ingested biomechanical rules (from user-uploaded content or Motus).
- Every recommendation wrapped in a `Hypothesis`. Certainty updates over time based on user feedback (positive/negative/neutral).
- User can "Dismiss Chain" → `certainty_score = -1.0` (Blacklisted).

### 5.2 The Injury Vault

Tracks old and new injuries. Distinct from temporary symptoms.

- **Acute**: Recent (last 0–6 weeks). Active pain/tissue stress.
- **Dormant**: Old (healed). Potential for flare-ups.
- **Chronic**: "Never healed right." Persistent structural limitation.
- **Integrity Score**: Float 0.0–1.0. Drifts over time based on feedback.
- **Functional Offsets**: Specific limitations (e.g., "Reduction of shoulder flexion to 150°").
- **Narrative**: Natural language description.
- **Visual**: "Scar tissue" shader overlay. Chronic injuries = desaturated grey/blue on 3D model. Fades as Integrity → 1.0.

### 5.3 The Restoration Ladder

For every lost function: regression → progression ladder.

- **Neural Priming (GtG)**: High-frequency, low-impact "Grease the Groove" throughout day. Purely for motor pattern maintenance / CNS activation.
- **Structural Loading**: Higher-intensity, mechanical tension-driven. Time-under-tension, moment arm manipulation to rebuild tendon/bone integrity.
- **Validation**: User feedback ("How did that feel?") drives ladder movement. If zero pain + low stiffness → propose next step. If flare-up → revert.
- **Hybrid**: Motus weaves both. Neural priming 9am–5pm in office. Structured loading 1–2x/week.

### 5.4 Equipment Inventory & Leverage Engine

User registers equipment via natural language conversation ("I set up my rings and grabbed my mace"). Motus parses + stores.

**Leverage Engine (Physics):**
Motus calculates difficulty via `τ = F · d · sin(θ)` (moment arm manipulation) rather than external weight.
- **Gymnastics Rings** (adjustable, from pull-up bar): High-tension isometrics, variable leverage by height.
- **Parallettes**: Closed-kinetic-chain compression loading (L-sits, planche leans).
- **Mace**: Offset rotational loading.
- **No equipment**: Iso-metrics, self-resisted movements.

**Ring Height Calibration (Anatomical landmarks):**

| Height | Mode |
|---|---|
| Overhead | Passive/Active hangs — spinal decompression. |
| Sternum | Inclined rows — postural correction. |
| Waist/Hip | Support holds — structural loading. |
| Knee | Push-up variations — moderate chest/shoulder load. |
| Floor | Planks/rollouts — core compression. |

### 5.5 Knowledge Ingestion & Research (RAG)

- **KnowledgeSource**: Raw data user provides (PDFs, text, URLs, pasted papers).
- **Principle**: Parsed biomechanical rules / claims extracted from KnowledgeSource.
- **ResearchNote**: Background auditor findings.
- **V1**: Manual paste/upload in chat. Motus Hub processes + stores.
- **Phased 2+**: Automated Scholar Scout (UC Figshare/Scholar@UC API).

**Context Management (Motus Hub):**
- **Tier 1 — System Prompt**: Minified JSON Snapshot (InjuryVault, EquipmentRegistry, active hypothesis).
- **Tier 2 — RAG**: Vector DB lookups on demand. Only top 3–5 relevant snippets injected.
- **Tier 3 — Summarized Memory**: Old chat compresses to metadata summaries once >25% of token limit is approached.

**Clinical Lens (Dual Filter):**
Motus analyzes experience-based feedback through two lenses:
1. **GenPop Safety** (floor): Prevent injuries during office resets.
2. **Elite Performance** (ceiling): Long-term mastery pathway via rings/parallettes.
- Safety check must pass before any elite cue is offered.
- Integrity threshold: >0.75 to unlock Elite library cues.

### 5.6 Proactive Notification System

- Dynamic scheduling: Agent decides timing based on post-session feedback + injury state.
- Creates `NotificationContext` entry in Drift with **UUID deep-link** (e.g., `deeplink://chat?context_id=<uuid>`).
- On tap → GoRouter navigates to chat bottom sheet. Context pre-injected by UUID lookup.
- Post-interaction: Agent asks "How'd that feel?" → scores feedback → next notification interval calculated.

### 5.7 Drive & Intensity Settings

- **Global Drive**: User sets intent level ("2-week deload" / "I'm feeling a 7 today").
- **Per-node Drive**: Different intensity levels for shoulder vs. core vs. legs.
- **Safety Margin (S_margin)**: `S_margin = (Integrity Score × Consistency Weight) / Acute Symptom Intensity`.
  - Low S_margin → GenPop logic (short levers, high angles, low threat).
  - High S_margin → Unlocks Elite cues, higher torque targets.
- **Informed Autonomy**: Never block user action. Adjust S_margin, offer safer options. Always present choices.

### 5.8 Multi-Device Local Sync

- mDNS via bonsoir for discovery.
- Mac Mini / Unraid as primary source of truth.
- WebSocket sync: phone → Mac (push logs), Mac → phone (pull research notes).
- Graceful degradation: phone operates local-only when Mac is offline.

## 6. Non-Functional Requirements

| Category | Requirement |
|---|---|
| Performance | 16ms rule — no operation >~16ms on main isolate. All JSON parsing, heavy SQL, LLM prompt construction on isolates. |
| Reliability | All LLM calls, network requests, DB imports/exports → `Result<T, Failure>` (fpdart). Silent fallback to local-only. |
| Privacy | All data local. No telemetry. Zero cloud. Explicitly no location tracking. |
| Memory | Context Window Janitor — summarize old chat to ResearchNote, purge raw history. |
| Thread Safety | Drift Background Isolate (`DatabaseConnection.daemon`). No shared mutable state between isolates. |
| Frame Budget | 60 FPS target. No synchronous work in render callbacks. Heatmap color updates debounced to 150ms. |
| UI | Never `setState()` for heatmap updates — use `BlocBuilder`/`StreamBuilder`. All `StreamSubscription` and `AnimationController` disposed in `close()`. |

## 7. Folder Structure (Monorepo)

```
myotwin/
├── melos.yaml
├── packages/
│   ├── shared_core/            # Domain: entities, interfaces, Drift schema, biomechanical engine
│   ├── myotwin_mobile/         # Flutter mobile client
│   ├── myotwin_desktop/        # Flutter desktop client (control room)
│   ├── motus_hub/              # Dart server: Ollama client, tool calling, RAG, scheduler
│   └── myotwin_test_support/   # Shared mocks & fakes
├── docs/
│   ├── product_spec.md
│   ├── agents.md
│   ├── architecture_rules.md
│   ├── project_state.md
│   ├── hurdle_tracker.md
│   ├── vision_board.md
│   ├── 3d_asset_requirements.md
│   ├── motus_tool_spec.md
│   └── session_handoff_template.md
├── system_health.md
└── README.md
```

---

**Document version**: 2.0
**Last updated**: 2026-05-11
