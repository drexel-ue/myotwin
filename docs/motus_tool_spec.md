# MyoTwin Motus Tool Calling Specification (V1)

## Purpose

Defines the tool calling interface the **Motus Hub** exposes to the LLM (Gemma local / Ollama external). These tools let Motus interact with the biomechanical engine, the database, and the user interface without guessing numbers or hallucinating calculations.

**Golden Rule**: Motus MUST use these tools for ALL biomechanical calculations. Never estimate torque, leverage, ROM, or progression steps in natural language.

## Tool Protocol

Tools are exposed as JSON Schema definitions. The LLM receives them as available functions and responds with a `tool_calls` array containing the tool name and parameters. The Motus Hub executes each tool and returns a `ToolResult` object with `tool_call_id` and `content`.

Example LLM response:
```json
{
  "tool_calls": [
    {
      "id": "tool_abc123",
      "name": "calculate_torque_load",
      "arguments": {
        "bodyWeightKg": 80.0,
        "angleDegrees": 45.0,
        "leverLengthM": 0.3
      }
    }
  ]
}
```

Motus Hub response:
```json
{
  "tool_results": [
    {
      "tool_call_id": "tool_abc123",
      "content": "41.57"
    }
  ]
}
```

---

## 1. Bio-Data Tools (Database Interaction)

### `get_anatomical_integrity(muscle_ids: string[])` → `Map<String, double>`
Retrieves the Integrity Score for one or more body segments.
- **Parameters**: `muscle_ids[]` — List of BodySegment IDs (e.g., `["Trapezius_L", "Serratus_Anterior_R"]`)
- **Returns**: key = BodySegment ID, value = IntegrityScore 0.0–1.0
- **Motus intent**: Check healed status before suggesting a movement.

### `log_symptom_event(muscle_id: string, intensity: int, note: string, category: string?)` → `bool`
Records a real-time symptom feedback event.
- **Parameters**: 
  - `muscle_id` — BodySegment ID
  - `intensity` — 1–10 pain/stiffness
  - `note` — Optional natural language
  - `category` — Optional: "Stiffness", "Sharp Pain", "Dull Ache", "Weakness" (auto-detected if omitted)
- **Returns**: `true` if logged successfully

### `fetch_injury_vault(body_region: string)` → `List<InjuryRecord>`
Retrieves injury history for a body region.
- **Parameters**: `body_region` — BodySegment or region (e.g., "L_Ankle", "Thoracic_Spine")
- **Returns**: List with `type` (Acute/Dormant/Chronic), `integrityScore`, `functionalOffsets[]`, `narrative`, `date`, `status`

### `get_equipment_status(item_ids: string[]?)` → `Map<String, EquipmentEntry>`
Retrieves current equipment availability.
- **Parameters**: `item_ids[]` — Optional, specific IDs to query. Omit for all.
- **Returns**: key = equipment ID, value = `{name, modality, anchorPoint, active, currentConfiguration}`

### `update_equipment_status(item_id: string, is_available: bool, configuration: Map?)` → `bool`
Updates equipment availability.
- **Parameters**: `item_id`, `is_available`, `configuration` (e.g., `{"ringHeight": "hip"}`)
- **Returns**: success/failure

### `update_injury_integrity(injury_id: string, new_integrity: double, reason: string?)` → `bool`
Updates IntegrityScore for a specific injury.
- **Parameters**: `injury_id`, `new_integrity` (0.0–1.0), `reason` (optional)
- **Returns**: success/failure

---

## 2. Kinematic Physics Tools (Calculators)

### `calculate_torque_load(bodyWeightKg: double, angleDegrees: double, leverLengthM: double)` → `double`
Computes biomechanical torque: `τ = F · d · sin(θ)`.
- **Parameters**: 
  - `bodyWeightKg` — User body weight
  - `angleDegrees` — Angle between force vector and lever arm (θ)
  - `leverLengthM` — Distance from joint center to center of mass (d)
- **Returns**: Torque in Newton-meters (Nm)
- **Motus intent**: Compare two exercise configurations by torque output. Scale difficulty proportionally.

### `get_progression_step(exercise_id: string, current_integrity: double, direction: string?, drive_level: double?)` → `ExerciseDetails`
Determines the next regression/progression on the Recovery Ladder.
- **Parameters**: 
  - `exercise_id` — Exercise ID from catalog
  - `current_integrity` — IntegrityScore for the relevant BodySegment
  - `direction` — Optional: "regression" or "progression" (auto based on integrity if omitted)
  - `drive_level` — Optional: 0.0–1.0 current Drive setting
- **Returns**: `{name, description, requiredEquipment, ringHeight, durationSecs, notes, scientificRationale, targetMuscles[]}`

### `calculate_safety_margin(injury_integrity: double, acute_symptom_intensity: double, consistency_weight: double?)` → `double`
Computes the SafetyMargin for a body region.
- **Formula**: `S_margin = (Integrity Score × Consistency Weight) / Acute Symptom Intensity`
- **Parameters**: `injury_integrity` (0.0–1.0), `acute_symptom_intensity` (0.0–10.0), `consistency_weight` (default 1.0)
- **Returns**: Low → GenPop logic. High → unlock Elite cues.

