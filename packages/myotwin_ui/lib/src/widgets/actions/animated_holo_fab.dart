import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// States that control the FAB's animation speed and glow intensity.
enum HoloState {
  /// Slow standby rotation with dim glow.
  idle,

  /// Rotation braked to a stop with a solid, receptive baseline glow.
  listening,

  /// Fast processing rotation with half-brightness glow.
  thinking,

  /// Steady powerful rotation with full-brightness glow.
  active,
}

/// An animated holographic FAB with a multi-phase mechanical state machine.
class AnimatedHoloFAB extends StatefulWidget {
  /// Creates an [AnimatedHoloFAB].
  const AnimatedHoloFAB({
    super.key,
    required this.state,
    required this.onPressed,
    required this.icon,
    this.baseColor,
  });

  /// The current animation state controlling speed and glow intensity.
  final HoloState state;

  /// Callback invoked when the FAB is pressed.
  final VoidCallback onPressed;

  /// The icon widget displayed at the center of the FAB.
  final Widget icon;

  /// Optional base color for the glow; defaults to the theme's white.
  final Color? baseColor;

  @override
  State<AnimatedHoloFAB> createState() => _AnimatedHoloFABState();
}

class _AnimatedHoloFABState extends State<AnimatedHoloFAB> with SingleTickerProviderStateMixin, HoloGlitchLogicMixin {
  late final Ticker _ticker;
  Duration _lastTime = .zero;

  // The engine variables
  double _phase = 0.0;
  double _currentSpeed = 0.3;
  double _visualIntensity = 0.0;
  double _currentSeverity = 0.1;
  double _pulseMultiplier = 1.0;

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

    double targetSpeed;
    double targetIntensity;
    double targetSeverity;
    var targetPulse = 1.0;
    var glitchChance = 0.0;

    switch (widget.state) {
      case .idle:
        targetSpeed = 0.25;
        targetIntensity = 0.0;
        targetSeverity = 0.1;
        glitchChance = 0.005;
        targetPulse = 1.0;
      case .listening:
        targetSpeed = 0.8;
        targetIntensity = 0.5;
        targetSeverity = 0.0;
        glitchChance = 0.001;
        targetPulse = 0.0;
      case .thinking:
        targetSpeed = 3.5;
        targetIntensity = 0.8;
        targetSeverity = 0.5;
        glitchChance = 0.025;
        targetPulse = 0.0;
      case .active:
        targetSpeed = 1.5;
        targetIntensity = 1.0;
        targetSeverity = 1.0;
        glitchChance = 0.08;
        targetPulse = 1.0;
    }

    _currentSpeed += (targetSpeed - _currentSpeed) * 8.0 * dt;
    _visualIntensity += (targetIntensity - _visualIntensity) * 8.0 * dt;
    _currentSeverity += (targetSeverity - _currentSeverity) * 8.0 * dt;
    _pulseMultiplier += (targetPulse - _pulseMultiplier) * 8.0 * dt;

    if (math.Random().nextDouble() < glitchChance) {
      triggerGlitch();
    }

    updateGlitchState(dt);

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
    final normalizedPulse = ((math.sin(_phase * 2 * math.pi) + 1.0) / 2.0) * _pulseMultiplier;
    final baseColor = widget.baseColor ?? context.myoTheme.white;

    return GestureDetector(
      onTap: widget.onPressed,
      // The extracted optical layer
      child: HoloGlitch(
        phase: glitchPhase,
        intensity: glitchIntensity,
        severity: _currentSeverity,
        // The padding is preserved here inside the sampler to prevent bounds clipping
        child: Padding(
          padding: allPadding64,
          child: Container(
            width: spacing64,
            height: spacing64,
            decoration: BoxDecoration(
              shape: .circle,
              color: context.myoTheme.surface,
              boxShadow: [
                BoxShadow(
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
                    size: const Size.square(spacing64),
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

    final outerPaint = Paint()
      ..color = color.withValues(alpha: (0.4 + (0.6 * intensity)).clamp(0.0, 1.0))
      ..style = .stroke
      ..strokeWidth = 2.5
      ..strokeCap = .square;

    canvas
      ..drawArc(rect, 0, math.pi / 2, false, outerPaint)
      ..drawArc(rect, math.pi, math.pi / 2, false, outerPaint);

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
