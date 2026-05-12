import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

/// A typed wrapper for the `TextDisplay` data model to ensure type safety.
extension type TextDisplayData(Map<String, Object?> map) {
  /// The text content to display.
  String? get text => map['text'] as String?;

  /// Whether the text should be rendered as markdown.
  String? get isMarkdown => map['isMarkdown'] as String?;

  /// The font size for the text.
  double? get fontSize => map['fontSize'] != null ? double.tryParse(map['fontSize'].toString()) : null;
}

/// A [CatalogItem] that displays text with support for markdown and dynamic styling.
final textDisplay = CatalogItem(
  name: 'TextDisplay',
  // 1. Define the schema.
  dataSchema: S.object(
    properties: {
      'text': S.string(description: 'The text content to display.'),
      'isMarkdown': S.string(description: 'Whether to render as markdown ("true" or "false").'),
      'fontSize': S.string(description: 'The font size as a string (e.g., "14", "18").'),
    },
    required: ['text'],
  ),

  // 2. The builder renders the text.
  widgetBuilder: (context) {
    // Cast the dynamic data to our typed extension type.
    final data = TextDisplayData(context.data as Map<String, Object?>);
    final buildContext = context.buildContext;
    final isMarkdown = data.isMarkdown == 'true';

    return BoundString(
      dataContext: context.dataContext,
      value: data.text,
      builder: (context, text) {
        final style = TextStyle(
          fontSize: data.fontSize ?? 14.0,
          color: Theme.of(buildContext).colorScheme.onSurface,
        );

        if (isMarkdown) {
          return Markdown(
            data: text ?? '',
            styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
          );
        }

        return Text(
          text ?? '',
          style: style,
        );
      },
    );
  },
);
