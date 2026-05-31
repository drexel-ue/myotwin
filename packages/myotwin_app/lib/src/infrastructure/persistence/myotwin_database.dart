import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:myotwin_app/src/infrastructure/persistence/converters.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_core/shared_core.dart';

part 'myotwin_database.g.dart';

/// The relational anchor for user goals.
class Goals extends Table {
  /// Unique identifier for this goal.
  TextColumn get id => text()();

  /// Human-readable label (e.g., "Left Shoulder Recovery").
  TextColumn get label => text()();

  /// Current lifecycle state.
  TextColumn get status =>
      text().map(const EnumNameConverter(GoalStatus.values))();

  /// When the goal was first established.
  DateTimeColumn get createdAt => dateTime()();

  /// When the goal was last updated.
  DateTimeColumn get updatedAt => dateTime().nullable()();

  /// JSONB metadata wrapped in [GoalMetadata] extension type.
  TextColumn get metadata => text().map(const GoalMetadataConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

/// The relational anchor for Motus decisions, notifications, and chat messages.
class IntentRecords extends Table {
  /// Unique identifier for this intent.
  TextColumn get id => text()();

  /// The parent goal this intent serves.
  TextColumn get goalId => text().references(Goals, #id)();

  /// The type of interaction (e.g., chat, notification).
  TextColumn get type =>
      text().map(const EnumNameConverter(IntentType.values))();

  /// When the intent was recorded.
  DateTimeColumn get createdAt => dateTime()();

  /// When the intent is eligible for delivery.
  DateTimeColumn get scheduledTime => dateTime()();

  /// When the intent was presented to the user.
  DateTimeColumn get deliveredAt => dateTime().nullable()();

  /// Observed user engagement score (0.0 to 1.0).
  RealColumn get userEngagementScore => real().nullable()();

  /// The internal reasoning or summary for this decision.
  TextColumn get reason => text()();

  /// JSONB GenUI payload wrapped in [IntentPayload] extension type.
  TextColumn get payload => text().map(const IntentPayloadConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

/// The main local database for MyoTwin.
@DriftDatabase(tables: [Goals, IntentRecords])
class MyoTwinDatabase extends _$MyoTwinDatabase {
  /// Creates a [MyoTwinDatabase].
  MyoTwinDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'myotwin.sqlite'));
    return NativeDatabase(file);
  });
}
