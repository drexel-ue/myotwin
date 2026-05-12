import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import 'package:shared_ui/src/theme.dart';

/// A typed wrapper for the `ActionBtn` data model to ensure type safety.

/// A typed wrapper for the `ActionBtn` data model to ensure type safety.
extension type ActionBtnData(Map<String, Object?> map) {
  /// The label of the button.
  String? get label => map['label'] as String?;

  /// The icon name for the button.
  String? get icon => map['icon'] as String?;

  /// The type of action.
  String? get actionType => map['actionType'] as String?;
}

/// An `ActionBtn` is a primary interaction primitive.
/// It allows the AI to present the user with actionable commands
/// (e.g., "Log Session", "Verify Shoulder", "Check Spine").
final actionBtn = CatalogItem(
  name: 'ActionBtn',
  // 1. Define the schema: The action needs a label and a potential action type.
  dataSchema: S.object(
    properties: {
      'label': S.string(description: 'The text displayed on the button.'),
      'icon': S.string(description: 'A Material Design icon name (e.g., "check", "add", "warning").'),
      'actionType': S.string(description: 'The type of action: "navigation", "data_entry", or "rotation".'),
    },
    required: ['label', 'actionType'],
  ),

  // 2. The builder renders the button.
  widgetBuilder: (context) {
    // Cast the dynamic data to our typed extension type.
    final data = ActionBtnData(context.data as Map<String, Object?>);

    return ElevatedButton.icon(
      onPressed: () {
        // In a real implementation, this would trigger a
        // SurfaceController event or a BLoC action.
        debugPrint('Action triggered: ${data.label} (Type: ${data.actionType})');
      },
      icon: Icon(
        // Simplified icon lookup for this primitive
        _getIconData(data.icon ?? ''),
      ),
      label: Text(data.label ?? ''),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: MyoTwinTheme.surfaceElevated,
        foregroundColor: MyoTwinTheme.onSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MyoTwinTheme.radiusSm),
        ),
      ),
    );
  },
);

/// Helper to map string names to IconData.
IconData _getIconData(String name) {
  switch (name) {
    case 'add':
      return Icons.add;
    case 'check':
      return Icons.check;
    case 'warning':
      return Icons.warning;
    case 'recent':
      return Icons.history;
    case 'person':
      return Icons.person;
    default:
      return Icons.help_outline;
  }
}
