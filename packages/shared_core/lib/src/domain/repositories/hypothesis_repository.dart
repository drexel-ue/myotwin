import 'package:shared_core/core.dart';

/// Repository interface for Hypothesis data access.
/// Manages hypotheses in the scientific method loop.
abstract class HypothesisRepository {
  /// Fetches all active hypotheses.
  Future<List<HypothesisEntity>> getActiveHypotheses();

  /// Fetches hypotheses linked to a specific target node.
  Future<List<HypothesisEntity>> getByTargetNode(String targetNode);

  /// Creates a new hypothesis from symptom patterns.
  Future<int> create(HypothesisEntity hypothesis);

  /// Updates the certainty score with feedback type.
  Future<void> updateCertainty(
    int hypothesisId,
    double newCertainty,
    String feedbackType,
  );

  /// Dismisses a kinetic chain (blacklist).
  Future<void> dismiss(int hypothesisId, {String? reason});

  /// Saves or updates a hypothesis.
  Future<int> upsert(HypothesisEntity hypothesis);

  /// Deletes a hypothesis by ID.
  Future<void> deleteHypothesis(int id);
}
