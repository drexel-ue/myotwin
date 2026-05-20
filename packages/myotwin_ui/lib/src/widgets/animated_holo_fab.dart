import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myotwin_ui/src/theme/myotwin_theme.dart';

/// States that control the FAB's animation speed and glow intensity.
enum HoloState {
  /// Slow standby rotation with dim glow.
  idle,

  /// Fast processing rotation with half-brightness glow.
  thinking,

  /// Steady powerful rotation with full-brightness glow.
  active,
}

/// An animated holographic FAB with three states: idle, thinking, and active.
///
/// The button features a rotating arc border and a moving scanline shader
/// that responds to the provided [state]. In [HoloState.idle] the FAB
/// rotates slowly at reduced brightness; in [HoloState.thinking] it spins
/// rapidly at half brightness; in [HoloState.active] it reaches full speed
/// and maximum glow.
class AnimatedHoloFAB extends StatefulWidget {
  /// Creates an animated holographic FAB.
  ///
  /// The [state], [onPressed], and [icon] parameters are required. If
  /// [baseColor] is null the FAB uses the theme's white color.
  const AnimatedHoloFAB({
    super.key,

    /// The current animation state driving speed and glow.
    required this.state,

    /// Callback invoked when the FAB is pressed.
    required this.onPressed,

    /// The icon widget displayed inside the FAB.
    required this.icon,

    /// The base color for borders, scanline, and glow. Defaults to the
    /// theme's [MyoTwinTheme.white] when null.
    this.baseColor,
  });

  /// The current animation state driving speed and glow.
  final HoloState state;

  /// Callback invoked when the FAB is pressed.
  final VoidCallback onPressed;

  /// The icon widget displayed inside the FAB.
  final Widget icon;

  /// The base color for borders, scanline, and glow. Defaults to the
  /// theme's white when null.
  final Color? baseColor;

  @override
  State<AnimatedHoloFAB> createState() => _AnimatedHoloFABState();
}

class _AnimatedHoloFABState extends State<AnimatedHoloFAB> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _lastTime = .zero;

  // The engine variables
  double _phase = 0.0; // Loops continuously from 0.0 to 1.0
  double _currentSpeed = 0.3; // Current cycles per second
  double _visualIntensity = 0.0; // 0.0 = Idle (Dim), 1.0 = Active (Bright)

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

    // 1. Define physical targets based on the ternary state machine
    double targetSpeed;
    double targetIntensity;

    switch (widget.state) {
      case .idle:
        targetSpeed = 0.25; // Slow standby rotation
        targetIntensity = 0.0;
      case .thinking:
        targetSpeed = 3.5; // Very fast "searching/processing" spin
        targetIntensity = 0.5; // Half-brightness to indicate spooling
      case .active:
        targetSpeed = 1.5; // Powerful, steady rhythm
        targetIntensity = 1.0; // Locked in at max brightness
    }

    // 2. The friction math seamlessly handles jumping between ANY of the 3 states
    _currentSpeed += (targetSpeed - _currentSpeed) * 8.0 * dt;
    _visualIntensity += (targetIntensity - _visualIntensity) * 8.0 * dt;

    // 3. Accumulate continuous phase
    _phase += dt * _currentSpeed;
    _phase %= 1.0;

    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rotation = _phase * 2 * math.pi;
    final scanlineOffset = (_phase * 2) - 1.0;

    // FIX 1: Normalize the sine wave so it pulses cleanly between 0.0 and 1.0
    final normalizedPulse = (math.sin(_phase * 2 * math.pi) + 1.0) / 2.0;

    final baseColor = widget.baseColor ?? context.myoTheme.white;

    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: 64.0,
        height: 64.0,
        decoration: BoxDecoration(
          shape: .circle,
          color: context.myoTheme.surface,
          boxShadow: [
            BoxShadow(
              // FIX 2: Clamp the final opacity calculation to guarantee it never breaches 0.0 - 1.0
              color: baseColor.withValues(
                alpha: (0.1 + (0.2 * normalizedPulse) + (0.4 * _visualIntensity)).clamp(0.0, 1.0),
              ),
              blurRadius: 10.0 + (10.0 * normalizedPulse) + (15.0 * _visualIntensity),
              spreadRadius: 1.0 + (3.0 * _visualIntensity * normalizedPulse),
            ),
          ],
        ),
        child: Stack(
          alignment: .center,
          children: [
            Transform.rotate(
              angle: rotation,
              child: CustomPaint(
                size: const Size.square(64.0),
                painter: _HoloArcPainter(
                  color: baseColor,
                  intensity: _visualIntensity,
                ),
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment(0.0, scanlineOffset - 0.5),
                  end: Alignment(0.0, scanlineOffset + 0.5),
                  colors: [
                    context.myoTheme.white.withValues(alpha: 0.2),
                    // Clamp shader opacities as well
                    context.myoTheme.white.withValues(alpha: (0.2 + (0.8 * _visualIntensity)).clamp(0.0, 1.0)),
                    context.myoTheme.white.withValues(alpha: 0.2),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(bounds);
              },
              blendMode: .srcIn,
              child: widget.icon,
            ),
          ],
        ),
      ),
    );
  }
}

class _HoloArcPainter extends CustomPainter {
  _HoloArcPainter({
    required this.color,
    required this.intensity,
  });

  final Color color;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Clamp outer arcs
    final outerPaint = Paint()
      ..color = color.withValues(alpha: (0.4 + (0.6 * intensity)).clamp(0.0, 1.0))
      ..style = .stroke
      ..strokeWidth = 2.5
      ..strokeCap = .square;

    canvas
      ..drawArc(rect, 0, math.pi / 2, false, outerPaint)
      ..drawArc(rect, math.pi, math.pi / 2, false, outerPaint);

    // Clamp inner ring
    final innerPaint = Paint()
      ..color = color.withValues(alpha: (0.2 + (0.3 * intensity)).clamp(0.0, 1.0))
      ..style = .stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius - 6.0, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _HoloArcPainter oldDelegate) {
    return color != oldDelegate.color || intensity != oldDelegate.intensity;
  }
}
