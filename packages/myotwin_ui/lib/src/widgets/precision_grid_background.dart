import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

class PrecisionGridBackground extends StatelessWidget {
  final Offset offset;

  const PrecisionGridBackground({
    super.key,
    this.offset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _PrecisionGridPainter(
          offset: offset,
          backgroundColor: theme.surface,
          // We drop the base opacity so the grid sits deep in the background
          minorLineColor: theme.outlineDim.withOpacity(0.4),
          majorLineColor: theme.outline.withOpacity(0.8),
        ),
      ),
    );
  }
}

class _PrecisionGridPainter extends CustomPainter {
  final Offset offset;
  final Color backgroundColor;
  final Color minorLineColor;
  final Color majorLineColor;

  // Configuration for the "finer" pi.dev aesthetic
  final double gridSpacing = 12.0;
  final int majorLineInterval = 8;

  _PrecisionGridPainter({
    required this.offset,
    required this.backgroundColor,
    required this.minorLineColor,
    required this.majorLineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Fill the deep mechatronic void
    canvas.drawColor(backgroundColor, BlendMode.src);

    final Rect bounds = Offset.zero & size;

    // 2. The Secret Sauce: GPU Radial Gradient Shaders
    // This creates the "fade to darkness" effect at the edges of the screen.
    final Shader minorShader = RadialGradient(
      center: Alignment.center,
      radius: 0.85, // Controls how far the grid extends before vanishing
      colors: [
        minorLineColor,
        minorLineColor.withOpacity(0.0), // Fades to pure transparent
      ],
      stops: const [0.3, 1.0], // Stays solid for the middle 30%, then fades
    ).createShader(bounds);

    final Shader majorShader = RadialGradient(
      center: Alignment.center,
      radius: 0.85,
      colors: [
        majorLineColor,
        majorLineColor.withOpacity(0.0),
      ],
      stops: const [0.3, 1.0],
    ).createShader(bounds);

    // 3. Attach the shaders to the paint objects
    final Paint minorPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = minorShader;

    final Paint majorPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = majorShader;

    // 4. Center-aligned tracking math
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final double originX = centerX + offset.dx;
    final double originY = centerY + offset.dy;

    final double startX = originX % gridSpacing;
    final double startY = originY % gridSpacing;

    // 5. Render Vertical Lines
    for (double x = startX; x < size.width; x += gridSpacing) {
      final int lineIndex = ((x - originX) / gridSpacing).round();
      final bool isMajor = lineIndex % majorLineInterval == 0;

      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        isMajor ? majorPaint : minorPaint,
      );
    }

    // 6. Render Horizontal Lines
    for (double y = startY; y < size.height; y += gridSpacing) {
      final int lineIndex = ((y - originY) / gridSpacing).round();
      final bool isMajor = lineIndex % majorLineInterval == 0;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        isMajor ? majorPaint : minorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PrecisionGridPainter oldDelegate) {
    return oldDelegate.offset != offset ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.minorLineColor != minorLineColor ||
        oldDelegate.majorLineColor != majorLineColor;
  }
}
