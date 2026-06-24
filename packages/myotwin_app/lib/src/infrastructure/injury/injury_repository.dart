import 'package:drift/drift.dart';
import 'package:myotwin_app/src/infrastructure/persistence/myotwin_database.dart';
import 'package:shared_core/shared_core.dart' as domain;

/// Orchestrates the persistence of [domain.Injury] records.
class InjuryRepository {
  /// Creates an [InjuryRepository].
  InjuryRepository({
    required MyoTwinDatabase database,
    required domain.LoggerService logger,
  }) : _db = database,
       _logger = logger;

  final MyoTwinDatabase _db;
  final domain.LoggerService _logger;

  /// Returns a stream of all active injuries.
  Stream<List<domain.Injury>> watchActiveInjuries() {
    return (_db.select(_db.injuries)
          ..where((t) => t.resolvedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map(_mapToDomain).toList());
  }

  /// Persists a new injury to the database.
  Future<void> saveInjury(domain.Injury injury) async {
    _logger.detail('INJURY_REPOSITORY: SAVE_INJURY: ${injury.id}');
    await _db.into(_db.injuries).insert(
      InjuriesCompanion.insert(
        id: injury.id,
        nodeIds: injury.nodeIds,
        severity: injury.severity.name,
        description: injury.description,
        createdAt: injury.createdAt,
        resolvedAt: Value(injury.resolvedAt),
      ),
    );
  }


  /// Marks an injury as resolved.
  Future<void> resolveInjury(String id) async {
    _logger.detail('INJURY_REPOSITORY: RESOLVE_INJURY: $id');
    await (_db.update(_db.injuries)..where((t) => t.id.equals(id))).write(
      InjuriesCompanion(resolvedAt: Value(DateTime.now())),
    );
  }

  domain.Injury _mapToDomain(Injury row) {
    return domain.Injury(
      id: row.id,
      nodeIds: row.nodeIds,
      severity: domain.InjurySeverity.values.byName(row.severity),
      description: row.description,
      createdAt: row.createdAt,
      resolvedAt: row.resolvedAt,
    );
  }
}
