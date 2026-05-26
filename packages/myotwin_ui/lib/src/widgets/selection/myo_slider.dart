import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// Velocity threshold (px/s) above which the slider triggers an accelerated glitch.
const double glitchVelocityThreshold = 400000.0;

/// A cyberpunk-style slider with a thin track and a wide rectangular thumb.
///
/// Triggers glitch effects when:
/// * The value changes programmatically.
/// * The user drags the thumb at high velocity (above [glitchVelocityThreshold]).
class MyoSlider extends StatefulWidget {
  /// Creates a [MyoSlider].
  const MyoSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangedStart,
    this.onChangedEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.highlightColor,
    this.trackColor,
    this.thumbColor,
    this.activeColor,
    this.tickColor,
  });

  /// The current value of the slider, clamped between [min] and [max].
  final double value;

  /// Called when the user is actively dragging or tapping the slider.
  final ValueChanged<double> onChanged;

  /// Called when the user starts changing the slider's value.
  final ValueChanged<double>? onChangedStart;

  /// Called when the user finishes changing the slider's value.
  final ValueChanged<double>? onChangedEnd;

  /// The minimum value the slider can represent.
  final double min;

  /// The maximum value the slider can represent.
  final double max;

  /// The number of discrete tick marks on the track.
  final int? divisions;

  /// Color for the active portion of the track (left of the thumb).
  final Color? highlightColor;

  /// Color for the inactive portion of the track (right of the thumb).
  final Color? trackColor;

  /// Color for the slider thumb fill.
  final Color? thumbColor;

  /// Color for the thumb border accent.
  final Color? activeColor;

  /// Color for the division tick marks.
  final Color? tickColor;

  @override
  State<MyoSlider> createState() => _MyoSliderState();
}

