import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A holographic frosted-glass HUD panel with radiating laser effects.
class FrostedHUD extends StatefulWidget {
  /// Creates a holographic frosted-glass HUD panel with radiating laser effects.
  const FrostedHUD({
    super.key,
    this.title,
    required this.child,
    required this.impactPoint,
    this.animationProgress = 1.0,
    this.glitchIntensity = 0.2,
    this.onClose,
    this.expand = false,
  });

  /// The HUD title text.
  final String? title;

  /// The content widget displayed inside the HUD panel.
  final Widget child;

  /// Offset on the box edge where the tether physically touches (used for laser computation).
  final Offset impactPoint;

  /// Normalized animation progress driving the laser spread and fade, from 0.0 to 1.0.
  final double animationProgress;

  /// External glitch intensity amplifier (0.0–1.0). Controls the frequency and
  /// strength of random YIQ chromatic-aberration spikes applied by the shader.
  final double glitchIntensity;

  /// Optional callback for when the close button is pressed.
  final VoidCallback? onClose;

  /// Whether the HUD should expand to fill its parent constraints.
  /// If false (default), the HUD uses intrinsic sizing to hug its content.
  final bool expand;

  @override
  State<FrostedHUD> createState() => _FrostedHUDState();
}

class _FrostedHUDState extends State<FrostedHUD>
    with SingleTickerProviderStateMixin, HoloGlitchLogicMixin {
  late final Ticker _ticker;
  Duration _lastTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start().ignore();
  }

  void _onTick(Duration elapsed) {
    if (_lastTime == Duration.zero) {
      _lastTime = elapsed;
      return;
    }

    final dt = (elapsed - _lastTime).inMicroseconds / 1000000.0;
    _lastTime = elapsed;

    // Custom random glitch trigger
    if (math.Random().nextDouble() < (0.01 * widget.glitchIntensity)) {
      triggerGlitch();
    }

    updateGlitchState(dt);

    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    // Define the runway needed for the glitch shader
    const bleedValue = 8.0;
    const bleedInsets = EdgeInsets.all(bleedValue);

    return Stack(
      clipBehavior:
          Clip.none, // Critical: Allows the BleedMargin to overflow the Stack
      children: [
        // --- LAYER 1: The Stable Glass ---
        // Because BleedMargin hides the 32px padding from the Stack's layout,
        // Positioned.fill will perfectly hug the HUD content without manual insets.
        Positioned.fill(
          child: ClipRRect(
            borderRadius: theme.radiusSm,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              child: ColoredBox(
                color: theme.black.withValues(alpha: 0.26),
              ),
            ),
          ),
        ),

        // --- LAYER 2: The Glitched Content ---
        BleedMargin(
          margin: bleedInsets, // Tells layout engine: "Hide this much size"
          child: HoloGlitch(
            phase: glitchPhase,
            intensity: glitchIntensity,
            severity: 0.05,
            child: Padding(
              padding: bleedInsets,
              child: _FrostedHUDContent(
                title: widget.title,
                impactPoint: widget.impactPoint,
                animationProgress: widget.animationProgress,
                onClose: widget.onClose,
                expand: widget.expand,
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FrostedHUDContent extends StatelessWidget {
  const _FrostedHUDContent({
    required this.title,
    required this.child,
    required this.impactPoint,
    required this.animationProgress,
    this.onClose,
    required this.expand,
  });

  final String? title;
  final Widget child;
  final Offset impactPoint;
  final double animationProgress;
  final VoidCallback? onClose;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;
    final content = ClipRRect(
      borderRadius: theme.radiusSm,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.transparent,
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
                mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (title case final String titleText when titleText.isNotEmpty) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(titleText.toUpperCase(),
                              style: theme.headlineMedium),
                        ),
                        if (onClose != null)
                          MyoIconButton(
                            intent: 'x',
                            onPressed: onClose!,
                          ),
                      ],
                    ),
                    const MyoDivider(height: spacing16),
                  ],
                  if (expand) Expanded(child: child) else child,
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (expand) return content;

    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: content,
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

  final double progress;
  final Offset impactPoint;
  final Color strokeColor;
  final Color outlineColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0.0 || size.height <= 0.0) return;

    final backgroundPaint = Paint()
      ..color = outlineColor
      ..strokeWidth = 1.0
      ..style = .stroke;

    final fullRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(spacing4),
    );
    canvas.drawRRect(fullRect, backgroundPaint);

    if (progress <= 0.0) return;

    final laserPaint = Paint()
      ..color = strokeColor
      ..style = .stroke;

    final structuralPath = Path()..addRRect(fullRect);
    final metricsList = structuralPath.computeMetrics().toList();

    if (metricsList.isEmpty) return;
    final metric = metricsList.first;
    final totalPerimeter = metric.length;

    final impactDistance =
        _getDistanceOfPointOnPath(metric, impactPoint, totalPerimeter);

    final halfSpread = (totalPerimeter / 2) * progress;

    final leftStart = (impactDistance - halfSpread) % totalPerimeter;
    final rightEnd = (impactDistance + halfSpread) % totalPerimeter;

    final activeLaserPath = Path();

    if (leftStart < rightEnd) {
      activeLaserPath.addPath(metric.extractPath(leftStart, rightEnd), .zero);
    } else {
      activeLaserPath
        ..addPath(metric.extractPath(leftStart, totalPerimeter), .zero)
        ..addPath(metric.extractPath(0.0, rightEnd), .zero);
    }

    canvas.drawPath(activeLaserPath, laserPaint);
  }

  double _getDistanceOfPointOnPath(
      PathMetric metric, Offset target, double perimeter) {
    var minDistance = double.infinity;
    var targetedOffset = 0.0;

    for (var d = 0.0; d < perimeter; d += spacing4) {
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
