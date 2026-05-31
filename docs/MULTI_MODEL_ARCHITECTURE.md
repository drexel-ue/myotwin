# MyoTwin — Multi-Model LLM Architecture

> Strategy for using multiple GGUF models via llamadart (llama.cpp) on client and server, with domain-specific LoRA adapters for fitness coaching, medical advisory, and biomechanics expertise.

---

## Why Multiple Models?

A single general-purpose model tries to be everything (fitness coach, medical advisor, biomechanics expert) but excels at none. A **multi-model system** with **LoRA adapters** gives each domain its own trained behavior, selected dynamically at runtime.

```
User input → Intent Classifier → Route to specialized model/adapter
                                      ↓
                              Formatted prompt with domain context
                                      ↓
                              Generate response
                                      ↓
                              Reset adapter, await next input
```

---

## Model Tiers

### Tier 1: Client-Side (On-Device, iOS)

**Base Model: Gemma 4 E2B** — 2.1B parameters, Q4_K_M quantization

| Metric | Value | Notes |
|---|---|---|
| Parameters | ~2.1 Billion | Effective params during inference |
| Context Window | 8K tokens | Sufficient for conversation + tool calls |
| RAM Footprint | ~250–500 MB | iPhone-optimized (Neural Engine), ~2–5 GB on CPU |
| Inference Speed | ~11 tok/s | On iPhone (CoreML via llamadart) |
| Multimodal | ❌ Text-only | Vision/audio dropped for size |
| File Size | ~1.3 GB | GGUF Q4_K_M from HuggingFace |

**HuggingFace Source (via `hf://` protocol):**
```
hf://ggml-org/gemma-4-E2B-it-GGUF:gemma-4-E2B-it-Q4_K_M.gguf
hf://unsloth/gemma-4-E2B-it-GGUF:gemma-4-E2B-it-Q4_K_M.gguf
hf://bartowski/google_gemma-4-E2B-it-GGUF:gemma-4-E2B-it-Q4_K_M.gguf
```

**Why E2B over E4B on iOS:**

| Factor | E2B (~2.1B) | E4B (~4.5B) | Decision |
|---|---|---|---|
| RAM | ~250 MB (Neural Engine) | ~5 GB (Q4 quantized) | E2B ✅ |
| Context | 8K tokens | 128K tokens | E2B ✅ (adequate) |
| Multimodal | ❌ | ✅ | ❌ Not needed for V1 |
| Speed on iPhone | ~11 tok/s | ~4-6 tok/s | E2B ✅ |
| App bundle size | ~1.3 GB | ~2.5 GB | E2B ✅ |

**Trade-off:** E2B drops "Thinking Mode" and multimodal support. Acceptable because:
1. Tool calling provides structured capability instead of free-form reasoning
2. Server Motus handles deep research and multimodal analysis
3. E4B is reserved for desktop/macOS where memory is less constrained

---

### Tier 2: Server-Side (GPU, Deep Research)

**Base Models: Multiple full models on Ollama**

| Model | Purpose | GPU RAM |
|---|---|---|
| Llama 3.3 70B | Deep research, hypothesis formulation, clinical review | ~40 GB (BF16) |
| BioMed-Llama | Clinical literature analysis, injury pathology | ~14 GB (Q4) |
| SportsSci-Mixtral | Sports science, training programming, biomechanics | ~13 GB (Q4) |
| Gemma 4 E4B | Desktop fallback, multimodal queries (vision, audio) | ~8 GB (Q4) |

**Sync Flow:**
```
Client Motus (E2B, 2.1B params)
  ↑↓ reports patterns, asks research questions, syncs knowledge graph
Server Motus (Ollama, multiple full models 7-70B params)
  ↑↓ conducts deep research
  ↑↓ produces ResearchNotes, Principles, PatternReports
  ↑↓ syncs updates to client locally
Client Motus enriches local knowledge graph
```

---

## LoRA Adapters: Domain Specialization

LoRA (Low-Rank Adaptation) lets you fine-tune a base model without retraining it. The adapter weights are tiny (~150 MB) and loaded **dynamically at runtime** alongside the base model.

### Architecture

