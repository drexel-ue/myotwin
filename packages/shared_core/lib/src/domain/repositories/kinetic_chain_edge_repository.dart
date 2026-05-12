import 'package:shared_core/core.dart';

/// Repository interface for KineticChainEdge data access.
/// Manages weighted edges between body segment nodes.
abstract class KineticChainEdgeRepository {
  /// Fetches all edges in the kinetic chain graph.
  Future<List<KineticChainEdgeEntity>> getAll();

  /// Fetches edges for a specific source node.
  Future<List<KineticChainEdgeEntity>> getBySourceNode(String sourceNode);

  /// Fetches edges connecting two specific nodes.
  Future<List<KineticChainEdgeEntity>> getBetweenNodes(
    String source,
    String target,
  );

  /// Creates a kinetic chain edge.
  Future<int> create(KineticChainEdgeEntity edge);

  /// Updates edge weight and correlation strength.
  Future<void> updateEdge(int id, {double? weight, double? correlation});

  /// Deletes a kinetic chain edge by ID.
  Future<void> deleteEdge(int id);
}
