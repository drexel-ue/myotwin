import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedHoloFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final Color activeColor;

  const AnimatedHoloFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    this.activeColor = Colors.cyanAccent, // Holographic default
  });

  @override
  State<AnimatedHoloFAB> createState() => _AnimatedHoloFABState();
}

class _AnimatedHoloFABState extends State<AnimatedHoloFAB> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // The master timeline: 1.5 seconds for a complete rotation and scan cycle
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(); // Loops infinitely just like the video
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      // AnimatedBuilder rebuilds ONLY this specific button every frame (120fps safe)
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // 1. ROTATION: Maps 0.0 -> 1.0 to a full 360 degrees (2 * Pi)
          final rotation = _controller.value * 2 * math.pi;

          // 2. SCANLINE: Maps 0.0 -> 1.0 to an offset moving from top (-1.0) to bottom (1.0)
          final scanlineOffset = (_controller.value * 2) - 1.0;

          // 3. GLOW PULSE: Uses a sine wave to create a smooth breathing effect
          final pulse = math.sin(_controller.value * math.pi);

          return Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black87, // Deep core to make the glow pop
              boxShadow: [
                BoxShadow(
                  // The glow expands and brightens based on the sine wave pulse
                  color: widget.activeColor.withOpacity(0.2 + (0.3 * pulse)),
                  blurRadius: 15.0 + (10.0 * pulse),
                  spreadRadius: 2.0 * pulse,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // --- LAYER 1: The Rotating Mechanical Arcs ---
                Transform.rotate(
                  angle: rotation,
                  child: CustomPaint(
                    size: const Size(64, 64),
                    painter: _HoloArcPainter(color: widget.activeColor),
                  ),
                ),

                // --- LAYER 2: The Moving Scanline Mask ---
                // This shader applies a moving bright band across whatever icon you pass in
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment(0.0, scanlineOffset - 0.5),
                      end: Alignment(0.0, scanlineOffset + 0.5),
                      colors: [
                        Colors.white.withOpacity(0.2), // Dim leading edge
                        Colors.white, // Bright scanline core
                        Colors.white.withOpacity(0.2), // Dim trailing edge
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcIn,
                  child: widget.icon,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Draws the physical geometry of the spinning FAB border
class _HoloArcPainter extends CustomPainter {
  final Color color;

  _HoloArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4.0; // Inset slightly from the very edge
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. The Thick Outer Tracking Arcs
    final outerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.square; // Square caps give it that rigid, technical feel

    // Draw two symmetrical arcs (90 degrees each) opposite each other
    canvas.drawArc(rect, 0, math.pi / 2, false, outerPaint);
    canvas.drawArc(rect, math.pi, math.pi / 2, false, outerPaint);

    // 2. The Thin Inner Precision Ring
    final innerPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius - 6.0, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _HoloArcPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
