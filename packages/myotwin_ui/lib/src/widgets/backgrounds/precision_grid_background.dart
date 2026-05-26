import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A GPU-rendered precision-grid background with radial fade-to-darkness.
class PrecisionGridBackground extends StatelessWidget {
  /// Creates a GPU-rendered precision-grid background with radial fade-to-darkness.
  const PrecisionGridBackground({
    super.key,
    this.offset = .zero,
  });

  /// The grid offset applied to the canvas, supporting panning.
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return RepaintBoundary(
      child: CustomPaint(
        size: .infinite,
        painter: _PrecisionGridPainter(
          offset: offset,
          backgroundColor: theme.surface,
          // We drop the base opacity so the grid sits deep in the background
          minorLineColor: theme.outlineDim.withValues(alpha: 0.4),
          majorLineColor: theme.outline.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class _PrecisionGridPainter extends CustomPainter {
  _PrecisionGridPainter({
    required this.offset,
    required this.backgroundColor,
    required this.minorLineColor,
    required this.majorLineColor,
  });

  final Offset offset;
  final Color backgroundColor;
  final Color minorLineColor;
  final Color majorLineColor;

  // Configuration for the "finer" pi.dev aesthetic
  final double gridSpacing = 12.0;
  final int majorLineInterval = 8;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Fill the deep mechatronic void
    canvas.drawColor(backgroundColor, .src);

    final bounds = Offset.zero & size;

    // 2. The Secret Sauce: GPU Radial Gradient Shaders
    // This creates the "fade to darkness" effect at the edges of the screen.
    final minorShader = RadialGradient(
      radius: 0.85, // Controls how far the grid extends before vanishing
      colors: [
        minorLineColor,
        minorLineColor.withValues(alpha: 0.0), // Fades to pure transparent
      ],
      stops: const [0.3, 1.0], // Stays solid for the middle 30%, then fades
    ).createShader(bounds);

    final majorShader = RadialGradient(
      radius: 0.85,
      colors: [
        majorLineColor,
        majorLineColor.withValues(alpha: 0.0),
      ],
      stops: const [0.3, 1.0],
    ).createShader(bounds);

    // 3. Attach the shaders to the paint objects
    final minorPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = minorShader;

    final majorPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = majorShader;

    // 4. Center-aligned tracking math
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final originX = centerX + offset.dx;
    final originY = centerY + offset.dy;

    final startX = originX % gridSpacing;
    final startY = originY % gridSpacing;

    // 5. Render Vertical Lines
    for (var x = startX; x < size.width; x += gridSpacing) {
      final lineIndex = ((x - originX) / gridSpacing).round();
      final isMajor = lineIndex % majorLineInterval == 0;

      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        isMajor ? majorPaint : minorPaint,
      );
    }

    // 6. Render Horizontal Lines
    for (var y = startY; y < size.height; y += gridSpacing) {
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
  bool shouldRepaint(covariant _PrecisionGridPainter oldDelegate) {
    return oldDelegate.offset != offset ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.minorLineColor != minorLineColor ||
        oldDelegate.majorLineColor != majorLineColor;
  }
}
