# MyoTwin Product Specification

## 1. What It Is

MyoTwin is a biomechanical coaching application that thinks about you — and shows it.

Instead of tabs, menus, and screens you navigate, MyoTwin presents **surfaces**: dynamic interfaces assembled in real-time by Motus, the application's biomechanical intelligence engine. The surface you see depends entirely on what your body needs *right now*.

### A Reactive Interface

You tap a node on the 3D body twin → a Context Surface surfaces with the data relevant to that region: symptom history, injury records, kinetic chain relationships. You long-press the FAB → voice chat opens. You say *"left shoulder clicked during ring support hold"* → Motus tags the symptom, proposes a regression, and renders it as selectable widgets — not walls of text. No hunting for data. The right information appears when it's relevant.

### A Proactive Presence

After a workout, Motus evaluates the session. It notices a pattern — shoulder symptoms climbing on the left at 100% drive — and uses heuristics to schedule a notification for your next sensible window: *"Try dropping left-side drive to 80% today. Here's why."* When you tap it, the notification carries a `source_intent_record_id` pointing to a database object Motus pre-populated with the full reasoning chain: symptom logs, integrity scores, the kinematic analysis. Tapping opens a Surface Motus designed for that exact moment — the injury vault summary, the proposed adjustment, a regression ladder.

This is **greasing the groove**. Motus optimizes for recovery volume balance — nudging you toward productive movement during windows when your body is primed but not fatigued. Never at 2am. Never when you're mid-sleep. The heuristic engine reasons about circadian timing, time since last session, symptom trends, and drive history before ever deciding to interrupt.

### An Adaptive Partner

Over weeks and months, Motus builds a knowledge graph of *you*. Every action, denial, and symptom becomes data:

- You consistently dismiss left-side stretching → Motus notes the pattern, adjusts confidence
- Server-side research correlates your injury history with clinical findings → new Principles populate the local knowledge base
- Recovery patterns emerge in your data → Motus learns when you're primed for volume and when to hold back
- Goals you set (regression from injury, progression to a skill) become tracked objects with hypotheses, feedback, and progress curves

The local Motus (Gemma 4 E2B via llamadart / llama.cpp) handles real-time interaction, symptom tagging, and heuristic scheduling. The server Motus (Ollama on your Unraid GPU) conducts deeper research, periodically syncing findings back to the client's local knowledge graph. The client adapts its notification cadence, surface urgency, and UI density based on what's working.

### The Experience in Three Layers

| Layer | Role | Example |
|---|---|---|
| **Viewport** | The 3D foundation — your body twin, always visible | Heatmap pulses, X-ray dissolve between anatomical modes |
| **Interaction Surface** | Transient, AI-generated overlays | Context Surface on tap, Chat Surface via FAB, Action Surface for interventions |
| **Catalog** | The vocabulary of widgets Motus can instantiate | `InjuryDetailCard`, `RegressionLadder`, `SymptomInput`, `ActionBtn` |

No static screens. No predetermined navigation. The interface assembles itself around your biomechanical state.

---

## 2. Surface Architecture

### GenUI Foundation

MyoTwin uses Flutter's **genui** framework to compose UI from a widget catalog at runtime. The agent (Motus) selects `CatalogItem` definitions and populates them with data paths — not text descriptions. State changes in any surface widget feed back through a `DataModel` to Motus, creating a bidirectional interaction loop.

### Surface Lifecycle

```
User Signal → Motus (local) → A2uiMessage → SurfaceController.createSurface(id)
                                                      ↓
                                            DataModel hydration with CatalogItem payloads
                                                      ↓
                                            User interacts → state changes → feedback to Motus
                                                      ↓
                                            User dismisses → SurfaceController.dispose() → clean teardown
```

### Surface Types

| Surface | Trigger | Purpose |
|---|---|---|
| **Chat Surface** | FAB tap / FAB long-press | Text or voice conversation with Motus |
| **Context Surface** | 3D node tap | Anatomical deep-dive: injuries, symptoms, kinetic chains |
| **Action Surface** | Motus-initiated | High-salience interventions: workout proposals, postural checks, recovery prompts |

### IntentRecords — The Bridge Between Intelligence and Interface

An **IntentRecord** is a database object Motus creates when making a decision. It carries the "why" behind a Surface.

```dart
// Conceptual structure
IntentRecord {
  String id;
  String goalId;                    // Parent goal this serves
  IntentType type;                  // notification / survey / action_proposal / research_summary
  Map<String, dynamic> payload;     // GenUI CatalogItem configuration
  DateTime scheduledTime;
  DateTime? deliveredAt;
  double? userEngagementScore;      // Updated as Motus observes user behavior
  String reason;                    // Human-readable heuristic summary
  // References to children
  List<String> hypothesisIds;       // Scientific method records backing the decision
  List<String> researchNoteIds;     // Server research informing the decision
}
```

A **Goal** is the parent object under which IntentRecords, Hypotheses, ResearchNotes, and ProgressRecords live:

