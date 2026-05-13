import 'package:drift/drift.dart';

part 'database.g.dart';

/// Application database using Drift (SQLite) with background isolate support.
/// All tables defined here; queries execute on a background isolate via
/// `DatabaseConnection.daemon` (Drift singleton connection pool).
@DriftDatabase(
  tables: [
    ExercisesTable,
    WorkoutLogsTable,
    SymptomLogsTable,
    HypothesesTable,
    SourcesTable,
    PrinciplesTable,
    ResearchNotesTable,
    NotificationContextTable,
    KnowledgeSourcesTable,
    NoiseLogsTable,
    KineticChainEdgesTable,
    BodySegmentsTable,
    DriveSettingsTable,
    DeviceSyncStateTable,
    InjuriesTable,
    EquipmentTable,
  ],
)
class MyoTwinDatabase extends _$MyoTwinDatabase {
  /// Constructs the database instance with a provided query executor.
  MyoTwinDatabase(super.e);

  /// The version of the database schema.
  @override
  int get schemaVersion => 1;

  /// Exposure of the Exercises table definition.
  ExercisesTable get exercises => ExercisesTable();

  /// Exposure of the WorkoutLogs table definition.
  WorkoutLogsTable get workoutLogs => WorkoutLogsTable();

  /// Exposure of the SymptomLogs table definition.
  SymptomLogsTable get symptomLog => SymptomLogsTable();

  /// Exposure of the Hypotheses table definition.
  HypothesesTable get hypothesis => HypothesesTable();

  /// Exposure of the Sources table definition.
  SourcesTable get source => SourcesTable();

  /// Exposure of the Principles table definition.
  PrinciplesTable get principle => PrinciplesTable();

  /// Exposure of the ResearchNotes table definition.
  ResearchNotesTable get researchNote => ResearchNotesTable();

  /// Exposure of the NotificationContext table definition.
  NotificationContextTable get notificationContext => NotificationContextTable();

  /// Exposure of the KnowledgeSources table definition.
  KnowledgeSourcesTable get knowledgeSource => KnowledgeSourcesTable();

  /// Exposure of the NoiseLogs table definition.
  NoiseLogsTable get noiseLog => NoiseLogsTable();

  /// Exposure of the KineticChainEdges table definition.
  KineticChainEdgesTable get kineticChainEdge => KineticChainEdgesTable();

  /// Exposure of the BodySegments table definition.
  BodySegmentsTable get bodySegment => BodySegmentsTable();

  /// Exposure of the DriveSettings table definition.
  DriveSettingsTable get driveSettings => DriveSettingsTable();

  /// Exposure of the DeviceSyncState table definition.
  DeviceSyncStateTable get deviceSyncState => DeviceSyncStateTable();

  /// Exposure of the Injuries table definition.
  InjuriesTable get injury => InjuriesTable();

  /// Exposure of the Equipment table definition.
  EquipmentTable get equipment => EquipmentTable();
}





// ====== TABLE DEFINITIONS ======

/// Exercises table: exercise definitions and metadata.
class ExercisesTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Exercise display name.
  TextColumn get name => text()();

  /// Detailed description of the exercise form and execution.
  TextColumn get description => text().nullable()();

  /// Exercise category (e.g. cardio, strength, HIIT).
  TextColumn get category => text()();

  /// Comma-separated list of target muscle groups.
  TextColumn get targetMuscles => text()();

  /// Equipment required to perform the exercise.
  TextColumn get requiredEquipment => text().nullable()();

  /// Height of the ring in meters, used for biomechanical calculations.
  RealColumn get ringHeight => real().nullable()();

  /// Duration of the exercise in seconds.
  IntColumn get durationSecs => integer().nullable()();

  /// Scientific rationale supporting the exercise design.
  TextColumn get scientificRationale => text().nullable()();

  /// Notes about equipment configuration and usage.
  TextColumn get equipmentNotes => text().nullable()();

  /// Timestamp when the exercise record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the exercise record was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// WorkoutLogs table: logs of completed workouts and sets.
class WorkoutLogsTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Foreign key reference to the linked exercise.
  IntColumn get exerciseId => integer().references(ExercisesTable, #id)();

  /// Total volume of the workout (e.g. reps * weight).
  IntColumn get volume => integer()();

  /// Workout duration in seconds.
  IntColumn get durationSecs => integer().nullable()();

  /// Additional notes about the workout session.
  TextColumn get notes => text().nullable()();

  /// Intensity score of the workout session.
  RealColumn get intensity => real().nullable()();

  /// Source type of the log (e.g. manual, device).
  TextColumn get sourceType => text()();

  /// Date the workout was logged.
  DateTimeColumn get logDate => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the log record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// SymptomLog table: user-reported symptoms linked to body segments.
class SymptomLogsTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// ID of the affected muscle body segment.
  TextColumn get muscleId => text()();

  /// Severity score of the reported symptom.
  IntColumn get intensity => integer()();

  /// Optional user note describing the symptom.
  TextColumn get note => text().nullable()();

  /// Symptom category (e.g. pain, fatigue, stiffness).
  TextColumn get category => text().nullable()();

  /// Source type of the symptom log (e.g. manual, detected).
  TextColumn get sourceType => text()();

  /// Date the symptom was logged.
  DateTimeColumn get logDate => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the log record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Hypothesis table: active, proven, or refuted hypotheses with certainty scores.
class HypothesesTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Target body segment node the hypothesis concerns.
  TextColumn get targetNode => text()();

  /// Comma-separated list of nodes related to the hypothesis.
  TextColumn get linkedNodes => text()();

  /// Human-readable statement of the hypothesis.
  TextColumn get statement => text()();

  /// Numerical certainty score for the hypothesis.
  RealColumn get certaintyScore => real()();

  /// Status of the hypothesis (e.g. active, proven, refuted).
  TextColumn get status => text()();

  /// Comma-separated list of sources cited in support.
  TextColumn get sourcesCited => text().nullable()();

  /// Scientific rationale supporting the hypothesis.
  TextColumn get scientificRationale => text().nullable()();

  /// Timestamp when the hypothesis record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the hypothesis record was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Source table: cited research material.
class SourcesTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Title of the cited research or article.
  TextColumn get title => text()();

  /// Author(s) of the source material.
  TextColumn get authors => text().nullable()();

  /// URL link to the source document.
  TextColumn get link => text().nullable()();

  /// Key takeaway or finding from the source.
  TextColumn get keyTakeaway => text().nullable()();

  /// How the source relates to the associated hypothesis.
  TextColumn get relationshipToHypothesis => text().nullable()();

  /// Timestamp when the source record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Principle table: ingested biomechanical rules.
class PrinciplesTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Display name of the biomechanical principle.
  TextColumn get name => text()();

  /// The principle statement or rule.
  TextColumn get statement => text()();

  /// Category of the principle (e.g. biomechanics, physiology).
  TextColumn get category => text()();

  /// Foreign key reference to the originating knowledge source.
  TextColumn get knowledgeSourceId => text().nullable()();

  /// Timestamp when the principle record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// ResearchNote table: background auditor findings.
class ResearchNotesTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Content of the research note.
  TextColumn get content => text()();

  /// Type or classification of the research note.
  TextColumn get type => text()();

  /// Foreign key reference to an optional related hypothesis.
  TextColumn get relatedHypothesisId => text().nullable()();

  /// Certainty score for the research finding.
  RealColumn get certaintyScore => real().nullable()();

  /// Timestamp when the note record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// NotificationContext table: notification payloads with deep-link UUIDs.
class NotificationContextTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Title text for the notification.
  TextColumn get title => text()();

  /// Body text content of the notification.
  TextColumn get body => text()();

  /// Deep-link UUID for navigation when notification is tapped.
  TextColumn get deepLink => text()();

  /// Delay minutes before the notification is dispatched.
  IntColumn get delayMinutes => integer()();

  /// Context UUID for correlation with other records.
  TextColumn get contextUuid => text()();

  /// Notification delivery status (e.g. pending, delivered).
  TextColumn get status => text().clientDefault(() => 'pending')();

  /// Timestamp when the notification record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Scheduled delivery timestamp for the notification.
  DateTimeColumn get scheduledAt => dateTime().nullable()();
}

/// KnowledgeSource table: ingested user data (PDFs, text, URLs).
class KnowledgeSourcesTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Content type of the ingested source (e.g. pdf, text, url).
  TextColumn get contentType => text()();

  /// Full content of the ingested source material.
  TextColumn get content => text()();

  /// Optional human-readable title for the source.
  TextColumn get title => text().nullable()();

  /// Category classification of the knowledge source.
  TextColumn get category => text().nullable()();

  /// Timestamp when the source record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// NoiseLog table: environmental/mental stress logs.
class NoiseLogsTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Type of noise or stressor (e.g. environmental, mental).
  TextColumn get type => text()();

  /// Intensity level of the noise/stressor.
  IntColumn get intensity => integer().nullable()();

  /// Optional note describing the noise event.
  TextColumn get note => text().nullable()();

  /// Source type of the noise log (e.g. sensor, manual).
  TextColumn get sourceType => text()();

  /// Date the noise event was logged.
  DateTimeColumn get logDate => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the log record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// KineticChainEdge table: weighted edges between body segment nodes.
class KineticChainEdgesTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Source body segment node of the edge.
  TextColumn get sourceNode => text()();

  /// Target body segment node of the edge.
  TextColumn get targetNode => text()();

  /// Weight of the kinetic chain edge.
  RealColumn get weight => real()();

  /// Measured correlation strength between the connected nodes.
  RealColumn get correlationStrength => real()();

  /// Certainty score for the edge relationship.
  RealColumn get certaintyScore => real()();

  /// Type of the kinetic chain edge.
  TextColumn get edgeType => text()();

  /// Timestamp when the edge record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the edge record was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// BodySegment table: nodes in the kinetic graph.
class BodySegmentsTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Display name of the body segment.
  TextColumn get name => text()();

  /// Anatomical region of the body segment.
  TextColumn get region => text()();

  /// Description of the body segment and its role.
  TextColumn get description => text().nullable()();

  /// Structural integrity score (defaults to 1.0).
  RealColumn get integrityScore => real().clientDefault(() => 1.0)();

  /// Heat index for the body segment.
  TextColumn get heatIndex => text().nullable()();

  /// Timestamp when the segment record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the segment record was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// DriveSettings table: global and per-node intensity/drive values.
class DriveSettingsTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Name of the intensity/drive setting.
  TextColumn get settingName => text()();

  /// Numerical value of the setting.
  RealColumn get value => real()();

  /// Scope of the setting (e.g. global, per-node).
  TextColumn get scope => text()();

  /// Node ID the setting applies to (nullable for global settings).
  TextColumn get nodeId => text().nullable()();

  /// Timestamp when the setting record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the setting record was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// DeviceSyncState table: last-sync timestamps for multi-device.
class DeviceSyncStateTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Unique device identifier for sync tracking.
  TextColumn get deviceId => text()();

  /// Last sync timestamp for this device.
  DateTimeColumn get lastSyncTimestamp => dateTime()();

  /// Sync direction (e.g. upload, download).
  TextColumn get direction => text()();

  /// Timestamp when the sync state record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the sync state record was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Injury table: injuries with integrity scores, functional offsets, and narrative.
class InjuriesTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Body region affected by the injury.
  TextColumn get bodyRegion => text()();

  /// Injury type classification.
  TextColumn get type => text()();

  /// Structural integrity score (defaults to 1.0).
  RealColumn get integrityScore => real().clientDefault(() => 1.0)();

  /// Functional offsets caused by the injury.
  TextColumn get functionalOffsets => text().nullable()();

  /// Narrative description of the injury.
  TextColumn get narrative => text().nullable()();

  /// Current status of the injury (e.g. active, healed).
  TextColumn get status => text()();

  /// Date the injury occurred.
  DateTimeColumn get date => dateTime()();

  /// Timestamp when the injury record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the injury record was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Equipment table: registered equipment with availability status.
class EquipmentTable extends Table {
  /// Auto-incrementing primary key identifier.
  IntColumn get id => integer().autoIncrement()();

  /// Display name of the equipment.
  TextColumn get name => text()();

  /// Equipment modality type.
  TextColumn get modality => text()();

  /// Anchor point where the equipment is positioned.
  TextColumn get anchorPoint => text().nullable()();

  /// Whether the equipment is currently active (defaults to true).
  BoolColumn get active => boolean().clientDefault(() => true)();

  /// Current configuration state of the equipment.
  TextColumn get currentConfiguration => text().nullable()();

  /// Timestamp when the equipment record was created.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when the equipment record was last updated.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
