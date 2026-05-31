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
  });

  final List<double> amplitudes;
  final Color color;
  final double strokeWidth;

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
    final stepX = size.width / (amplitudes.length - 1);

    for (var i = 0; i < amplitudes.length; i++) {
      final x = i * stepX;
      // Map normalized -1.0..1.0 or 0.0..1.0 to the vertical space
      // We assume -1.0 to 1.0 for a true waveform centered at midY
      final y = midY - (amplitudes[i] * midY * 0.8); // 0.8 to keep it within bounds comfortably

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return amplitudes != oldDelegate.amplitudes || color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
  }
}
