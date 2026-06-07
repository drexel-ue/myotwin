import 'package:flutter/material.dart';
import 'package:shared_core/shared_core.dart';

/// User preferences for HUD and 3D Digital Twin aesthetics.
class ThemeSettings implements Loggable {
  /// Creates [ThemeSettings].
  const ThemeSettings({
    required this.accentColor,
    required this.highlightColor,
    required this.modelRoughness,
  });

  /// Default tactical settings (Cyan accents, high-polished carbon).
  factory ThemeSettings.defaultTactical() {
    return const ThemeSettings(
      accentColor: Color(0xFF00FFFF), // Cyan
      highlightColor: Color(0xFF00FFFF),
      modelRoughness: 0.25,
    );
  }

  /// Creates [ThemeSettings] from a JSON map.
  factory ThemeSettings.fromJson(Map<String, dynamic> json) => ThemeSettings(
        accentColor: Color(json['accentColor'] as int),
        highlightColor: Color(json['highlightColor'] as int),
        modelRoughness: (json['modelRoughness'] as num).toDouble(),
      );

  /// The primary neon accent color for UI elements and lighting.
  final Color accentColor;

  /// The emissive pulse color for active anatomical highlights.
  final Color highlightColor;

  /// The physical roughness of the 3D materials (0.0 = mirror, 1.0 = matte).
  final double modelRoughness;

  /// Creates a copy of these settings with the given fields replaced.
  ThemeSettings copyWith({
    Color? accentColor,
    Color? highlightColor,
    double? modelRoughness,
  }) {
    return ThemeSettings(
      accentColor: accentColor ?? this.accentColor,
      highlightColor: highlightColor ?? this.highlightColor,
      modelRoughness: modelRoughness ?? this.modelRoughness,
    );
  }

  @override
  String toDiagnosticString() =>
      'ThemeSettings(accent: ${accentColor.toARGB32().toRadixString(16)}, highlight: ${highlightColor.toARGB32().toRadixString(16)}, roughness: $modelRoughness)';

  @override
  String toSummaryString() => 'THEME: roughness=$modelRoughness';

  @override
  String toString() => toDiagnosticString();

  /// Converts settings to a JSON-compatible map for persistence.
  Map<String, dynamic> toJson() => {
        'accentColor': accentColor.toARGB32(),
        'highlightColor': highlightColor.toARGB32(),
        'modelRoughness': modelRoughness,
      };
}
