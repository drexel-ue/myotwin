/// Enumeration of data point source types for tracking data provenance.
/// Every data point in the database must include a [SourceType].
enum SourceType {
  /// User-reported via manual input.
  manual,

  /// Engine-calculated (torque, integrity score, certainty).
  computed,

  /// Computer Vision-derived (future feature).
  vision,

  /// Retrieved from research vector store.
  rag,
}

/// Extension providing human-readable display values for [SourceType].
extension SourceTypeX on SourceType {
  /// String representation for database storage.
  String get value {
    switch (this) {
      case SourceType.manual:
        return 'manual';
      case SourceType.computed:
        return 'computed';
      case SourceType.vision:
        return 'vision';
      case SourceType.rag:
        return 'rag';
    }
  }

  /// Parses a string value to [SourceType].
  static SourceType fromValue(String value) {
    switch (value) {
      case 'manual':
        return SourceType.manual;
      case 'computed':
        return SourceType.computed;
      case 'vision':
        return SourceType.vision;
      case 'rag':
        return SourceType.rag;
    }
    throw ArgumentError('Unknown SourceType: $value');
  }
}