### `get_ring_height_for_torque(target_torque_nm: double, bodyWeightKg: double, exercise_id: string)` → `RingHeightPreset`
Maps a target torque to the closest anatomical landmark ring height.
- **Returns**: `{landmark: "sternum", description, estimated_torque_nm, mode: "neural_priming"|"structural_loading"}`

---

## 3. Research Librarian Tools (Vector DB)

### `query_research_library(query: string, lens_type: string, max_results: int?)` → `List<ResearchSnippet>`
Searches the clinical research vector store.
- **Parameters**: 
  - `query` — Search term (e.g., "ring support hold bicep tendonitis")
  - `lens_type` — "SAFETY" or "ELITE"
  - `max_results` — Default 3, max 5
- **Returns**: `{title, authors_link, key_findings, relevance_score}`
- **Motus intent**: Ground suggestions in clinical evidence. Always cite at least one ResearchSnippet.

### `correlate_experience_to_study(log_id: string, study_ids: string[])` → `string`
Links user experience data with relevant research.
- **Parameters**: `log_id` (SymptomLog or TrainingLog entry ID), `study_ids[]` (ResearchNote IDs)
- **Returns**: Analysis summary explaining how the user's experience aligns or deviates from the study

### `add_principle_from_knowledge_source(knowledge_source_id: string, principle_statement: string, key_takeaway: string?)` → `string`
Stores a new Principle from user-supplied knowledge.
- **Returns**: Principle ID

---

## 4. Interface Orchestration (UI)

### `update_3d_view(mode: string?, active_ghost_alpha: double?, transition_style: string?)`
Informs the client about 3D view state changes.
- **Parameters**: 
  - `mode` — "MUSCULOSKELETAL", "SKELETAL", "CARDIOVASCULAR"
  - `active_ghost_alpha` — Default 0.1
  - `transition_style` — "xray_dissolve"
- **Returns**: `void`

### `highlight_kinetic_chain(node_ids: string[], color: string?, opacity: double?, duration_ms: int?)`
Highlights a kinetic chain on the 3D model.
- **Parameters**: `node_ids[]`, `color` (auto from certainty if omitted), `opacity`, `duration_ms`
- **Returns**: `void`

### `request_notification(delay_minutes: int, title: string, body: string, context_uuid: string, deep_link: string)` → `string`
Schedules a proactive notification.
- **Returns**: UUID of the NotificationContext entry

### `register_device_sync_state(device_id: string, last_sync_timestamp: string, direction: string)` → `bool`
Records last sync timestamp for multi-device sync.
- **Parameters**: `direction` — "push", "pull", or "bidirectional"
- **Returns**: success/failure

---

## 5. Lifecycle & Scheduling

### `schedule_priming_checkin(delay_minutes: int, prompt_snippet: string?, drive_level: double?)` → `string`
Schedules a neural priming reminder.
- **Returns**: Scheduled session UUID

### `get_daily_summary(date_iso: string?)` → `DailySummary`
Aggregates neural priming and training data for the day.
- **Returns**: `{totalSessions, totalNeuralPrimings, avgSymptomIntensity, totalTorqueNm, keyInsights[]}`

### `create_hypothesis(target_node: string, linked_nodes: string[], statement: string, initial_certainty: double, sources_cited: string[])` → `string`
Creates a new hypothesis from symptom patterns.
- **Returns**: Hypothesis ID

### `update_hypothesis_certainty(hypothesis_id: string, new_certainty: double, feedback_type: string)` → `bool`
Updates a hypothesis certainty score.
- **Parameters**: `feedback_type` — "positive", "negative", or "neutral"
- **Returns**: success/failure

### `dismiss_kinetic_chain(chain_id: string, reason: string?)` → `bool`
User override: dismisses a kinetic chain.
- **Returns**: success/failure (sets certainty_score to -1.0)

---

## 6. Knowledge Source

### `ingest_knowledge_source(content_type: string, content: string, title: string?, category: string?)` → `string`
Ingests user-provided knowledge (PDFs, text, URLs).
- **Parameters**: `content_type` — "pdf", "text", or "url"
- **Returns**: KnowledgeSource ID

### `export_database_snapshot(format: string)` → `string`
Triggers a database export for backup or sync.
- **Parameters**: `format` — "json" or "sqlite"
- **Returns**: File path to exported snapshot

---

## Error Handling

All tool responses follow:
```json
{
  "tool_call_id": "tool_abc123",
  "content": "success" | "Error: reason",
  "error_code": "TOOL_NOT_FOUND" | "INVALID_PARAMS" | "DATABASE_ERROR" | null
}
```

If a tool fails, the Motus Hub returns the error_code and a human-readable message. The LLM should not retry the same tool — it should formulate an alternative approach or inform the user.

---

**Document version**: 1.0
**Last updated**: 2026-05-11
