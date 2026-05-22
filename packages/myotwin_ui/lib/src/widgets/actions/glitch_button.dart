import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

class _GlitchButtonState extends State<GlitchButton> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _lastTime = .zero;

  double _phase = 0.0;
  double _glitchIntensity = 0.0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start().ignore();
  }

  void _onTick(Duration elapsed) {
    if (_lastTime == .zero) {
      _lastTime = elapsed;
      return;
    }

    final dt = (elapsed - _lastTime).inMicroseconds / 1000000.0;
    _lastTime = elapsed;

    // Decay glitch intensity over time
    if (_glitchIntensity > 0.0) {
      setState(() {
        _glitchIntensity = math.max(0.0, _glitchIntensity - (dt * 3.0));
      });
    }

    // Drive the shader noise seed
    setState(() {
      _phase += dt * 0.5;
      _phase %= 1.0;
    });
  }

  void _triggerGlitch() {
    setState(() {
      _glitchIntensity = 1.0;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GlitchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger glitch on enabled/disabled transition
    if (oldWidget.enabled != widget.enabled) {
      _triggerGlitch();
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
              _triggerGlitch();
              widget.onPressed();
            }
          : null,
      child: HoloGlitch(
        phase: _phase,
        intensity: _glitchIntensity,
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
