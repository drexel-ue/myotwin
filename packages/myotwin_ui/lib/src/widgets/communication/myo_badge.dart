import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// Visual styles for [MyoBadge].
enum MyoBadgeStyle {
  /// Solid white background with dark text.
  filledWhite,

  /// Transparent background with white border and text.
  outlinedWhite,

  /// Solid error background with white text.
  filledError,

  /// Transparent background with error border and text.
  outlinedError,
}

/// A cyberpunk-style badge used for notifications or counts.
///
/// Glitches visually whenever the [count] updates.
class MyoBadge extends StatefulWidget {
  /// Creates a [MyoBadge].
  const MyoBadge({
    super.key,
    required this.count,
    this.style = .filledWhite,
    this.padding,
    this.borderRadius,
  });

  /// The count or label to display.
  final String count;

  /// The visual style of the badge.
  final MyoBadgeStyle style;

  /// Optional padding around the text inside the badge.
  final EdgeInsetsGeometry? padding;

  /// Optional border radius for the badge.
  final BorderRadius? borderRadius;

  @override
  State<MyoBadge> createState() => _MyoBadgeState();
}

class _MyoBadgeState extends State<MyoBadge> with SingleTickerProviderStateMixin, HoloGlitchTickerMixin<MyoBadge> {
  @override
  void didUpdateWidget(covariant MyoBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      triggerGlitch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    final Color bgColor;
    final Color fgColor;
    final Color borderColor;
    final double borderWidth;
    final radius = widget.borderRadius ?? theme.radiusFull;

    switch (widget.style) {
      case .filledWhite:
        bgColor = theme.white;
        fgColor = theme.black;
        borderColor = Colors.transparent;
        borderWidth = 0;
      case .outlinedWhite:
        bgColor = Colors.transparent;
        fgColor = theme.white;
        borderColor = theme.white;
        borderWidth = 1.0;
      case .filledError:
        bgColor = theme.error;
        fgColor = theme.white;
        borderColor = Colors.transparent;
        borderWidth = 0;
      case .outlinedError:
        bgColor = Colors.transparent;
        fgColor = theme.error;
        borderColor = theme.error;
        borderWidth = 1.0;
    }

    return HoloGlitch(
      phase: glitchPhase,
      intensity: glitchIntensity,
      severity: 0.5,
      child: Container(
        padding: widget.padding ?? (horizontalPadding6 + verticalPadding2),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: radius,
          border: borderWidth > 0 ? .all(color: borderColor, width: borderWidth) : null,
        ),
        child: Text(
          _formatCount(widget.count),
          style: theme.caption.copyWith(
            color: fgColor,
            fontWeight: .bold,
            fontSize: 10,
          ),
          textAlign: .center,
        ),
      ),
    );
  }

  String _formatCount(String count) {
    final value = int.tryParse(count);
    if (value == null) return count;

    if (value < 1000) return value.toString();

    final suffixes = <int, String>{
      12: 'T',
      9: 'B',
      6: 'M',
      3: 'k',
    };

    for (final entry in suffixes.entries) {
      final power = entry.key;
      final suffix = entry.value;
      final divisor = pow(10, power).toDouble();

      if (value >= divisor) {
        final formatted = value / divisor;
        return '${formatted.toStringAsFixed(1).replaceFirst('.0', '')}$suffix';
      }
    }

    return count;
  }
}