```
One base model in memory (~1.3 GB)
  + FitnessCoachAdapter  (~150 MB)   ← active when context is fitness-related
  + MedicalAdvisorAdapter (~150 MB)  ← active when context is injury/medical
  + BiomechanicsExpertAdapter (~150 MB) ← active when context is biomechanics
```

**Not** three models in memory. **One base model + one small adapter per call.**

### How It Works

```dart
import 'package:llamadart/llamadart.dart';

// Load base model once
final engine = LlamaEngine(LlamaBackend());
await engine.loadModel('hf://ggml-org/gemma-4-E2B-it-GGUF:gemma-4-E2B-it-Q4_K_M.gguf');

// Apply adapter before generating domain-specific response
final adapter = await engine.loadLoRAAdapter(
  path: 'fitness_coach_adapter.gguf',
  scale: 1.0,  // Adaptive scaling
);

final context = ChatSession(
  engine,
  systemPrompt: 'You are a biomechanical fitness coach specializing in ring training and mobility.',
);

// Generate response — adapter influences style, prioritization, and domain knowledge
await for (final chunk in context.create([
  LlamaTextContent('How does this shoulder symptom affect my progressions?')
], loraAdapters: [adapter])) {
  stdout.write(chunk.choices.first.delta.content ?? '');
}

// Reset for next call
// Adapter is automatically swapped on next generation call
```

### Adapters Needed

| Adapter | Size | Fine-tuned On | Effect |
|---|---|---|---|
| `fitness_coach_adapter.gguf` | ~100–150 MB | Fitness Q&A, exercise programming, progression logic, recovery protocols | Pushes volume, progressive overload, recovery optimization |
| `medical_advisor_adapter.gguf` | ~100–150 MB | Medical literature, injury pathology, rehabilitation protocols, clinical reasoning | Cautious, evidence-based, safety-first, clinical terminology |
| `biomechanics_expert_adapter.gguf` | ~100–150 MB | Torque/leverage calculations, joint-by-joint approach, kinetic chains, force vectors | Precise, math-heavy, biomechanical terminology, physics explanations |

---

## Intent Classification: Routing to the Right Model

Before generating a response, Motus classifies the user's intent to select the appropriate adapter:

```dart
enum IntentDomain {
  fitness,          // Exercise programming, training advice, recovery
  medical,          // Injury pathology, rehabilitation, clinical guidance
  biomechanics,     // Torque, leverage, muscle mechanics, joint function
  knowledge,        // Research questions, principle queries, evidence lookup
  general,          // General chat, tool calls, surface assembly
}

IntentDomain classifyIntent(String message) {
  // Lightweight classification call on base model (no adapter)
  // ~50 tokens → ~5ms → returns IntentDomain enum
  final prompt = _classificationTemplate(message);
  final result = await engine.generate(prompt, maxTokens: 10);
  return _parseIntent(result);
}
```

**Classification Prompt:**
```
You are an intent classifier for MyoTwin, a biomechanical coaching assistant.
Classify this message into one of: fitness, medical, biomechanics, knowledge, general.

Rules:
- "fitness": Exercise programming, training, recovery, volume, progression
- "medical": Injury pathology, rehabilitation, symptoms, clinical guidance
- "biomechanics": Muscle mechanics, joint function, torque, leverage, kinetic chains
- "knowledge": Research questions, evidence lookup, clinical studies
- "general": Anything else

Message: "$message"
Respond with ONLY the domain name.
```

- **Performance:** 50 → 10 token generation, ~5ms on E2B. Negligible overhead.

---

## Unstructured Data Shaping & GenUI

Motus is not just a conversationalist; it is a **Data Architect**. The agent is responsible for:

1.  **Shaping Metadata**: When Motus identifies new biomechanical patterns, it stores them in unstructured `JSONB` blobs wrapped by **Dart Extension Types**. This allows the knowledge graph to evolve semantically without database schema changes.
2.  **Defining UI Schemas**: Instead of the app having rigid screens, Motus emits GenUI payloads (`A2uiMessage`). The agent decides which widgets (e.g., `InjuryDetailCard`, `RegressionLadder`) are necessary based on the current context and populates their data schemas at runtime.

This approach ensures the system remains highly adaptive and can support new biomechanical insights or UI components simply by updating the agent's instructions and the widget catalog.

---

## Full Request Flow

