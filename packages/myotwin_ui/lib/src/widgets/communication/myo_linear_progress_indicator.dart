import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// Visual styles for [MyoLinearProgressIndicator].
enum MyoLinearProgressStyle {
  /// Standard white progress bar.
  white,

  /// Error red progress bar.
  error,
}

/// A cyberpunk-style linear progress indicator.
///
/// Supports both specific progress tracking and infinite looping.
/// Triggers glitch effects on significant progress jumps or completion.
class MyoLinearProgressIndicator extends StatefulWidget {
  /// Creates a [MyoLinearProgressIndicator].
  const MyoLinearProgressIndicator({
    super.key,
    this.progress,
    this.style = .white,
    this.height = 2.0,
  });

  /// The current progress (0.0 to 1.0).
  /// If null, the indicator will loop infinitely.
  final double? progress;

  /// The visual style of the indicator.
  final MyoLinearProgressStyle style;

  /// Desired height of the progress bar.
  final double height;

  @override
  State<MyoLinearProgressIndicator> createState() => _MyoLinearProgressIndicatorState();
}

class _MyoLinearProgressIndicatorState extends State<MyoLinearProgressIndicator>
    with TickerProviderStateMixin, HoloGlitchTickerMixin<MyoLinearProgressIndicator> {
  late AnimationController _controller;
  double _lastTriggeredValue = -1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Base duration for looping
    );

    _updateAnimationState();

    _controller.addListener(_handleAnimationUpdate);
  }

  void _updateAnimationState() {
    if (widget.progress == null) {
      // Infinite looping
      _controller.duration = const Duration(milliseconds: 2000);
      _controller.repeat().ignore();
    } else {
      // Specific progress
      _controller.duration = const Duration(milliseconds: 400); // Use a motion token logically
      unawaited(
        _controller.animateTo(
          widget.progress!.clamp(0.0, 1.0),
          curve: Curves.easeOut,
        ),
      );
    }
  }

  void _handleAnimationUpdate() {
    // Trigger glitch when hitting 100%
    if (_controller.value >= 1.0 && _lastTriggeredValue < 1.0) {
      triggerGlitch();
      _lastTriggeredValue = 1.0;
    } else if (_controller.value < 0.9) {
      _lastTriggeredValue = _controller.value;
    }
  }

  @override
  void didUpdateWidget(covariant MyoLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 1. Handle transition between looping and fixed progress
    if ((oldWidget.progress == null) != (widget.progress == null)) {
      _updateAnimationState();
    }
    // 2. Handle progress value changes
    else if (widget.progress != null && oldWidget.progress != null) {
      final diff = (widget.progress! - oldWidget.progress!).abs();
      if (diff >= 0.1) {
        triggerGlitch();
      }
      unawaited(
        _controller.animateTo(
          widget.progress!.clamp(0.0, 1.0),
          duration: const Duration(milliseconds: 250), // motionNormal
          curve: Curves.easeOut,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    final progressColor = widget.style == .error ? theme.error : theme.white;

    final trackColor = widget.style == .error ? theme.error.withValues(alpha: 0.2) : theme.outline;

    return HoloGlitch(
      phase: glitchPhase,
      intensity: glitchIntensity,
      severity: 0.3,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            height: widget.height,
            width: .infinity,
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: .circular(theme.radiusSm.topLeft.x), // small rounding
            ),
            clipBehavior: .antiAlias,
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: _controller.value,
                  heightFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: progressColor,
                      boxShadow: [
                        if (widget.style == .white)
                          BoxShadow(
                            color: theme.white.withValues(alpha: 0.5),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
