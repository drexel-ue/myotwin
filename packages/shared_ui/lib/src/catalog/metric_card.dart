import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// A typed wrapper for the `MetricCard` data model to ensure type safety
/// when accessing properties from the dynamic `context.data` map.
extension type MetricCardData(Map<String, Object?> map) {
  /// The label of the metric.
  String? get label => map['label'] as String?;

  /// The formatted value.
  String? get valueString => map['value'] as String?;

  /// The unit of measurement.
  String? get unit => map['unit'] as String?;

  /// The direction of change.
  String? get trend => map['trend'] as String?;
}

/// A [CatalogItem] that displays a single, high-level metric
/// (e.g., 'Torque: 45Nm' or 'Pain: 0.7') in a visually distinct card.
final metricCard = CatalogItem(
  name: 'MetricCard',
  // 1. Define the schema so the AI knows what keys to send.
  dataSchema: S.object(
    properties: {
      'label': S.string(description: 'The metric name (e.g. "Torque", "Pain").'),
      'value': S.string(description: 'The formatted value (e.g. "45Nm", "0.7").'),
      'unit': S.string(description: 'The unit of measurement (e.g. "Nm", "kg").'),
      'trend': S.string(description: 'The direction of change (e.g. "up", "down", "stable").'),
    },
    required: ['label', 'value'],
  ),

  // 2. The builder renders the UI based on the incoming DataModel properties.
  widgetBuilder: (context) {
    // Cast the dynamic data to our typed extension type.
    final data = MetricCardData(context.data as Map<String, Object?>);
    final buildContext = context.buildContext;

    return Card(
      elevation: 0,
      color: Theme.of(buildContext).colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(buildContext).colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoundString(
              dataContext: context.dataContext,
              value: data.label,
              builder: (context, label) => Text(
                label ?? '',
                style: Theme.of(buildContext).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  color: Theme.of(buildContext).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                BoundString(
                  dataContext: context.dataContext,
                  value: data.valueString,
                  builder: (context, value) => Text(
                    value ?? '',
                    style: Theme.of(buildContext).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (data.unit != null) ...[
                  const SizedBox(width: 2),
                  BoundString(
                    dataContext: context.dataContext,
                    value: data.unit,
                    builder: (context, unit) => Text(
                      unit ?? '',
                      style: Theme.of(buildContext).textTheme.bodySmall,
                    ),
                  ),
                ],
              ],
            ),
            if (data.trend != null) ...[
              const SizedBox(height: 4),
              BoundString(
                dataContext: context.dataContext,
                value: data.trend,
                builder: (context, trend) => Text(
                  trend ?? '',
                  style: Theme.of(buildContext).textTheme.bodySmall?.copyWith(
                    color: trend!.contains('up') ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  },
);
