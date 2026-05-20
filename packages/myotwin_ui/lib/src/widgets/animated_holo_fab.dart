import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum HoloState { idle, active }

class AnimatedHoloFAB extends StatefulWidget {
  final HoloState state;
  final VoidCallback onPressed;
  final Widget icon;
  final Color baseColor;

  const AnimatedHoloFAB({
    super.key,
    required this.state,
    required this.onPressed,
    required this.icon,
    this.baseColor = Colors.cyanAccent,
  });

  @override
  State<AnimatedHoloFAB> createState() => _AnimatedHoloFABState();
}

class _AnimatedHoloFABState extends State<AnimatedHoloFAB> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _lastTime = Duration.zero;

  // The engine variables
  double _phase = 0.0; // Loops continuously from 0.0 to 1.0
  double _currentSpeed = 0.3; // Current cycles per second
  double _visualIntensity = 0.0; // 0.0 = Idle (Dim), 1.0 = Active (Bright)

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (_lastTime == Duration.zero) {
      _lastTime = elapsed;
      return;
    }

    // Hardware-agnostic delta time calculation
    final double dt = (elapsed - _lastTime).inMicroseconds / 1000000.0;
    _lastTime = elapsed;

    // 1. Define physical targets based on the current enum state
    final double targetSpeed = widget.state == HoloState.active ? 1.5 : 0.25;
    final double targetIntensity = widget.state == HoloState.active ? 1.0 : 0.0;

    // 2. Apply smooth acceleration/deceleration (The "Spool Up" effect)
    // Multiplying by 8.0 dictates the transition friction.
    _currentSpeed += (targetSpeed - _currentSpeed) * 8.0 * dt;
    _visualIntensity += (targetIntensity - _visualIntensity) * 8.0 * dt;

    // 3. Accumulate continuous phase
    _phase += dt * _currentSpeed;
    _phase %= 1.0; // Keep it looping cleanly between 0.0 and 1.0

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

    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: 64.0,
        height: 64.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black87,
          boxShadow: [
            BoxShadow(
              // FIX 2: Clamp the final opacity calculation to guarantee it never breaches 0.0 - 1.0
              color: widget.baseColor.withOpacity(
                (0.1 + (0.2 * normalizedPulse) + (0.4 * _visualIntensity)).clamp(0.0, 1.0),
              ),
              blurRadius: 10.0 + (10.0 * normalizedPulse) + (15.0 * _visualIntensity),
              spreadRadius: 1.0 + (3.0 * _visualIntensity * normalizedPulse),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: rotation,
              child: CustomPaint(
                size: const Size(64, 64),
                painter: _HoloArcPainter(
                  color: widget.baseColor,
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
                    Colors.white.withOpacity(0.2),
                    // Clamp shader opacities as well
                    Colors.white.withOpacity((0.2 + (0.8 * _visualIntensity)).clamp(0.0, 1.0)),
                    Colors.white.withOpacity(0.2),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: widget.icon,
            ),
          ],
        ),
      ),
    );
  }
}

class _HoloArcPainter extends CustomPainter {
  final Color color;
  final double intensity;

  _HoloArcPainter({required this.color, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Clamp outer arcs
    final outerPaint = Paint()
      ..color = color.withOpacity((0.4 + (0.6 * intensity)).clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.square;

    canvas.drawArc(rect, 0, math.pi / 2, false, outerPaint);
    canvas.drawArc(rect, math.pi, math.pi / 2, false, outerPaint);

    // Clamp inner ring
    final innerPaint = Paint()
      ..color = color.withOpacity((0.2 + (0.3 * intensity)).clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius - 6.0, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _HoloArcPainter oldDelegate) {
    return color != oldDelegate.color || intensity != oldDelegate.intensity;
  }
}
