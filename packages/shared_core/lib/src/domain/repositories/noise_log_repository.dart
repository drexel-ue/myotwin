import 'package:shared_core/core.dart';

/// Repository interface for NoiseLog data access.
/// Tracks environmental, mental, and stress data.
abstract class NoiseLogRepository {
  /// Fetches noise logs by date range.
  Future<List<NoiseLogEntity>> getByDateRange(DateTime start, DateTime end);

  /// Fetches noise logs by type.
  Future<List<NoiseLogEntity>> getByType(String type);

  /// Saves a noise log entry.
  Future<int> save(NoiseLogEntity entry);

  /// Deletes a noise log by ID.
  Future<void> deleteNoiseLog(int id);
}