class _MyoSliderState extends State<MyoSlider> with SingleTickerProviderStateMixin, HoloGlitchTickerMixin<MyoSlider> {
  double _sliderValue = 0.0;
  Offset? _lastPointerPosition;
  DateTime? _lastDragTime;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.value.clamp(widget.min, widget.max);
  }

  @override
  void didUpdateWidget(covariant MyoSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      _sliderValue = widget.value.clamp(widget.min, widget.max);
      triggerGlitch();
    }
  }

  void _handlePanStart(DragStartDetails details) {
    _lastPointerPosition = details.globalPosition;
    _lastDragTime = DateTime.now();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final newPointerPosition = details.globalPosition;
    final currentTime = DateTime.now();

    if (_lastPointerPosition != null && _lastDragTime != null) {
      final timeDelta = currentTime.difference(_lastDragTime!).inMilliseconds / 1000.0;

      if (timeDelta > 0.0) {
        final distance = (newPointerPosition - _lastPointerPosition!).distance;
        final velocity = distance / timeDelta;

        if (velocity >= glitchVelocityThreshold) {
          triggerGlitch();
        }
      }
    }

    _lastPointerPosition = newPointerPosition;
    _lastDragTime = currentTime;

    final gestureDetails = context.findRenderObject() as RenderBox?;
    if (gestureDetails != null) {
      final localPosition = gestureDetails.globalToLocal(newPointerPosition);
      final trackWidth = gestureDetails.size.width - _thumbWidth;
      final normalizedValue = localPosition.dx / trackWidth.clamp(0.0, double.infinity);
      _sliderValue = widget.min + normalizedValue.clamp(0.0, 1.0) * (widget.max - widget.min);
      widget.onChanged(_sliderValue);
    }
  }

  static const _thumbWidth = 24.0;
  static const _thumbHeight = 6.0;
  static const _paddedHeight = 14.0;

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    final highlightColor = widget.highlightColor ?? theme.accentHot;
    final trackColor = widget.trackColor ?? theme.outline;
    final thumbColor = widget.thumbColor ?? theme.accentHot;
    final activeColor = widget.activeColor ?? theme.white;
    final tickColor = widget.tickColor ?? theme.onSurfaceDim;

    const painterSize = Size(double.infinity, _paddedHeight);

    return HoloGlitch(
      phase: glitchPhase,
      intensity: glitchIntensity,
      severity: 0.4,
      child: GestureDetector(
        onTapDown: (details) {
          final gestureDetails = context.findRenderObject() as RenderBox?;
          if (gestureDetails != null) {
            final localPosition = gestureDetails.globalToLocal(details.globalPosition);
            final trackWidth = gestureDetails.size.width - _thumbWidth;
            final normalizedValue = localPosition.dx / trackWidth.clamp(0.0, double.infinity);
            _sliderValue = widget.min + normalizedValue.clamp(0.0, 1.0) * (widget.max - widget.min);
            widget.onChanged(_sliderValue);
          }
        },
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        child: SizedBox(
          height: _paddedHeight,
          child: CustomPaint(
            size: painterSize,
            painter: _MyoSliderPainter(
              value: _sliderValue,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              highlightColor: highlightColor,
              trackColor: trackColor,
              thumbColor: thumbColor,
              activeColor: activeColor,
              tickColor: tickColor,
              thumbWidth: _thumbWidth,
              thumbHeight: _thumbHeight,
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal painter for the slider track, thumb, and tick marks.
class _MyoSliderPainter extends CustomPainter {
  _MyoSliderPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.highlightColor,
    required this.trackColor,
    required this.thumbColor,
    required this.activeColor,
    required this.tickColor,
    required this.thumbWidth,
    required this.thumbHeight,
  });

  /// Track thickness used by [MyoSlider] and [_MyoSliderPainter].
  static const double trackHeight = 2.0;

  final double value;
  final double min;
  final double max;
  final int? divisions;
  final Color highlightColor;
  final Color trackColor;
  final Color thumbColor;
  final Color activeColor;
  final Color tickColor;
  final double thumbWidth;
  final double thumbHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final trackLeft = thumbWidth / 2.0;
    final trackRight = size.width - trackLeft;
    final trackCenterY = thumbHeight / 2.0 + spacing4;
    final trackWidth = trackRight - trackLeft;

    final progress = trackWidth > 0 ? (value - min) / (max - min) : 0.0;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final activeWidth = clampedProgress * trackWidth;

    // Draw inactive track outline
    canvas.drawRect(
      Rect.fromLTWH(
        trackLeft,
        trackCenterY - trackHeight / 2.0,
        trackWidth,
        trackHeight,
      ),
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Draw active track fill
    if (activeWidth > 0) {
      canvas.drawRect(
        Rect.fromLTWH(
          trackLeft,
          trackCenterY - trackHeight / 2.0,
          activeWidth,
          trackHeight,
        ),
        Paint()
          ..color = highlightColor
          ..style = PaintingStyle.fill,
      );
    }

    // Draw division tick marks
    if (divisions != null && divisions! > 0) {
      final tickPaint = Paint()
        ..color = tickColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      for (var i = 0; i <= divisions!; i++) {
        final tickProgress = i / divisions!;
        final tickX = trackLeft + tickProgress * trackWidth;
        canvas.drawLine(
          Offset(tickX, trackCenterY - trackHeight - 2.0),
          Offset(tickX, trackCenterY - trackHeight / 2.0),
          tickPaint,
        );
      }
    }

    // Draw thumb (wide rectangle centered on progress position)
    final thumbX = trackLeft + activeWidth - thumbWidth / 2.0;
    final thumbY = trackCenterY - thumbHeight / 2.0;
    final thumbRect = Rect.fromLTWH(thumbX, thumbY, thumbWidth, thumbHeight);

    // Fill
    canvas
      ..drawRect(
        thumbRect,
        Paint()
          ..color = thumbColor
          ..style = PaintingStyle.fill,
      )
      // Accent border overlay
      ..drawRect(
        thumbRect,
        Paint()
          ..color = activeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );
  }

  @override
  bool shouldRepaint(_MyoSliderPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.min != min ||
        oldDelegate.max != max ||
        oldDelegate.divisions != divisions ||
        oldDelegate.highlightColor != highlightColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.thumbColor != thumbColor ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.tickColor != tickColor;
  }
}
