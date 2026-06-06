import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

/// A controller that manages the waveform math and periodic updates
/// for the audio oscilloscope visualizer.
class AudioVisualizerController extends ChangeNotifier {
  /// Creates an [AudioVisualizerController].
  AudioVisualizerController({
    int sampleCount = 128,
  }) : _amplitudes = ValueNotifier(List.filled(sampleCount, 0.0));

  final ValueNotifier<List<double>> _amplitudes;
  Timer? _timer;
  double _phase = 0.0;

  /// Returns the current list of normalized amplitude values.
  ValueNotifier<List<double>> get amplitudes => _amplitudes;

  /// Whether the visualizer is currently active and updating.
  bool get isActive => _timer != null;

  /// Starts the waveform generation timer.
  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) => _update());
    notifyListeners();
  }

  /// Stops the waveform generation timer and flattens the output.
  void stop() {
    _timer?.cancel();
    _timer = null;
    _amplitudes.value = List.filled(_amplitudes.value.length, 0.0);
    notifyListeners();
  }

  void _update() {
    _phase += 0.15;
    final beatTime = (_phase * 0.25) % 1.5;
    final count = _amplitudes.value.length;

    final newData = List.generate(count, (index) {
      final progress = index / (count - 1);
      final distance1 = (progress - beatTime).abs();
      final envelope1 = math.exp(-(distance1 * distance1) * 80.0);
      final wave1 = math.sin((progress - _phase) * math.pi * 12) * envelope1;

      final distance2 = (progress - (beatTime - 0.15)).abs();
      final envelope2 = math.exp(-(distance2 * distance2) * 120.0);
      final wave2 = math.sin((progress - _phase) * math.pi * 18) * envelope2 * 0.4;

      final ambient = math.sin(_phase * 2 + progress * math.pi * 8) * 0.01;
      final edgeTaper = math.cos(progress * (math.pi / 2));

      return (wave1 + wave2 + ambient) * edgeTaper * 1.6;
    });

    _amplitudes.value = newData;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _amplitudes.dispose();
    super.dispose();
  }
}
