import 'package:shared_core/core.dart';

/// Repository interface for Source data access.
/// Manages cited research material.
abstract class SourceRepository {
  /// Fetches all sources.
  Future<List<SourceEntity>> getAll();

  /// Fetches sources by category.
  Future<List<SourceEntity>> getByCategory(String category);

  /// Saves a source.
  Future<int> save(SourceEntity source);

  /// Deletes a source by ID.
  Future<void> deleteSource(int id);
}
