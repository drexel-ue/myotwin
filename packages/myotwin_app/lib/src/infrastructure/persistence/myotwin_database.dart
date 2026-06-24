import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:myotwin_app/src/infrastructure/persistence/converters.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_core/shared_core.dart';

part 'myotwin_database.g.dart';

/// Generic converter for Enums using their name property.
class MyoEnumNameConverter<T extends Enum> extends TypeConverter<T, String>
    with JsonTypeConverter2<T, String, String> {
  /// Creates a [MyoEnumNameConverter].
  const MyoEnumNameConverter(this.values);

  /// All possible values of the enum.
  final List<T> values;

  @override
  T fromSql(String fromDb) => values.byName(fromDb);

  @override
  String toSql(T value) => value.name;

  @override
  T fromJson(String json) => fromSql(json);

  @override
  String toJson(T value) => toSql(value);
}

/// Converts a list of strings to a comma-separated string for SQLite.
class StringListConverter extends TypeConverter<List<String>, String>
    with JsonTypeConverter2<List<String>, String, List<dynamic>> {
  /// Creates a [StringListConverter].
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return fromDb.split(',');
  }

  @override
  String toSql(List<String> value) {
    return value.join(',');
  }

  @override
  List<String> fromJson(List<dynamic> json) => json.cast<String>();

  @override
  List<dynamic> toJson(List<String> value) => value;
}

/// The relational anchor for user goals.
class Goals extends Table {
  /// Unique identifier for this goal.
  TextColumn get id => text()();

  /// Human-readable label (e.g., "Left Shoulder Recovery").
  TextColumn get label => text()();

  /// Current lifecycle state.
  TextColumn get status => text().map<GoalStatus>(const MyoEnumNameConverter(GoalStatus.values))();

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
  TextColumn get type => text().map<IntentType>(const MyoEnumNameConverter(IntentType.values))();

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

/// Persistent record of a biomechanical constraint or injury.
class Injuries extends Table {
  /// Unique identifier for this injury.
  TextColumn get id => text()();

  /// The technical mesh IDs affected by this injury (comma-separated).
  TextColumn get nodeIds => text().map(const StringListConverter())();

  /// The intensity of the injury.
  TextColumn get severity => text().map<InjurySeverity>(const MyoEnumNameConverter(InjurySeverity.values))();

  /// A user-friendly description.
  TextColumn get description => text()();

  /// When the injury was first logged.
  DateTimeColumn get createdAt => dateTime()();

  /// When the injury was marked as resolved.
  DateTimeColumn get resolvedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The main local database for MyoTwin.
@DriftDatabase(tables: [Goals, IntentRecords, Injuries])
class MyoTwinDatabase extends _$MyoTwinDatabase {
  /// Creates a [MyoTwinDatabase].
  MyoTwinDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(injuries);
          }
        },
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
