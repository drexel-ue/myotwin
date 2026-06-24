import 'package:shared_core/shared_core.dart';

/// Defines the intensity of a logged injury or physical constraint.
enum InjurySeverity {
  /// Minor tightness or discomfort.
  low,

  /// Moderate pain affecting specific movements.
  medium,

  /// Severe pain requiring complete rest or immobilization.
  critical,
}

/// Represents a physical constraint or injury localized to specific anatomical nodes.
class Injury implements Loggable {
  /// Creates an [Injury].
  const Injury({
    required this.id,
    required this.nodeIds,
    required this.severity,
    required this.description,
    required this.createdAt,
    this.resolvedAt,
  });

  /// Creates an [Injury] from a JSON map.
  factory Injury.fromJson(Map<String, dynamic> json) => Injury(
        id: json['id'] as String,
        nodeIds: (json['nodeIds'] as List<dynamic>).cast<String>(),
        severity: InjurySeverity.values.firstWhere((e) => e.name == json['severity']),
        description: json['description'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt'] as String) : null,
      );

  /// Unique identifier for this injury.
  final String id;

  /// The technical mesh IDs affected by this injury.
  final List<String> nodeIds;

  /// The intensity of the injury.
  final InjurySeverity severity;

  /// A user-friendly description of the pain or cause.
  final String description;

  /// When the injury was first logged.
  final DateTime createdAt;

  /// When the injury was marked as resolved (null if active).
  final DateTime? resolvedAt;

  /// Whether the injury is currently active.
  bool get isActive => resolvedAt == null;

  @override
  String toDiagnosticString() =>
      'Injury(id: $id, nodes: ${nodeIds.length}, severity: ${severity.name})';

  @override
  String toSummaryString() => '$description (${severity.name.toUpperCase()})';

  /// Converts this injury to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'nodeIds': nodeIds,
        'severity': severity.name,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'resolvedAt': resolvedAt?.toIso8601String(),
      };
}
