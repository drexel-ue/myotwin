import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A holographic frosted-glass HUD panel with radiating laser effects.
class FrostedHUD extends StatelessWidget {
  /// Creates a holographic frosted-glass HUD panel with radiating laser effects.
  const FrostedHUD({
    super.key,
    /// Optional title text displayed in uppercase at the top of the panel.
    this.title,
    required this.child,
    /// Offset on the box edge where the tether physically touches (used for laser computation).
    required this.impactPoint,
    /// Normalized animation progress driving the laser spread and fade, from 0.0 to 1.0.
    this.animationProgress = 1.0,
  });

  /// The HUD title text.
  final String? title;
  /// The content widget displayed inside the HUD panel.
  final Widget child;
  /// Offset on the box edge where the tether physically touches (used for laser computation).
  final Offset impactPoint;
  /// Normalized animation progress driving the laser spread and fade, from 0.0 to 1.0.
  final double animationProgress;

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return ClipRRect(
      borderRadius: theme.radiusSm,
      child: BackdropFilter(
        // This is the "holographic" glass effect
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            // IMPORTANT: Lower the alpha so the window is semi-transparent
            color: theme.surfaceElevated.withValues(alpha: 0.6),
            border: Border.all(color: theme.outline),
            borderRadius: theme.radiusSm,
          ),
          child: CustomPaint(
            painter: _RadiatingHUDPainter(
              progress: animationProgress,
              impactPoint: impactPoint,
              strokeColor: theme.white,
              outlineColor: theme.outline,
            ),
            child: Padding(
              padding: allPadding16,
              child: Opacity(
                opacity: (animationProgress - 0.5).clamp(0.0, 0.5) / 0.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title case final String title when title.isNotEmpty) ...[
                      Text(title.toUpperCase(), style: theme.headlineMedium),
                      Divider(color: theme.outline, height: 16.0),
                    ],
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RadiatingHUDPainter extends CustomPainter {
  const _RadiatingHUDPainter({
    required this.progress,
    required this.impactPoint,
    required this.strokeColor,
    required this.outlineColor,
  });

  final double progress; // Driven by the Director's _windowAnimation [0.0 -> 1.0]
  final Offset impactPoint; // Where the tether physically touches the box edge (local coordinates)
  final Color strokeColor;
  final Color outlineColor;

  @override
  void paint(Canvas canvas, Size size) {
    // GUARD: If the layout engine passes an empty or uninitialized box size,
    // abort immediately to prevent Iterable metric-polling crashes.
    if (size.width <= 0.0 || size.height <= 0.0) return;

    // 1. Draw static inactive background guide line (outline-dim token)
    final backgroundPaint = Paint()
      ..color = outlineColor
      ..strokeWidth = 1.0
      ..style = .stroke;

    final fullRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(4.0), // radius-sm token
    );
    canvas.drawRRect(fullRect, backgroundPaint);

    if (progress <= 0.0) return;

    // 2. Setup the high-contrast laser brush
    final laserPaint = Paint()
      ..color = strokeColor
      ..strokeWidth = 1.0
      ..style = .stroke;

    // 3. Compute full perimeter sequence path
    // For absolute mechatronic accuracy, we map the box rectangle into a 1D line loop
    final structuralPath = Path()..addRRect(fullRect);
    final metricsList = structuralPath.computeMetrics().toList();

    if (metricsList.isEmpty) return;
    final metric = metricsList.first;
    final totalPerimeter = metric.length;

    // 4. Find where the impact point sits on that 1D path matrix
    // We project the local 2D coordinate to find its matching distance along the line string
    final impactDistance = _getDistanceOfPointOnPath(metric, impactPoint, totalPerimeter);

    // 5. Radiate outward in both directions simultaneously
    final halfSpread = (totalPerimeter / 2) * progress;

    final leftStart = (impactDistance - halfSpread) % totalPerimeter;
    final rightEnd = (impactDistance + halfSpread) % totalPerimeter;

    // Extract the active sub-segments from the global perimeter ring
    final activeLaserPath = Path();

    if (leftStart < rightEnd) {
      // Normal continuous fragment segment block
      activeLaserPath.addPath(metric.extractPath(leftStart, rightEnd), .zero);
    } else {
      // Wrap-around boundary clipping condition (crosses the path origin loop point)
      activeLaserPath
        ..addPath(metric.extractPath(leftStart, totalPerimeter), .zero)
        ..addPath(metric.extractPath(0.0, rightEnd), .zero);
    }

    canvas.drawPath(activeLaserPath, laserPaint);
  }

  /// Projects a 2D viewport intersection point onto a 1D line path string to locate its absolute metric distance offset.
  double _getDistanceOfPointOnPath(PathMetric metric, Offset target, double perimeter) {
    var minDistance = double.infinity;
    var targetedOffset = 0.0;

    // Scan the box perimeter at a precise 4px granularity to find the closest vertex index
    // This handles tethers touching the left, right, top, or bottom walls identically.
    for (var d = 0.0; d < perimeter; d += 4.0) {
      final tangent = metric.getTangentForOffset(d);
      if (tangent != null) {
        final dist = (tangent.position - target).distanceSquared;
        if (dist < minDistance) {
          minDistance = dist;
          targetedOffset = d;
        }
      }
    }
    return targetedOffset;
  }

  @override
  bool shouldRepaint(covariant _RadiatingHUDPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.impactPoint != impactPoint ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.outlineColor != outlineColor;
  }
}
