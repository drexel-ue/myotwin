import 'package:shared_core/core.dart';

/// Data access interface for SymptomEvent entities.
/// Tracks real-time symptom events reported by the user.
abstract class SymptomLogRepository {
  /// Fetches recent symptom events for the muscle identified by [muscleId].
  ///
  /// [limit] caps the number of results (default 10).
  Future<List<SymptomEvent>> getRecentSymptoms(
    String muscleId, {
    int limit = 10,
  });

  /// Gets the average symptom intensity for [muscleId] over the last [days].
  Future<double> getAvgIntensity(String muscleId, int days);

  /// Fetches all symptom event logs.
  Future<List<SymptomEvent>> getAllSymptoms();

  /// Logs a new [symptom] event.
  ///
  /// Returns the event ID.
  Future<int> logSymptom(SymptomEvent symptom);

  /// Logs [symptoms] in batch.
  ///
  /// Returns a list of inserted event IDs.
  Future<List<int>> logBatch([List<SymptomEvent> symptoms]);

  /// Deletes the symptom entry with the given [id].
  Future<void> deleteSymptom(int id);
}
