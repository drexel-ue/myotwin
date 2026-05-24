import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// Visual styles for [MyoChip].
enum MyoChipStyle {
  /// Solid background with high contrast text.
  filled,

  /// Transparent background with outlined border.
  outlined,
}

/// A cyberpunk HUD-style chip used for tags, filters, or selection.
///
/// Glitches visually when the [isSelected] state changes or upon tap.
class MyoChip extends StatefulWidget {
  /// Creates a [MyoChip].
  const MyoChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onSelected,
    this.style = .outlined,
    this.leading,
    this.trailing,
    this.padding,
  });

  /// The text label of the chip.
  final String label;

  /// Whether the chip is currently selected.
  final bool isSelected;

  /// Callback triggered when the chip is toggled.
  final ValueChanged<bool>? onSelected;

  /// The visual style of the chip.
  final MyoChipStyle style;

  /// Optional widget displayed at the start.
  final Widget? leading;

  /// Optional widget displayed at the end.
  final Widget? trailing;

  /// Optional custom padding.
  final EdgeInsetsGeometry? padding;

  @override
  State<MyoChip> createState() => _MyoChipState();
}

class _MyoChipState extends State<MyoChip> with SingleTickerProviderStateMixin, HoloGlitchTickerMixin<MyoChip> {
  @override
  void didUpdateWidget(covariant MyoChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
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

    if (widget.isSelected) {
      // Selected state: always high contrast (filled)
      bgColor = theme.accentHot;
      fgColor = theme.black;
      borderColor = theme.accentHot;
      borderWidth = 1.0;
    } else {
      // Unselected state: depends on style
      switch (widget.style) {
        case .filled:
          bgColor = theme.surfaceElevated2;
          fgColor = theme.onSurfaceMedium;
          borderColor = theme.outline;
          borderWidth = 1.0;
        case .outlined:
          bgColor = Colors.transparent;
          fgColor = theme.onSurfaceMedium;
          borderColor = theme.outline;
          borderWidth = 1.0;
      }
    }

    return HoloGlitch(
      phase: glitchPhase,
      intensity: glitchIntensity,
      severity: 0.3,
      child: GestureDetector(
        onTap: () {
          triggerGlitch();
          widget.onSelected?.call(!widget.isSelected);
        },
        child: Container(
          padding: widget.padding ?? horizontalPadding10 + verticalPadding6,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: theme.radiusSm,
            border: .all(color: borderColor, width: borderWidth),
          ),
          child: Row(
            mainAxisSize: .min,
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                horizontalMargin6,
              ],
              Text(
                widget.label,
                style: theme.caption.copyWith(
                  color: fgColor,
                  fontWeight: widget.isSelected ? .bold : .normal,
                ),
              ),
              if (widget.trailing != null) ...[
                horizontalMargin6,
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
