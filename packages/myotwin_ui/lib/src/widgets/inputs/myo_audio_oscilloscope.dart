import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A cyberpunk HUD-style oscilloscope visualizer that renders a continuous
/// audio waveform.
///
/// Use this widget to visualize real-time microphone or audio stream data.
class MyoAudioOscilloscope extends StatefulWidget {
  /// Creates a [MyoAudioOscilloscope].
  const MyoAudioOscilloscope({
    super.key,
    required this.amplitudes,
    this.isListening = true,
    this.strokeWidth = 2.0,
    this.glitchKey,
    this.showMirroredWave = true,
    this.mirroredWaveSpeed = 0.5,
  });

  /// A listenable list of normalized amplitude values (-1.0 to 1.0 or 0.0 to 1.0).
  /// The painter will plot these values across the width of the widget.
  final ValueListenable<List<double>> amplitudes;

  /// Whether the visualizer is active.
  final bool isListening;

  /// The thickness of the waveform line.
  final double strokeWidth;

  /// An optional key that, when changed, triggers a glitch effect.
  final Object? glitchKey;

  /// Whether to draw a vertically mirrored secondary waveform.
  final bool showMirroredWave;

  /// The speed factor of the mirrored wave relative to the main wave (0.0 to 1.0).
  /// Creates a parallax effect by stretching the spatial sampling of the wave.
  final double mirroredWaveSpeed;

  @override
  State<MyoAudioOscilloscope> createState() => _MyoAudioOscilloscopeState();
}

class _MyoAudioOscilloscopeState extends State<MyoAudioOscilloscope>
    with SingleTickerProviderStateMixin, HoloGlitchTickerMixin<MyoAudioOscilloscope> {
  @override
  void didUpdateWidget(covariant MyoAudioOscilloscope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.glitchKey != oldWidget.glitchKey && widget.glitchKey != null) {
      triggerGlitch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BleedMargin(
          margin: const EdgeInsets.symmetric(horizontal: spacing24),
          child: HoloGlitch(
            phase: glitchPhase,
            intensity: glitchIntensity,
            severity: 0.1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: spacing24),
              child: Container(
                height: 48.0, // Match MyoTextField height
                decoration: BoxDecoration(
                  color: theme.surfaceElevated,
                  borderRadius: theme.radiusSm,
                  border: Border.all(
                    color: widget.isListening ? theme.accentHot : theme.outline,
                    width: widget.isListening ? 1.5 : 1.0,
                  ),
                  boxShadow: widget.isListening
                      ? [
                          BoxShadow(
                            color: theme.accentHot.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: ClipRect(
                  child: ValueListenableBuilder<List<double>>(
                    valueListenable: widget.amplitudes,
                    builder: (context, data, child) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: _WaveformPainter(
                          amplitudes: data,
                          color: widget.isListening ? theme.accentHot : theme.onSurfaceDim,
                          strokeWidth: widget.strokeWidth,
                          showMirroredWave: widget.showMirroredWave,
                          mirroredWaveSpeed: widget.mirroredWaveSpeed,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WaveformPainter extends CustomPainter {
  _WaveformPainter({
    required this.amplitudes,
    required this.color,
    required this.strokeWidth,
    required this.showMirroredWave,
    required this.mirroredWaveSpeed,
  });

  final List<double> amplitudes;
  final Color color;
  final double strokeWidth;
  final bool showMirroredWave;
  final double mirroredWaveSpeed;

  /// Performs linear interpolation between data points to allow fractional indexing.
  double _getInterpolatedAmplitude(List<double> data, double index) {
    if (data.isEmpty) return 0.0;
    if (index <= 0) return data.first;
    if (index >= data.length - 1) return data.last;

    final lower = index.floor();
    final upper = index.ceil();
    final fraction = index - lower;

    return data[lower] * (1.0 - fraction) + data[upper] * fraction;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty || amplitudes.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final midY = size.height / 2.0;
    final centerX = size.width / 2.0;

    // Each side uses half the width.
    final stepX = (size.width / 2.0) / (amplitudes.length - 1);

    // Draw primary waveform (top-facing half)
    for (var i = 0; i < amplitudes.length; i++) {
      final xRight = centerX + (i * stepX);
      final y = midY - (amplitudes[i] * midY * 0.8);

      if (i == 0) {
        path.moveTo(xRight, y);
      } else {
        path.lineTo(xRight, y);
      }
    }

    // Reset for left side to ensure a clean central origin
    for (var i = 0; i < amplitudes.length; i++) {
      final xLeft = centerX - (i * stepX);
      final y = midY - (amplitudes[i] * midY * 0.8);
      if (i == 0) {
        path.moveTo(xLeft, y);
      } else {
        path.lineTo(xLeft, y);
      }
    }

    canvas.drawPath(path, paint);

    if (showMirroredWave) {
      // Draw a symmetrical bottom half with parallax slowing (mirroredWaveSpeed)
      final bottomPath = Path();
      final secondaryColor = color.withValues(alpha: 0.5);

      for (var i = 0; i < amplitudes.length; i++) {
        final xRight = centerX + (i * stepX);
        // Sample data at a slower rate to stretch the wave
        final amplitude = _getInterpolatedAmplitude(amplitudes, i * mirroredWaveSpeed);
        final y = midY + (amplitude * midY * 0.8);

        if (i == 0) {
          bottomPath.moveTo(xRight, y);
        } else {
          bottomPath.lineTo(xRight, y);
        }
      }

      for (var i = 0; i < amplitudes.length; i++) {
        final xLeft = centerX - (i * stepX);
        final amplitude = _getInterpolatedAmplitude(amplitudes, i * mirroredWaveSpeed);
        final y = midY + (amplitude * midY * 0.8);

        if (i == 0) {
          bottomPath.moveTo(xLeft, y);
        } else {
          bottomPath.lineTo(xLeft, y);
        }
      }

      canvas.drawPath(bottomPath, paint..color = secondaryColor);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return amplitudes != oldDelegate.amplitudes ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        showMirroredWave != oldDelegate.showMirroredWave ||
        mirroredWaveSpeed != oldDelegate.mirroredWaveSpeed;
  }
}
