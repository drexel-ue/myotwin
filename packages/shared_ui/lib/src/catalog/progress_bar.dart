import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// A typed wrapper for the `ProgressBar` data model.
extension type ProgressBarData(Map<String, Object?> map) {
  /// The current progress value.
  double? get value => double.tryParse(map['value'].toString());

  /// The maximum value.
  double? get max => double.tryParse(map['max'].toString());

  /// The label for the progress bar.
  String? get label => map['label'] as String?;
}

/// A [CatalogItem] that displays a progress bar for quantifying continuous metrics.
final progressBar = CatalogItem(
  name: 'ProgressBar',
  // 1. Define the schema.
  dataSchema: S.object(
    properties: {
      'value': S.string(description: 'The current value (e.g., "45").'),
      'max': S.string(description: 'The maximum value (e.g., "100").'),
      'label': S.string(description: 'The label for the progress bar.'),
    },
    required: ['value', 'max'],
  ),

  // 2. The builder renders the progress bar.
  widgetBuilder: (context) {
    final data = ProgressBarData(context.data as Map<String, Object?>);
    final buildContext = context.buildContext;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              data.label!,
              style: Theme.of(buildContext).textTheme.labelSmall,
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (data.max != null && data.max! > 0) ? (data.value! / data.max!) : 0.0,
            minHeight: 8,
            backgroundColor: Theme.of(buildContext).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(buildContext).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  },
);
