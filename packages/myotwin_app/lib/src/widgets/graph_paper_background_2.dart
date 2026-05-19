import 'package:flutter/material.dart';

class GraphPaperBackground extends StatelessWidget {
  const GraphPaperBackground({
    super.key,
    this.offset = Offset.zero,
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
        size: Size.infinite,
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
  final Offset offset;
  final double gridSpacing;
  final int majorLineInterval;
  final Color backgroundColor;
  final Paint minorPaint;
  final Paint majorPaint;

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
         ..style = PaintingStyle.stroke,
       majorPaint = Paint()
         ..color = majorLineColor
         ..strokeWidth =
             1.5 // Extra thickness for mathematical anchoring
         ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Establish background canvas surface
    canvas.drawColor(backgroundColor, BlendMode.src);

    // 2. Adjust for runtime tracking offsets (scrolling/panning)
    final double startX = offset.dx % (gridSpacing * majorLineInterval);
    final double startY = offset.dy % (gridSpacing * majorLineInterval);

    // 3. Draw Vertical Infrastructure
    for (double x = startX - (gridSpacing * majorLineInterval); x < size.width; x += gridSpacing) {
      if (x < 0) continue;

      // Compute line tracking index relative to origin matrix
      final int lineIndex = ((x - offset.dx) / gridSpacing).round();
      final bool isMajor = lineIndex % majorLineInterval == 0;

      canvas.drawLine(Offset(x, 0), Offset(x, size.height), isMajor ? majorPaint : minorPaint);
    }

    // 4. Draw Horizontal Infrastructure
    for (double y = startY - (gridSpacing * majorLineInterval); y < size.height; y += gridSpacing) {
      if (y < 0) continue;

      final int lineIndex = ((y - offset.dy) / gridSpacing).round();
      final bool isMajor = lineIndex % majorLineInterval == 0;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), isMajor ? majorPaint : minorPaint);
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
