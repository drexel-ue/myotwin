import 'package:shared_core/shared_core.dart';

/// Represents a semantically enriched anatomical component.
///
/// Bridges the gap between raw medical mesh IDs and user-friendly layman terms.
class AnatomyNode implements Loggable {
  /// Creates an [AnatomyNode].
  const AnatomyNode({
    required this.id,
    required this.laymanName,
    required this.layer,
    this.regions = const [],
  });

  /// Creates an [AnatomyNode] from a JSON map.
  factory AnatomyNode.fromJson(Map<String, dynamic> json) => AnatomyNode(
    id: json['id'] as String,
    laymanName: json['laymanName'] as String,
    layer: AnatomyLayer.values.firstWhere((e) => e.name == json['layer']),
    regions: (json['regions'] as List<dynamic>?)?.cast<String>() ?? const [],
  );

  /// The raw medical/technical ID (e.g., 'Humerus_R').
  final String id;

  /// The user-friendly common name (e.g., 'Upper Arm Bone').
  final String laymanName;

  /// The anatomical system this node belongs to.
  final AnatomyLayer layer;

  /// A list of general regions or tags associated with this node (e.g., ['arm', 'shoulder']).
  final List<String> regions;

  @override
  String toDiagnosticString() => 'AnatomyNode(id: $id, layman: $laymanName, layer: ${layer.name})';

  @override
  String toSummaryString() => '$laymanName (${layer.name.toUpperCase()})';

  @override
  String toString() => toDiagnosticString();

  /// Converts this node to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
    'id': id,
    'laymanName': laymanName,
    'layer': layer.name,
    'regions': regions,
  };
}
