import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A button that uses a [MyoIcon] as its primary visual, featuring a
/// holographic glitch effect on interaction.
class MyoIconButton extends StatefulWidget {
  /// Creates a [MyoIconButton].
  const MyoIconButton({
    super.key,
    this.behavior = .deferToChild,
    required this.onPressed,
    required this.intent,
    this.fallbackIntent,
    this.enabled = true,
    this.size = spacing24,
    this.color,
  });

  /// Optional hit test behavior.
  final HitTestBehavior behavior;

  /// Callback invoked when the button is pressed.
  final VoidCallback onPressed;

  /// The primary semantic concept for the icon.
  final String intent;

  /// A safer, more generic backup concept.
  final String? fallbackIntent;

  /// Whether the button is enabled.
  final bool enabled;

  /// The size of the icon and the button surface.
  final double size;

  /// The color of the icon. Defaults to the theme's onSurface color.
  final Color? color;

  @override
  State<MyoIconButton> createState() => _MyoIconButtonState();
}

class _MyoIconButtonState extends State<MyoIconButton> with SingleTickerProviderStateMixin, HoloGlitchTickerMixin {
  @override
  void didUpdateWidget(covariant MyoIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger glitch on enabled/disabled transition
    if (oldWidget.enabled != widget.enabled) {
      triggerGlitch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    // Visual tokens based on state
    final backgroundColor = widget.enabled ? theme.surfaceElevated : theme.surface;
    final borderColor = widget.enabled ? theme.outline : theme.outlineDim;
    final iconColor = widget.color ?? (widget.enabled ? theme.onSurface : theme.onSurfaceDim);

    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.enabled
          ? () {
              triggerGlitch();
              widget.onPressed();
            }
          : null,
      child: HoloGlitch(
        phase: glitchPhase,
        intensity: glitchIntensity,
        severity: widget.enabled ? 0.2 : 0.05,
        child: Padding(
          // Consistent padding to prevent clipping during glitch
          padding: allPadding16,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: theme.radiusSm,
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Center(
              child: MyoIcon(
                intent: widget.intent,
                fallbackIntent: widget.fallbackIntent,
                color: iconColor,
                size: widget.size * 0.6, // Scale icon relative to button size
              ),
            ),
          ),
        ),
      ),
    );
  }
}
