import 'package:shared_core/core.dart';

/// Data access interface for BodySegment entities.
/// Manages biomechanical body segment nodes for the twin model.
abstract class BodySegmentRepository {
  /// Fetches all registered body segments.
  Future<List<BodySegmentEntity>> getAllSegments();

  /// Fetches a single body segment by [id].
  ///
  /// Returns `null` if no segment with the given ID exists.
  Future<BodySegmentEntity?> getSegmentById(int id);

  /// Fetches segments whose anatomical region matches [region].
  Future<List<BodySegmentEntity>> getSegmentsByRegion(String region);

  /// Fetches integrity scores for the given [muscleIds].
  ///
  /// Returns a map from muscle ID to its integrity score.
  Future<Map<String, double>> getManyIntegrityScores(List<String> muscleIds);

  /// Inserts a new segment or updates an existing one.
  ///
  /// Returns the segment ID.
  Future<int> upsert(BodySegmentEntity segment);

  /// Deletes the segment with the given [id].
  Future<void> deleteSegment(int id);
}
