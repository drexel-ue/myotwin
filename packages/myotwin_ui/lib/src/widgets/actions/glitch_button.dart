import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A button with a holographic glitch effect that triggers on state transitions
/// and press events.
class GlitchButton extends StatefulWidget {
  /// Creates a [GlitchButton].
  const GlitchButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
    this.style,
  });

  /// Callback invoked when the button is pressed.
  final VoidCallback onPressed;

  /// The content of the button, typically a [Text] widget.
  final Widget child;

  /// Whether the button is enabled. Changing this value triggers a glitch effect.
  final bool enabled;

  /// Optional text style for the child. Defaults to [MyoTwinTheme.glitch].
  final TextStyle? style;

  @override
  State<GlitchButton> createState() => _GlitchButtonState();
}

class _GlitchButtonState extends State<GlitchButton> 
    with SingleTickerProviderStateMixin, HoloGlitchTickerMixin {

  @override
  void didUpdateWidget(covariant GlitchButton oldWidget) {
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

    final contentColor = widget.enabled ? theme.onSurface : theme.onSurfaceDim;

    // Default text style: use theme.glitch as the base for the "system" look
    final effectiveTextStyle =
        widget.style ??
        theme.glitch.copyWith(
          color: contentColor,
        );

    return GestureDetector(
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
        // Padding is required to prevent shader tearing from clipping
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: theme.radiusSm,
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: DefaultTextStyle(
                style: effectiveTextStyle,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
