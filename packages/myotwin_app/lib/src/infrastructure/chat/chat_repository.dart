import 'package:drift/drift.dart';
import 'package:myotwin_app/src/infrastructure/persistence/myotwin_database.dart';
import 'package:shared_core/shared_core.dart' as domain;
import 'package:uuid/uuid.dart';

/// Orchestrates the persistence and generation of [domain.IntentRecord]s.
///
/// Coordinates between [MyoTwinDatabase] (persistence) and [domain.MotusAgent]
/// (inference) while using [domain.LoggerService] for diagnostics.
class ChatRepository {
  /// Creates a [ChatRepository].
  ChatRepository({
    required MyoTwinDatabase database,
    required domain.MotusAgent agent,
    required domain.LoggerService logger,
  }) : _db = database,
       _agent = agent,
       _logger = logger;

  final MyoTwinDatabase _db;
  final domain.MotusAgent _agent;
  final domain.LoggerService _logger;

  /// Returns a stream of all [domain.IntentRecord]s for the given [goalId].
  Stream<List<domain.IntentRecord>> watchMessages(String goalId) {
    _logger.detail('CHAT_REPOSITORY: WATCHING_MESSAGES: $goalId');
    return (_db.select(_db.intentRecords)
          ..where((t) => t.goalId.equals(goalId))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map(_mapToDomain).toList());
  }

  /// Initiates an AI response stream with global biomechanical context.
  Stream<String> getResponseStream(String message, {List<domain.IntentRecord>? context}) async* {
    _logger.detail('CHAT_REPOSITORY: GET_RESPONSE_STREAM: $message');
    final report = await _generateSituationReport();
    final augmentedMessage =
        '''
[SITUATION_REPORT]
$report
[/SITUATION_REPORT]

USER_INPUT: $message
''';
    yield* _agent.streamChatResponse(augmentedMessage, context: context);
  }

  Future<String> _generateSituationReport() async {
    final activeGoals = await (_db.select(
      _db.goals,
    )..where((t) => t.status.equals(domain.GoalStatus.active.name))).get();

    if (activeGoals.isEmpty) return 'No active biological objectives detected.';

    final buffer = StringBuffer('Active Biological Objectives:\n');
    for (final goal in activeGoals) {
      final meta = goal.metadata;
      buffer.write('- ${goal.label}: ${meta.summary ?? 'No summary available.'}\n');
      if (meta.targetAnatomyNodes.isNotEmpty) {
        buffer.write('  Nodes: ${meta.targetAnatomyNodes.join(', ')}\n');
      }
    }
    return buffer.toString();
  }

  /// Persists a new [domain.IntentRecord] to the database.
  Future<void> saveIntent(domain.IntentRecord intent) async {
    _logger.detail('CHAT_REPOSITORY: SAVE_INTENT: ${intent.id} | REASON: ${intent.reason}');
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

    _logger.info('CHAT_REPOSITORY: CREATING_DEFAULT_SESSION_GOAL');

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

  /// Fetches all user goals from the database.
  Future<List<domain.Goal>> fetchGoals() async {
    final rows = await _db.select(_db.goals).get();
    return rows.map(_mapGoalToDomain).toList();
  }

  /// Fetches a specific goal by its ID.
  Future<domain.Goal?> getGoal(String id) async {
    final row = await (_db.select(_db.goals)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row != null ? _mapGoalToDomain(row) : null;
  }

  domain.Goal _mapGoalToDomain(Goal row) {
    return domain.Goal(
      id: row.id,
      label: row.label,
      status: row.status,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      metadata: row.metadata,
    );
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
