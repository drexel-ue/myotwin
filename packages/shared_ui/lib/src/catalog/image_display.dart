import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// A typed wrapper for the `ImageDisplay` data model to ensure type safety.
extension type ImageDisplayData(Map<String, Object?> map) {
  /// The URL of the image.
  String? get url => map['url'] as String?;
  /// The alternative text for accessibility.
  String? get altText => map['altText'] as String?;
  /// The caption text displayed below the image.
  String? get caption => map['caption'] as String?;
}

/// A [CatalogItem] that displays an image with a caption and alt text.
final imageDisplay = CatalogItem(
  name: 'ImageDisplay',
  // 1. Define the schema.
  dataSchema: S.object(
    properties: {
      'url': S.string(description: 'The URL of the image to display.'),
      'altText': S.string(description: 'The alt text for accessibility.'),
      'caption': S.string(description: 'The caption text to display below the image.'),
    },
    required: ['url'],
  ),

  // 2. The builder renders the image.
  widgetBuilder: (context) {
    final data = ImageDisplayData(context.data as Map<String, Object?>);
    final buildContext = context.buildContext;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            data.url ?? '',
            errorBuilder: (context, error, stackTrace) => Container(
              height: 150,
              color: Theme.of(buildContext).colorScheme.errorContainer,
              child: const Icon(Icons.broken_image, color: Colors.red),
            ),
          ),
        ),
        if (data.altText != null) ...[
          const SizedBox(height: 8),
          // Using Semantics for accessibility, though the AI/System relies on the Schema.
          Semantics(
            label: data.altText,
            child: const SizedBox.shrink(),
          ),
        ],
        if (data.caption != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              data.caption!,
              style: Theme.of(buildContext).textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  },
);