```dart
Goal {
  String id;
  String label;                     // "Left Shoulder Recovery", "Ring Muscle-Up Progression"
  GoalStatus status;                // active / paused / achieved / abandoned
  Map<String, dynamic> metadata;    // Structured data (JSONB) — evolving, shaped by Motus
  DateTime createdAt;
  DateTime? updatedAt;
}
```

Motus uses `IntentRecord.source_intent_record_id` in its notification payloads so that tapping a notification doesn't just say "notification opened" — it says "open this surface with intent record X, which contains hypothesis Y, research Z, and reason W." The surface assembles with context already present.

### Surface Generation Flow

1. Motus (local or server) decides an action is needed
2. It creates an `IntentRecord` under the relevant `Goal`, populating the `payload` with GenUI `CatalogItem` configurations
3. For notifications: `scheduledTime` is determined by heuristic engine
4. At delivery: `SurfaceController.createSurface(id)` assembles the UI from the payload's `CatalogItem` definitions
5. User interaction → state changes in `DataModel` → feedback loop to Motus for future adaptation

### Catalog Protocol

Every `CatalogItem` in the application:
- Defines a `dataSchema` via `json_schema_builder`
- Binds to `DataModel` paths (never passes raw strings/ints to constructors)
- Is idempotent — same `surfaceId` yields the same UI on re-render
- Is disposed properly — all `StreamSubscription`s and animations cleaned up on Surface destruction

---

## 3. Motus Intelligence

### Two Engines, One Mind

| | Local Motus | Server Motus |
|---|---|---|
| **Model** | Gemma 4 E2B (~2.1B params) via llamadart | Multiple full models via Ollama |
| **Architecture** | llama.cpp backends (Metal/CoreML on iOS) | Llama.cpp server, GPU-accelerated |
| **Role** | Real-time interaction, symptom tagging, heuristic scheduling, context window management | Deep research, pattern analysis, hypothesis formulation, Principle extraction |
| **Access** | Always available, offline | Requires network connection to Unraid |
| **Output** | Chat responses, symptom tags, notification schedules, surface prompts | ResearchNotes, Principles, PatternReports, new Hypotheses |
| **Adapters** | LoRA adapters for domain specialization (fitness, medical, biomechanics) | Full fine-tuned models |

### Multi-Model Architecture (Client-Side)

MyoTwin uses a single base model with **LoRA adapters** for domain-specific behavior. The LoRA (Low-Rank Adaptation) approach loads one base model (~250 MB on iOS) and dynamically applies lightweight adapters (~150 MB each) at runtime:

| Adapter | Domain Effect |
|---|---|
| Base (E2B) | General reasoning, language, tool calling |
| Fitness Coach | Volume progression, recovery optimization, training programming |
| Medical Advisor | Injury pathology, rehabilitation protocols, clinical caution |
| Biomechanics Expert | Torque/leverage, joint mechanics, kinetic chains, physics |

**Intent Classification** routes each user message to the appropriate adapter:

```
User: "Shoulder clicked during support hold"
     ↓
Classify (5ms) → IntentDomain.medical
     ↓
Load: medical_advisor_adapter
     ↓
Generate response with clinical caution
     ↓
Reset adapter for next call
```

Memory budget: **~400–600 MB total** (base model + one adapter active, Flutter + 3D ~500 MB). Well within iPhone RAM. For full architecture details, see [MULTI_MODEL_ARCHITECTURE.md](./MULTI_MODEL_ARCHITECTURE.md).

### Heuristic Scheduling Engine

When Motus decides the user needs a nudge, the scheduling heuristic evaluates:

```
Notification Eligibility = Base Urgency × Time Window × Personalization

Base Urgency:
  - Acute symptoms → immediate
  - Session recovery → next sensible window (6-12h)
  - General greasing-groove → scheduled into low-symptom, low-drive windows

Time Window:
  - Check user's active hours (learned from interaction history)
  - Never during sleep windows (learned or configured)
  - Respect time since last session (2h cooldown minimum)
  - Respect session end grace period (15min cooling after workout)

Personalization:
  - Historical response rate to similar notifications
  - User's recent trend (responsive → increase frequency; dismissive → decrease / change timing)
  - Time of day preferences learned over weeks
```

The heuristic output becomes the `reason` field in the `IntentRecord`:
> *"Scheduled for ~10:00 AM during your typical prep window. Symptoms suggest left-side shoulder tightness at 100% drive based on 3 consecutive sessions. Historical response rate to similar nudges is 73%. 18h since last session."*

### Knowledge Graph

Motus's knowledge graph stores domain information as:

- **Principles** — Biomechanical rules extracted from research (e.g., "Joint-by-Joint Approach")
- **ResearchNotes** — Findings from server-side research sessions
- **Hypotheses** — Testable claims about the user's biomechanics, tracked with certainty scores over time
- **KnowledgeSource** — Raw ingested materials (PDFs, URLs, text notes from the user)

