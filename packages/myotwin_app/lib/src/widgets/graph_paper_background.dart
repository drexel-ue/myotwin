import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A full-screen, [pi.dev](https://pi.dev)-inspired background with:
///
///  1. Solid base colour
///  2. Subtle graph-paper grid + cross-dots (single `CustomPainter` pass)
///  3. Edge vignette via radial gradient
///  4. Crooked perspective tilt that animates to flat on first load
///
/// Usage — place it as the lowest child in a [Stack]:
///
/// ```dart
/// Stack(
///   children: [
///     const GraphPaperBackground(),
///     // ...your widgets…
///   ],
/// )
/// ```
class GraphPaperBackground extends StatefulWidget {
  /// Creates a const [GraphPaperBackground].
  const GraphPaperBackground({
    super.key,
    required this.animationDuration,
  });

  /// Duration of the crooked→flat tilt animation.
  final Duration animationDuration;

  @override
  State<GraphPaperBackground> createState() => _GraphPaperBackgroundState();
}

// ── State & Animation ───────────────────────────────────────────────

class _GraphPaperBackgroundState extends State<GraphPaperBackground> with TickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
    value: 1.0, // starts tilted
  );
  late final Animation<double> _angleY;
  late final Animation<double> _angleX;
  late final Animation<double> _scale;
  late final Animation<double> _translateX;

  bool _isDark(BuildContext ctx) => Theme.of(ctx).brightness == .dark;

  @override
  void initState() {
    super.initState();
    _angleY = Tween<double>(begin: 1.2, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _angleX = Tween<double>(begin: -0.4, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 1.03, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _translateX = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(_translateX.value) // translateX
            ..rotateY(_angleY.value * 0.08) // Y rotation
            ..rotateX(_angleX.value * 0.05) // X rotation
            ..scale(_scale.value), // slight scale
          child: Container(
            width: .infinity,
            height: .infinity,
            color: _isDark(context) ? Colors.black : const Color(0xFFF5F2ED),
            child: const Stack(
              fit: .passthrough,
              children: [
                // Grid (single paint pass)
                CustomPaint(
                  painter: _GridPainter(),
                ),
                // Vignette overlay
                CustomPaint(
                  painter: _VignettePainter(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Grid + Cross-dots ───────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas c, Size s) {
    final minor = Paint()
      ..color = const Color(0xFFC8D0D9)
          .withAlpha(0x03) // ~0.9%
      ..strokeWidth = 0.5;
    final major = Paint()
      ..color = const Color(0xFFC8D0D9)
          .withAlpha(0x08) // ~2.6%
      ..strokeWidth = 0.5;
    final dotFill = Paint()
      ..color = const Color(0xFFC8D0D9)
          .withAlpha(0x13) // ~4.3%
      ..style = PaintingStyle.fill;
    final dotErase = Paint()
      ..color = Colors
          .black // matches dark bg; use bg colour for light mode
      ..style = PaintingStyle.fill;

    const bgErase = Color(0xFFF5F2ED); // light-mode erase colour
    const bgColour = Colors.black;
    final erase = Paint()
      ..color = bgColour
      ..style = PaintingStyle.fill;

    // minor grid — every 4 px
    for (double y = 0; y < s.height + 4; y += 4) {
      c.drawLine(Offset(0, y), Offset(s.width, y), minor);
    }
    for (double x = 0; x < s.width + 4; x += 4) {
      c.drawLine(Offset(x, 0), Offset(x, s.height), minor);
    }
    // major grid — every 20 px
    for (double y = 0; y < s.height + 20; y += 20) {
      c.drawLine(Offset(0, y), Offset(s.width, y), major);
    }
    for (double x = 0; x < s.width + 20; x += 20) {
      c.drawLine(Offset(x, 0), Offset(x, s.height), major);
    }
    // cross-dots at major intersections
    for (double y = 0; y < s.height; y += 20) {
      for (double x = 0; x < s.width; x += 20) {
        c
          ..drawCircle(Offset(x, y), 3.0, dotFill)
          // erase centre to leave a ring (matches pi.dev trick)
          ..drawCircle(Offset(x, y), 1.5, erase);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Vignette ────────────────────────────────────────────────────────

class _VignettePainter extends CustomPainter {
  const _VignettePainter();

  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;
    final radius = math.sqrt(s.width * s.width + s.height * s.height) * 0.5;

    final grad = RadialGradient(
      center: const Alignment(0, -0.15), // slight top bias like pi.dev
      radius: 1.1,
      colors: [
        Colors.transparent,
        const Color(0xFF0D1116).withAlpha(0x1C), // ~12% dark edge
      ],
      stops: const [0.45, 1.0],
    );
    c.drawPaint(Paint()..shader = grad.createShader(Rect.fromLTWH(0, 0, s.width, s.height)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
