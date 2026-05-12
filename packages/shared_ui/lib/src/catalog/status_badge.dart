import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:shared_ui/src/theme.dart';

/// A typed wrapper for the `StatusBadge` data model to ensure type safety.
extension type StatusBadgeData(Map<String, Object?> map) {
  /// The status text (e.g. "Success", "Warning", "Error").
  String? get status => map['status'] as String?;

  /// The icon name for the badge.
  String? get icon => map['icon'] as String?;

  /// The color intensity or color name.
  String? get color => map['color'] as String?;
}

/// A [CatalogItem] that displays a status indicator (e.g., "Active", "Critical").
final statusBadge = CatalogItem(
  name: 'StatusBadge',
  // 1. Define the schema.
  dataSchema: S.object(
    properties: {
      'status': S.string(description: 'The status text (e.g., "Active", "Error").'),
      'icon': S.string(description: 'A Material Design icon name (e.g., "check", "warning").'),
      'color': S.string(description: 'A color name (e.g., "green", "red", "orange").'),
    },
    required: ['status'],
  ),

  // 2. The builder renders the badge.
  widgetBuilder: (context) {
    final data = StatusBadgeData(context.data as Map<String, Object?>);

    return BoundString(
      dataContext: context.dataContext,
      value: data.status,
      builder: (context, status) {
        final color = _getColorFromString(data.color);

        return Chip(
          avatar: Icon(
            _getIconData(data.icon ?? ''),
            size: 16,
            color: color,
          ),
          label: Text(
            status ?? '',
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
          backgroundColor: color.withValues(alpha: 0.1),
          side: BorderSide(color: color.withValues(alpha: 0.2)),
        );
      },
    );
  },
);

/// Helper to map color strings to MyoTwin design tokens.
Color _getColorFromString(String? colorName) {
  switch (colorName?.toLowerCase()) {
    case 'success':
    case 'green':
      return MyoTwinTheme.success;
    case 'error':
    case 'red':
      return MyoTwinTheme.error;
    case 'warning':
    case 'orange':
      return MyoTwinTheme.accentHot;
    case 'info':
    case 'blue':
      return MyoTwinTheme.linkStrong;
    case 'faint':
    case 'yellow':
      return MyoTwinTheme.linkFaint;
    default:
      return MyoTwinTheme.onSurfaceMedium;
  }
 }

/// Helper to map string names to IconData.
IconData _getIconData(String name) {
  switch (name) {
    case 'check':
      return Icons.check;
    case 'warning':
      return Icons.warning;
    case 'error':
      return Icons.error;
    case 'info':
      return Icons.info;
    case 'add':
      return Icons.add;
    default:
      return Icons.help_outline;
  }
}
