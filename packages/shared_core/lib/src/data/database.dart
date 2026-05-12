import 'package:drift/drift.dart';

/// Application database using Drift (SQLite) with background isolate support.
/// All tables defined here; queries execute on a background isolate via
// ignore: comment_references
/// [DatabaseConnection.daemon].
abstract class MyoTwinDatabase extends DriftDatabase {
  MyoTwinDatabase();

  ExercisesTable get exercises => ExercisesTable();
  WorkoutLogsTable get workoutLogs => WorkoutLogsTable();
  SymptomLogsTable get symptomLog => SymptomLogsTable();
  HypothesesTable get hypothesis => HypothesesTable();
  SourcesTable get source => SourcesTable();
  PrinciplesTable get principle => PrinciplesTable();
  ResearchNotesTable get researchNote => ResearchNotesTable();
  NotificationContextTable get notificationContext => NotificationContextTable();
  KnowledgeSourcesTable get knowledgeSource => KnowledgeSourcesTable();
  NoiseLogsTable get noiseLog => NoiseLogsTable();
  KineticChainEdgesTable get kineticChainEdge => KineticChainEdgesTable();
  BodySegmentsTable get bodySegment => BodySegmentsTable();
  DriveSettingsTable get driveSettings => DriveSettingsTable();
  DeviceSyncStateTable get deviceSyncState => DeviceSyncStateTable();
  InjuriesTable get injury => InjuriesTable();
  EquipmentTable get equipment => EquipmentTable();
}

// ====== TABLE DEFINITIONS ======

/// Exercises table: exercise definitions and metadata.
class ExercisesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text()();
  TextColumn get targetMuscles => text()();
  TextColumn get requiredEquipment => text().nullable()();
  RealColumn get ringHeight => real().nullable()();
  IntColumn get durationSecs => integer().nullable()();
  TextColumn get scientificRationale => text().nullable()();
  TextColumn get equipmentNotes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// WorkoutLogs table: logs of completed workouts and sets.
class WorkoutLogsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exerciseId => integer().references(ExercisesTable, #id)();
  IntColumn get volume => integer()();
  IntColumn get durationSecs => integer().nullable()();
  TextColumn get notes => text().nullable()();
  RealColumn get intensity => real().nullable()();
  TextColumn get sourceType => text()();
  DateTimeColumn get logDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// SymptomLog table: user-reported symptoms linked to body segments.
class SymptomLogsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get muscleId => text()();
  IntColumn get intensity => integer()();
  TextColumn get note => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get sourceType => text()();
  DateTimeColumn get logDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Hypothesis table: active, proven, or refuted hypotheses with certainty scores.
class HypothesesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get targetNode => text()();
  TextColumn get linkedNodes => text()();
  TextColumn get statement => text()();
  RealColumn get certaintyScore => real()();
  TextColumn get status => text()();
  TextColumn get sourcesCited => text().nullable()();
  TextColumn get scientificRationale => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Source table: cited research material.
class SourcesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get authors => text().nullable()();
  TextColumn get link => text().nullable()();
  TextColumn get keyTakeaway => text().nullable()();
  TextColumn get relationshipToHypothesis => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Principle table: ingested biomechanical rules.
class PrinciplesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get statement => text()();
  TextColumn get category => text()();
  TextColumn get knowledgeSourceId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// ResearchNote table: background auditor findings.
class ResearchNotesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text()();
  TextColumn get type => text()();
  TextColumn get relatedHypothesisId => text().nullable()();
  RealColumn get certaintyScore => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// NotificationContext table: notification payloads with deep-link UUIDs.
class NotificationContextTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get deepLink => text()();
  IntColumn get delayMinutes => integer()();
  TextColumn get contextUuid => text()();
  TextColumn get status => text().clientDefault(() => 'pending')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get scheduledAt => dateTime().nullable()();
}

/// KnowledgeSource table: ingested user data (PDFs, text, URLs).
class KnowledgeSourcesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get contentType => text()();
  TextColumn get content => text()();
  TextColumn get title => text().nullable()();
  TextColumn get category => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// NoiseLog table: environmental/mental stress logs.
class NoiseLogsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  IntColumn get intensity => integer().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get sourceType => text()();
  DateTimeColumn get logDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// KineticChainEdge table: weighted edges between body segment nodes.
class KineticChainEdgesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceNode => text()();
  TextColumn get targetNode => text()();
  RealColumn get weight => real()();
  RealColumn get correlationStrength => real()();
  RealColumn get certaintyScore => real()();
  TextColumn get edgeType => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// BodySegment table: nodes in the kinetic graph.
class BodySegmentsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get region => text()();
  TextColumn get description => text().nullable()();
  RealColumn get integrityScore => real().clientDefault(() => 1.0)();
  TextColumn get heatIndex => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// DriveSettings table: global and per-node intensity/drive values.
class DriveSettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get settingName => text()();
  RealColumn get value => real()();
  TextColumn get scope => text()();
  TextColumn get nodeId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// DeviceSyncState table: last-sync timestamps for multi-device.
class DeviceSyncStateTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviceId => text()();
  DateTimeColumn get lastSyncTimestamp => dateTime()();
  TextColumn get direction => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Injury table: injuries with integrity scores, functional offsets, and narrative.
class InjuriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get bodyRegion => text()();
  TextColumn get type => text()();
  RealColumn get integrityScore => real().clientDefault(() => 1.0)();
  TextColumn get functionalOffsets => text().nullable()();
  TextColumn get narrative => text().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Equipment table: registered equipment with availability status.
class EquipmentTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get modality => text()();
  TextColumn get anchorPoint => text().nullable()();
  BoolColumn get active => boolean().clientDefault(() => true)();
  TextColumn get currentConfiguration => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
