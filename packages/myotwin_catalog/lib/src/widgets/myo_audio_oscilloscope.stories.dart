import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_audio_oscilloscope.stories.g.dart';

const meta = Meta<OscilloscopeWrapper>(name: 'MyoAudioOscilloscope');

class OscilloscopeWrapper extends StatefulWidget {
  const OscilloscopeWrapper({
    super.key,
    required this.isListening,
    required this.strokeWidth,
    required this.showMirroredWave,
    required this.mirroredWaveSpeed,
  });

  final bool isListening;
  final double strokeWidth;
  final bool showMirroredWave;
  final double mirroredWaveSpeed;

  @override
  State<OscilloscopeWrapper> createState() => _OscilloscopeWrapperState();
}

class _OscilloscopeWrapperState extends State<OscilloscopeWrapper> {
  final ValueNotifier<List<double>> _amplitudes = ValueNotifier<List<double>>(List.filled(64, 0.0));
  Timer? _timer;
  double _phase = 0.0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 32), (timer) {
      if (widget.isListening) {
        _phase += 0.2;
        final newData = List.generate(64, (index) {
          // Complex wave: sum of two sines
          return (math.sin(_phase + index * 0.2) * 0.5) + (math.sin(_phase * 0.5 + index * 0.4) * 0.3);
        });
        _amplitudes.value = newData;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _amplitudes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        color: const Color(0xFF0A0A0A),
        padding: const EdgeInsets.all(32),
        child: MyoAudioOscilloscope(
          amplitudes: _amplitudes,
          isListening: widget.isListening,
          strokeWidth: widget.strokeWidth,
          showMirroredWave: widget.showMirroredWave,
          mirroredWaveSpeed: widget.mirroredWaveSpeed,
        ),
      ),
    );
  }
}

final $Default = _Story(
  name: 'Default',
  args: _Args(
    isListening: BoolArg(true, name: 'Is Listening'),
    strokeWidth: DoubleArg(2.0, name: 'Stroke Width'),
    showMirroredWave: BoolArg(true, name: 'Show Mirrored Wave'),
    mirroredWaveSpeed: DoubleArg(0.5, name: 'Mirrored Speed'),
  ),
);
