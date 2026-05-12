import 'package:shared_core/core.dart';

/// Data access interface for NoiseLog entities.
/// Tracks environmental, mental, and stress data.
abstract class NoiseLogRepository {
  /// Fetches noise logs within the date range [start] to [end].
  Future<List<NoiseLogEntity>> getByDateRange(DateTime start, DateTime end);

  /// Fetches noise logs whose type matches [type].
  Future<List<NoiseLogEntity>> getByType(String type);

  /// Persists a new [entry].
  ///
  /// Returns the entry ID.
  Future<int> save(NoiseLogEntity entry);

  /// Deletes the noise log with the given [id].
  Future<void> deleteNoiseLog(int id);
}
