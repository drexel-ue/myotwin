import 'package:shared_core/core.dart';

/// Data access interface for KineticChainEdge entities.
/// Manages weighted edges between body segment nodes.
abstract class KineticChainEdgeRepository {
  /// Fetches all edges in the kinetic chain graph.
  Future<List<KineticChainEdgeEntity>> getAll();

  /// Fetches edges originating from the node identified by [sourceNode].
  Future<List<KineticChainEdgeEntity>> getBySourceNode(String sourceNode);

  /// Fetches edges between the [source] and [target] nodes.
  Future<List<KineticChainEdgeEntity>> getBetweenNodes(
    String source,
    String target,
  );

  /// Persists a new [edge].
  ///
  /// Returns the edge ID.
  Future<int> create(KineticChainEdgeEntity edge);

  /// Updates the [weight] and/or [correlation] of the edge identified
  /// by [id]. Only provided values are updated.
  Future<void> updateEdge(int id, {double? weight, double? correlation});

  /// Deletes the edge with the given [id].
  Future<void> deleteEdge(int id);
}
