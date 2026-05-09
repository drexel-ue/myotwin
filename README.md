# MyOTwin

A privacy-first, biomechanical research & coaching app built entirely offline with Flutter, Drift (SQLite), and local LLMs (Gemma).

---

> **This project is in initial planning phase. No code has been written yet.**

## Quick Start (when code exists)

```bash
# Install melos
dart pub global activate melos

# Bootstrap the monorepo
melos bootstrap

# Run tests
melos run test
```

## Project Structure

See `docs/product_spec.md` for the full architecture specification.

| Package | Purpose |
|---|---|
| `myotwan_core` | Domain entities, value types, repository interfaces |
| `myotwan_db` | Drift DAOs, schema, export service |
| `myotwan_llm` | LLM orchestration (mediapipe, Ollama, prompts) |
| `myotwan_features/*/` | Feature libraries (one per BLoC group) |
| `myotwan_app` | Presentation: widgets, navigation, FAB, shell |
| `myotwan_test_support` | Shared mocks and fakes |

## Governance Documents

| Document | Purpose |
|---|---|
| `docs/product_spec.md` | Full product specification |
| `docs/agents.md` | Agent instructions and constraints |
| `docs/architecture_rules.md` | Performance guardrails and anti-patterns |
| `docs/project_state.md` | Progress tracking, task breakdown, session handoffs |
| `docs/hurdle_tracker.md` | Problems, solutions, and logged decisions |
| `system_health.md` | Architecture drift and dependency alerts |
| `docs/session_handoff_template.md` | Templates for session handoff entries |

## Agent Instructions

**Before writing any code, read these files:**

1. `docs/product_spec.md` — what to build
2. `docs/agents.md` — how to build it (constraints, prompt templates, architecture rules)
3. `docs/project_state.md` — current progress and next task
4. `docs/hurdle_tracker.md` — known problems and decisions on past choices

**At end of session, update these files:**

1. `docs/project_state.md` — new task status, new handoff entry
2. `docs/hurdle_tracker.md` — new hurdles or resolved issues
3. `system_health.md` — any architectural drift or deprecation notices

---

**Document version**: 1.0
**Last updated**: 2026-05-09
