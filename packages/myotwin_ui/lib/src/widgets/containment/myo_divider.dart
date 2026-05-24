import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A cyberpunk-style divider used for HUD layout separation.
///
/// By default, it uses the [MyoTwinTheme.outline] color.
class MyoDivider extends StatelessWidget {
  /// Creates a [MyoDivider].
  const MyoDivider({
    super.key,
    this.thickness = 1.0,
    this.color,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.height = 1.0,
  });

  /// The thickness of the divider line.
  final double thickness;

  /// The color of the divider line.
  final Color? color;

  /// The amount of empty space to leave before the divider starts.
  final double indent;

  /// The amount of empty space to leave after the divider ends.
  final double endIndent;

  /// The height of the divider (for horizontal dividers).
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;
    final finalColor = color ?? theme.outline;

    return SizedBox(
      height: height,
      child: Divider(
        thickness: thickness,
        color: finalColor,
        indent: indent,
        endIndent: endIndent,
      ),
    );
  }
}
