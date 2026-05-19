import 'package:flutter/material.dart';

class GraphPaperBackground extends StatelessWidget {
  const GraphPaperBackground({
    super.key,
    this.offset = .zero,
    this.gridSpacing = 24.0, // Aligns with your 24x24 design token spec
    this.majorLineInterval = 5, // A thicker line every 5th square
    this.backgroundColor = const Color(0xFF0A0A0A), // MyoTwin surface token
    this.minorLineColor = const Color(0xFF141414), // Subtle minor lines
    this.majorLineColor = const Color(0xFF222222), // Explicit major dividers
  });

  final Offset offset;
  final double gridSpacing;
  final int majorLineInterval;
  final Color backgroundColor;
  final Color minorLineColor;
  final Color majorLineColor;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: .infinite,
        painter: _GraphPaperPainter(
          offset: offset,
          gridSpacing: gridSpacing,
          majorLineInterval: majorLineInterval,
          backgroundColor: backgroundColor,
          minorLineColor: minorLineColor,
          majorLineColor: majorLineColor,
        ),
      ),
    );
  }
}

class _GraphPaperPainter extends CustomPainter {
  _GraphPaperPainter({
    required this.offset,
    required this.gridSpacing,
    required this.majorLineInterval,
    required this.backgroundColor,
    required Color minorLineColor,
    required Color majorLineColor,
  }) : minorPaint = Paint()
         ..color = minorLineColor
         ..strokeWidth = 1.0
         ..style = .stroke,
       majorPaint = Paint()
         ..color = majorLineColor
         ..strokeWidth =
             1.5 // Extra thickness for mathematical anchoring
         ..style = .stroke;

  final Offset offset;
  final double gridSpacing;
  final int majorLineInterval;
  final Color backgroundColor;
  final Paint minorPaint;
  final Paint majorPaint;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Establish background canvas surface
    canvas.drawColor(backgroundColor, .src);

    // 2. Calculate the geometric midpoint of the current viewport
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // 3. Project the panning offset from the center matrix anchor
    final originX = centerX + offset.dx;
    final originY = centerY + offset.dy;

    // 4. Compute wrapped starting boundaries using modulo tracking
    final startX = originX % gridSpacing;
    final startY = originY % gridSpacing;

    // 5. Draw Vertical Infrastructure
    for (var x = startX; x < size.width; x += gridSpacing) {
      // Determine structural index relative to the moving origin axis
      final lineIndex = ((x - originX) / gridSpacing).round();
      final isMajor = lineIndex % majorLineInterval == 0;

      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        isMajor ? majorPaint : minorPaint,
      );
    }

    // 6. Draw Horizontal Infrastructure
    for (var y = startY; y < size.height; y += gridSpacing) {
      // Determine structural index relative to the moving origin axis
      final lineIndex = ((y - originY) / gridSpacing).round();
      final isMajor = lineIndex % majorLineInterval == 0;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        isMajor ? majorPaint : minorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPaperPainter oldDelegate) {
    return oldDelegate.offset != offset ||
        oldDelegate.gridSpacing != gridSpacing ||
        oldDelegate.majorLineInterval != majorLineInterval ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.minorPaint.color != minorPaint.color ||
        oldDelegate.majorPaint.color != majorPaint.color;
  }
}
