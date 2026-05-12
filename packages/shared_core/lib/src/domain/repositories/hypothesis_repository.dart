import 'package:shared_core/core.dart';

/// Data access interface for Hypothesis entities.
/// Manages hypotheses in the scientific method loop.
abstract class HypothesisRepository {
  /// Fetches all active (non-dismissed) hypotheses.
  Future<List<HypothesisEntity>> getActiveHypotheses();

  /// Fetches hypotheses linked to the node identified by [targetNode].
  Future<List<HypothesisEntity>> getByTargetNode(String targetNode);

  /// Persists a new [hypothesis].
  ///
  /// Returns the hypothesis ID.
  Future<int> create(HypothesisEntity hypothesis);

  /// Updates the certainty score of hypothesis [hypothesisId]
  /// using the given [newCertainty] and [feedbackType].
  Future<void> updateCertainty(
    int hypothesisId,
    double newCertainty,
    String feedbackType,
  );

  /// Dismisses the hypothesis identified by [hypothesisId].
  ///
  /// Optionally records a [reason] for the dismissal.
  Future<void> dismiss(int hypothesisId, {String? reason});

  /// Inserts a new hypothesis or updates an existing one.
  ///
  /// Returns the hypothesis ID.
  Future<int> upsert(HypothesisEntity hypothesis);

  /// Deletes the hypothesis with the given [id].
  Future<void> deleteHypothesis(int id);
}
