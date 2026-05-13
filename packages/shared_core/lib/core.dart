/// Barrel library for shared_core — the nervous system of MyoTwin.
///
/// Re-exports all public APIs from the pure Dart domain layer:
///
/// * **Entities** — domain models for body segments, exercises, workouts,
///   equipment, injuries, hypotheses, symptoms, and more.
/// * **Enums** — value types for body segments, equipment, movements,
///   hypothesis status, ring height, and knowledge sources.
/// * **Repositories** — interfaces for all domain aggregates, defining the
///   contract between the domain layer and persistence implementations.
/// * **Services** — biomechanical calculators (torque, safety margins,
///   progression ladders) and database export utilities.
/// * **Data** — the Drift-based database schema and access layer.
/// * **Interfaces** — cross-cutting contracts such as the MotusCoordinator.
///
/// The domain layer has zero Flutter dependencies.
library;

export 'src/domain/entities/body_segment_entity.dart';
export 'src/domain/entities/device_sync_state_entity.dart';
export 'src/domain/entities/drive_settings_entity.dart';
export 'src/domain/entities/equipment_entity.dart';
export 'src/domain/entities/exercise_entity.dart';
export 'src/domain/entities/hypothesis_entity.dart';
export 'src/domain/entities/injury_entity.dart';
export 'src/domain/entities/kinetic_chain_edge_entity.dart';
export 'src/domain/entities/knowledge_source_entity.dart';
export 'src/domain/entities/noise_log_entity.dart';
export 'src/domain/entities/notification_context_entity.dart';
export 'src/domain/entities/principle_entity.dart';
export 'src/domain/entities/research_note_entity.dart';
export 'src/domain/entities/source_entity.dart';
export 'src/domain/entities/symptom_entity.dart';
export 'src/domain/entities/workout_log_entity.dart';
export 'src/domain/enums/body_segment_enum.dart';
export 'src/domain/enums/equipment_type.dart';
export 'src/domain/enums/hypothesis_status.dart';
export 'src/domain/enums/movement_mode.dart';
export 'src/domain/enums/ring_height.dart';
export 'src/domain/enums/source_type.dart';
export 'src/domain/interfaces/database_isolate.dart';
export 'src/domain/interfaces/motus_coordinator.dart';
export 'src/domain/repositories/body_segment_repository.dart';
export 'src/domain/repositories/device_sync_state_repository.dart';
export 'src/domain/repositories/drive_settings_repository.dart';
export 'src/domain/repositories/equipment_repository.dart';
export 'src/domain/repositories/exercise_repository.dart';
export 'src/domain/repositories/hypothesis_repository.dart';
export 'src/domain/repositories/injury_repository.dart';
export 'src/domain/repositories/kinetic_chain_edge_repository.dart';
export 'src/domain/repositories/knowledge_source_repository.dart';
export 'src/domain/repositories/noise_log_repository.dart';
export 'src/domain/repositories/notification_context_repository.dart';
export 'src/domain/repositories/principle_repository.dart';
export 'src/domain/repositories/research_note_repository.dart';
export 'src/domain/repositories/source_repository.dart';
export 'src/domain/repositories/symptom_log_repository.dart';
export 'src/domain/repositories/workout_log_repository.dart';
export 'src/domain/services/database_export_service.dart';
export 'src/domain/services/progression_ladder.dart';
export 'src/domain/services/safety_margin_calculator.dart';
export 'src/domain/services/torque_calculator.dart';