```
User says: "My left shoulder clicked during the ring support hold. What should I do?"

1. Intent Classification
   → Classification result: IntentDomain.medical

2. Adapter Selection
   → Active adapter: medical_advisor_adapter.gguf

3. Prompt Construction
   → Base model prompt:
     System: "You are a medical advisor in MyoTwin. Focus on injury pathology..."
     Context: [symptom history, injury vault, current state]
     User: "left shoulder clicked during ring support hold"

4. Generation
   → ~150 tok/s on iPhone (Neural Engine)
   → Response includes: symptom tagging, caution level, suggested exercises

5. Adapter Reset
   → Reset to base model for next call
   → Tool calls executed (e.g., log_symptom_event, update_equipment_status)

6. Surface Assembly (genui)
   → Motus generates A2uiMessage with intent_record
   → Surface rendered with: InjuryDetailCard, RegressionLadder, SymptomInput
```

---

## Knowledge Graph Integration

The knowledge graph connects models and adapters through **Principles**, **ResearchNotes**, and **Hypotheses**:

```
┌─────────────────────────────────────────────────────────────┐
│                     Knowledge Graph                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Goal: "Left Shoulder Recovery"                            │
│  ├── Hypothesis: "Rotator cuff tendinopathy"              │
│  │   ├── certainty: 0.7                                   │
│  │   └── Evidence:                                        │
│  │       └── ResearchNote: "Journal of Orthopedics..."    │
│  │                                                      │
│  ├── IntentRecord: "Session Feedback"                     │
│  │   ├── adapter_used: medical_advisor_adapter            │
│  │   ├── user_accepted: false                            │
│  │   └── feedback: "Didn't help, tried stretching..."    │
│  │                                                      │
│  └── ProgressRecord:                                      │
│       ├── metric: ROM (shoulder external rotation)       │
│       ├── day_1: 75°                                    │
│       ├── day_14: 85°                                   │
│       └── trend: +10° (improving)                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Memory & Performance Budget (iOS)

| Component | RAM | Notes |
|---|---|---|
| iOS System | — | ~2 GB reserved |
| Flutter Runtime + UI | ~500 MB | Standard Flutter app |
| 3D Scene (GLB + Shaders) | ~300–500 MB | Body twin, textures, state |
| **Gemma 4 E2B** | **~250–500 MB** | Neural Engine / CPU |
| LoRA Adapters | **~150–450 MB** | One at a time, swapped per call |
| Database (Drift) | ~50–100 MB | SQLite in-memory + disk |
| **Total** | **~500–1200 MB** | Well within iPhone 4 GB budget |

**Total app footprint: ~2–3 GB peak** (iOS system manages memory pressure).

---

## Model Sourcing & Caching

llamadart supports downloading models directly from HuggingFace via `hf://` URLs with automatic caching:

```dart
// First run: downloads model to app's cache directory
await engine.loadModelSource(
  ModelSource.parse('hf://ggml-org/gemma-4-E2B-it-GGUF:gemma-4-E2B-it-Q4_K_M.gguf'),
  options: ModelLoadOptions(
    cachePolicy: ModelCachePolicy.preferCached,
    cacheDirectory: '/path/to/app/model-cache',
  ),
  onProgress: (progress) {
    // Show download progress to user
  },
);
```

**LoRA adapters** (smaller, ~150 MB each) can be bundled with the app or downloaded separately and cached on first use.

**HuggingFace Collections for reference:**
- `unsloth/gemma-4-E2B-it-GGUF` — Quantized variants, community-optimized
- `bartowski/google_gemma-4-E2B-it-GGUF` — Various quantization levels
- `ggml-org/gemma-4-E2B-it-GGUF` — Official GGUF conversions

---

## Future Evolution

### Phase 2: More Adapters
- `recovery_forecast_adapter.gguf` — Predictive, trend analysis, recovery patterns
- `equipment_specialist_adapter.gguf` — Equipment configuration, leverage optimization

### Phase 3: Server-Side Specialization
- Full fine-tuned medical model on server (not LoRA)
- Custom sports science model with biomechanics training

### Phase 4: Mobile-Only Inference
- If iOS devices improve to support E4B natively (~5 GB RAM), swap E2B → E4B at no LoRA cost
- E4B's 128K context enables full session memory on-device

---

**Document version**: 1.0
**Last updated**: 2026-05-14
