import 'package:drift/drift.dart';
import 'package:myotwin_app/src/infrastructure/persistence/myotwin_database.dart';
import 'package:shared_core/shared_core.dart' as domain;
import 'package:uuid/uuid.dart';

/// Orchestrates the persistence and generation of [domain.IntentRecord]s.
class ChatRepository {
  /// Creates a [ChatRepository].
  ChatRepository({
    required MyoTwinDatabase database,
    required domain.MotusAgent agent,
  }) : _db = database,
       _agent = agent;

  final MyoTwinDatabase _db;
  final domain.MotusAgent _agent;

  /// Returns a stream of all [domain.IntentRecord]s for the given [goalId].
  Stream<List<domain.IntentRecord>> watchMessages(String goalId) {
    return (_db.select(_db.intentRecords)
          ..where((t) => t.goalId.equals(goalId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map(_mapToDomain).toList());
  }

  /// Initiates an AI response stream.
  Stream<String> getResponseStream(String message, {List<domain.IntentRecord>? context}) {
    return _agent.streamChatResponse(message, context: context);
  }

  /// Persists a new [domain.IntentRecord] to the database.
  Future<void> saveIntent(domain.IntentRecord intent) async {
    await _db
        .into(_db.intentRecords)
        .insert(
          IntentRecordsCompanion.insert(
            id: intent.id,
            goalId: intent.goalId,
            type: intent.type,
            createdAt: intent.scheduledTime,
            scheduledTime: intent.scheduledTime,
            reason: intent.reason,
            payload: intent.payload,
            deliveredAt: Value(intent.deliveredAt),
            userEngagementScore: Value(intent.userEngagementScore),
          ),
        );
  }

  /// Ensures a default "Active Session" goal exists and returns its ID.
  Future<String> getOrCreateActiveGoalId() async {
    final existing =
        await (_db.select(_db.goals)
              ..where((t) => t.status.equals(domain.GoalStatus.active.name))
              ..limit(1))
            .getSingleOrNull();

    if (existing != null) return existing.id;

    final id = const Uuid().v4();
    await _db
        .into(_db.goals)
        .insert(
          GoalsCompanion.insert(
            id: id,
            label: 'ACTIVE_HUD_SESSION',
            status: domain.GoalStatus.active,
            createdAt: DateTime.now(),
            metadata: const domain.GoalMetadata({}),
          ),
        );
    return id;
  }

  domain.IntentRecord _mapToDomain(IntentRecord row) {
    return domain.IntentRecord(
      id: row.id,
      goalId: row.goalId,
      type: row.type,
      payload: row.payload,
      scheduledTime: row.scheduledTime,
      deliveredAt: row.deliveredAt,
      userEngagementScore: row.userEngagementScore,
      reason: row.reason,
    );
  }
}
