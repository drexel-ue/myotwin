import 'package:shared_core/core.dart';

/// Data access interface for Principle entities.
/// Manages ingested biomechanical rules.
abstract class PrincipleRepository {
  /// Fetches all biomechanical principles.
  Future<List<PrincipleEntity>> getAll();

  /// Fetches principles whose category matches [category].
  Future<List<PrincipleEntity>> getByCategory(String category);

  /// Fetches principles originating from knowledge source [knowledgeSourceId].
  Future<List<PrincipleEntity>> getByKnowledgeSource(String knowledgeSourceId);

  /// Persists a new [principle].
  ///
  /// Returns the principle ID.
  Future<int> save(PrincipleEntity principle);

  /// Deletes the principle with the given [id].
  Future<void> deletePrinciple(int id);
}
