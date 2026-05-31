/// Zero-cost wrappers for unstructured JSON data.
///
/// These extension types allow Motus to shape and evolve data dynamically
/// while providing type-safe accessors for known fields.
library;

/// Wraps unstructured metadata for a Goal.
extension type const GoalMetadata(Map<String, dynamic> data) {
  /// The estimated time to reach this goal (in days).
  int? get estimatedRecoveryDays => data['recovery_days'] as int?;

  /// The anatomical node this goal primarily targets.
  String? get targetAnatomyNode => data['target_node'] as String?;
}

/// Wraps an unstructured GenUI payload for an IntentRecord.
extension type const IntentPayload(Map<String, dynamic> data) {
  /// The list of CatalogItem configurations to render.
  List<Map<String, dynamic>>? get catalogItems =>
      (data['items'] as List?)?.cast<Map<String, dynamic>>();

  /// The visual urgency of the surface (0.0 to 1.0).
  double? get urgency => data['urgency'] as double?;
}
