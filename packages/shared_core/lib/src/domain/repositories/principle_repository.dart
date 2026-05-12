import 'package:shared_core/core.dart';

/// Repository interface for Principle data access.
/// Manages ingested biomechanical rules.
abstract class PrincipleRepository {
  /// Fetches all principles.
  Future<List<PrincipleEntity>> getAll();

  /// Fetches principles by category.
  Future<List<PrincipleEntity>> getByCategory(String category);

  /// Fetches principles from a specific knowledge source.
  Future<List<PrincipleEntity>> getByKnowledgeSource(String knowledgeSourceId);

  /// Saves a principle.
  Future<int> save(PrincipleEntity principle);

  /// Deletes a principle by ID.
  Future<void> deletePrinciple(int id);
}
