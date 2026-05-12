import 'package:shared_core/core.dart';

/// Data access interface for Source entities.
/// Manages cited research material.
abstract class SourceRepository {
  /// Fetches all sources.
  Future<List<SourceEntity>> getAll();

  /// Fetches sources whose category matches [category].
  Future<List<SourceEntity>> getByCategory(String category);

  /// Persists a new [source].
  ///
  /// Returns the source ID.
  Future<int> save(SourceEntity source);

  /// Deletes the source with the given [id].
  Future<void> deleteSource(int id);
}
