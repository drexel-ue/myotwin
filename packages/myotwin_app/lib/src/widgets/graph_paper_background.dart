import 'package:flutter/material.dart';

/// A full-viewport graph paper / grid background for canvas-based UIs.
///
/// Renders an infinite repeating grid using [CustomPainter] and wraps it in
/// a [RepaintBoundary] so panning/zooming the canvas it's placed on does not
/// trigger unnecessary repaints of the rest of the tree.
///
/// ### Design Tokens
/// | Parameter | Default | Meaning |
/// |---|---|---|
/// | [backgroundColor] | `0xFF0A0A0A` | MyoTwin surface token |
/// | [gridSpacing] | `24.0` | Base pixel spacing (24×24 square) |
/// | [minorLineColor] | `0xFF141414` | Lighter, faint grid lines |
/// | [majorLineColor] | `0xFF222222` | Darker every-Nth line |
/// | [majorLineInterval] | `5` | Draw a major line every 5th square |
class GraphPaperBackground extends StatelessWidget {
  /// Creates an infinite graph-paper grid background.
  ///
  /// The grid repeats seamlessly in all directions and is panning-aware
  /// through [offset], which shifts the grid so it visually tracks a
  /// viewport/zoom camera.
  ///
  /// Example:
  /// ```dart
  /// GraphPaperBackground(
  ///   offset: panOffset,
  ///   gridSpacing: 24.0,
  ///   majorLineInterval: 5,
  /// )
  /// ```
  const GraphPaperBackground({
    super.key,
    this.offset = .zero,
    this.gridSpacing = 24.0, // Aligns with your 24x24 design token spec
    this.majorLineInterval = 5, // A thicker line every 5th square
    this.backgroundColor = const Color(0xFF0A0A0A), // MyoTwin surface token
    this.minorLineColor = const Color(0xFF141414), // Subtle minor lines
    this.majorLineColor = const Color(0xFF222222), // Explicit major dividers
  });

  /// Panning offset applied to the grid origin (default [Offset.zero]).
  final Offset offset;

  /// Spacing between adjacent grid lines in logical pixels (default `24.0`).
  final double gridSpacing;

  /// Draw a thicker line every N grid cells (default `5`).
  final int majorLineInterval;

  /// Background colour behind the grid (default MyoTwin surface `0xFF0A0A0A`).
  final Color backgroundColor;

  /// Colour for the common (minor) grid lines (default `0xFF141414`).
  final Color minorLineColor;

  /// Colour for the periodic (major) grid lines (default `0xFF222222`).
  final Color majorLineColor;

  /// Builds an infinite-sized [RepaintBoundary] > [CustomPaint] layer.
  ///
  /// Placed behind other content to give a subtle, repeating graph-paper
  /// backdrop that moves with the camera/viewport offset.
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

/// CustomPainter that renders the repeating graph paper grid.
///
/// The grid origin is anchored at the center of the viewport; [offset] shifts
/// the grid to simulate panning without ever clipping — the pattern is
/// periodic so it can extend "infinitely" in all directions.
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

  /// Panning offset applied to the grid origin.
  final Offset offset;

  /// Distance between adjacent grid lines in logical pixels.
  final double gridSpacing;

  /// Draw a thicker line every N grid cells.
  final int majorLineInterval;

  /// Solid fill colour for the background behind the grid.
  final Color backgroundColor;

  /// Prepared [Paint] for minor (every-cell) grid lines.
  final Paint minorPaint;

  /// Prepared [Paint] for major (every-Nth-cell) grid lines.
  final Paint majorPaint;

  /// Draws the repeating graph paper grid.
  ///
  /// 1. Fills the canvas with [backgroundColor].
  /// 2. Computes the viewport centre and projects the panning [offset]
  ///    to determine the grid's visual origin.
  /// 3. Uses modulo to find the first grid line within the viewport bounds.
  /// 4. Iterates across X and Y, drawing minor lines every cell and
  ///    major lines every [majorLineInterval] cells.
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

  /// Returns `true` when any visual property has changed.
  ///
  /// Compares all colour and spacing parameters. [offset] is omitted from
  /// repaint checks — panning is handled through the animation loop, not
  /// through the widget tree, so we skip it here to reduce churn.
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