**Sync flow:**
```
Client Motus → reports interesting patterns / questions to server
Server Motus → conducts deep research → produces ResearchNotes + new Principles
Server Motus → syncs updates to client locally
Client Motus → uses enriched knowledge for local decisions and heuristic improvement
```

### Informed Autonomy

Motus never blocks, never forces. It:
1. Presents choices with biomechanical rationale
2. Offers regression and progression paths
3. Explains the clinical lens applied (General Population Safety / Elite Athletic Standards)
4. Records user feedback for future adaptation

The user is the principal investigator. Motus is the data analyst.

---

## 4. Data Architecture

### Unstructured Intelligence: Extension Types & JSONB

MyoTwin avoids rigid relational schemas for AI-driven data. Instead of constant migrations, the system leverages a "flexible core" approach:

- **Relational Anchor**: Core entities (Goal, IntentRecord, Hypothesis) maintain strict, indexed SQL columns for metadata that requires fast relational querying (IDs, timestamps, foreign keys, status enums).
- **JSONB Blobs**: Evolving, Motus-shaped data lives in `JSONB` columns (using SQLite's JSON1 extension). This allows the agent to discover and track new attributes (e.g., `shoulder_click_frequency`) without database changes.
- **Dart Extension Types**: Zero-cost abstractions that wrap raw `Map<String, dynamic>` JSON blobs with strongly-typed Dart APIs. This provides compile-time safety and IDE autocomplete without the overhead of heavy model classes or `fromJson` boilerplate.
- **Agent-Defined Schemas**: Motus is responsible for shaping its own data and defining GenUI payloads. The `IntentRecord.payload` is an unstructured map that the UI layer dynamically inflates into widgets using the `genui` registry.

### Data Model Bridge

A `DataModelBridge` maps Drift database entities to genui `DataModel` paths, establishing a reactive pipeline:

```
Drift Database (JSONB) → Repository → Extension Type → DataModel → GenUI Surface
                                                                        ↓
                                                          State changes feed back to DataModel
                                                                        ↓
                                                          DataModelBridge writes back to Drift
```

### Data Point Provenance

Every data point carries a `SourceType`:

| Source | Confidence | Example |
|---|---|---|
| `manual` | High | User types "shoulder tightness, 7/10" |
| `computed` | Variable | Symptom computed from kinetic chain propagation |
| `vision` | ~0.7 | MediaPipe pose tracking from camera snapshot |
| `rag` | Variable | Knowledge derived from research vector DB |

Source type enables confidence tracking across the system, informing Motus's certainty scores and heuristic weighting.

---

## 5. Tech Stack

| Layer | Technology |
|---|---|
| **UI Framework** | Flutter (latest stable) |
| **Generative UI Engine** | `genui` (Surface-based widget assembly, A2UI protocol) |
| **UI Vocabulary** | `json_schema_builder` for CatalogItem schema definition |
| **State Management** | genui `DataModel` (Reactive, path-based observable state) + BLoC for static shell state |
| **Database** | Drift (SQLite, background isolate, JSONB via SQLite extensions) |
| **Local LLM** | Gemma 4 E2B (~2.1B params) via llamadart (llama.cpp) |
| **Local Inference Engine** | llamadart — Cross-platform GGUF runner, LoRA adapters, tool calling, Metal/CoreML on iOS |
| **External LLM** | Ollama (OpenAI-compatible) on Unraid GPU server |
| **Model Sources** | HuggingFace GGUF files via `hf://` protocol, cached locally |
| **3D Engine** | Flutter GLB/GLTF (layered mesh, shader-driven heatmap) |
| **Communication** | `bonsoir` (mDNS/Zeroconf) for local discovery |
| **Architecture** | Clean Architecture (3-tier monorepo via Melos) |

### Monorepo Structure

```
myotwin/
├── packages/
│   ├── shared_core/          # Entities, interfaces, biomechanical services, enums
│   ├── motus_hub/            # Dart server — LLM orchestration, tool calling, research pipeline
│   ├── myotwin_mobile/       # Flutter mobile app
│   ├── myotwin_desktop/      # Flutter desktop app
│   └── myotwin_test_support/ # Mock repositories and test utilities
```

**Packages rules:**
- Packages are independent — no cross-package imports except through `shared_core`
- `myotwin_mobile` and `myotwin_desktop` never import each other
- `motus_hub` never imports Flutter packages
- All domain logic lives in `shared_core`

### Performance

- **16ms rule**: Any operation >16ms moves to a background Isolate or `compute()`
- All Drift queries on background isolate via `DatabaseIsolate`
- LLM prompt construction and parsing in `motus_hub`, not on the UI thread
- Heavy JSON parsing off the main thread

### Privacy

Zero-cloud. Zero-telemetry. Local-only. All data stays on the user's machine. No location tracking. Ever.

---

**Document version**: 1.0
**Last updated**: 2026-05-14
