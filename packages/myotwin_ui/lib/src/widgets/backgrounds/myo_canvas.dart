import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:myotwin_ui/src/widgets/actions/arc_fab_slider.dart';

/// A composable background canvas that layers draggable precision grid
/// workspace content with an animated chat panel and FAB.
class MyoCanvas extends StatefulWidget {
  /// A composable background canvas that layers draggable precision grid
  /// workspace content with an animated chat panel and FAB.
  ///
  /// {@template myo_canvas.background_child}
  /// The widget to display on the precision grid background.
  /// {@endtemplate}
  const MyoCanvas({
    super.key,
    required this.backgroundChild,
    required this.chatChild,
    required this.onShowChatChanged,
    this.voiceAmplitudes,
  });

  /// {@macro myo_canvas.background_child}
  final Widget backgroundChild;

  /// {@template myo_canvas.chat_child}
  /// The chat widget that slides up from the bottom when activated.
  /// {@endtemplate}
  final Widget chatChild;

  /// {@macro myo_canvas.chat_child}
  final ValueChanged<bool> onShowChatChanged;

  /// A listenable list of normalized amplitude values for the voice visualizer.
  final ValueNotifier<List<double>>? voiceAmplitudes;

  @override
  State<MyoCanvas> createState() => _MyoCanvasState();
}

class _MyoCanvasState extends State<MyoCanvas> with SingleTickerProviderStateMixin {
  late final AnimationController _chatOffsetController;
  bool _showChat = false;
  final _fabState = ValueNotifier<HoloState>(.idle);
  final _sliderMode = ValueNotifier<ArcSliderMode>(.centered);
  final _textGlitchTrigger = ValueNotifier<int>(0);
  final _voiceGlitchTrigger = ValueNotifier<int>(0);

  // Fallback for voice visualizer if none provided
  late final ValueNotifier<List<double>> _internalVoiceAmplitudes;

  // Stub animation state
  Timer? _stubTimer;
  double _stubPhase = 0.0;
  double _pluckIntensity = 0.0;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _chatOffsetController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _internalVoiceAmplitudes = widget.voiceAmplitudes ?? ValueNotifier<List<double>>(List.filled(32, 0.0));
    
    // Listen for mode changes to manage the stub timer
    _sliderMode.addListener(_handleModeChange);
  }

  void _handleModeChange() {
    final mode = _sliderMode.value;
    
    // Only manage stub timer if no external amplitudes are provided
    if (widget.voiceAmplitudes == null) {
      if (mode == ArcSliderMode.voice) {
        _startStubTimer();
      } else {
        _stopStubTimer();
      }
    }
  }

  void _startStubTimer() {
    _stubTimer?.cancel();
    _stubTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      _updateStubAmplitudes();
    });
  }

  void _stopStubTimer() {
    _stubTimer?.cancel();
    _stubTimer = null;
    _pluckIntensity = 0.0;
    // Reset to flat line when stopping
    _internalVoiceAmplitudes.value = List.filled(32, 0.0);
  }

  void _updateStubAmplitudes() {
    // 1. Decaying physics
    if (_pluckIntensity > 0.01) {
      _pluckIntensity *= 0.94; // Exponential decay
    } else {
      _pluckIntensity = 0.0;
    }

    // 2. Randomly "pluck" the string
    if (_random.nextDouble() > 0.97) {
      _pluckIntensity = 0.5 + (_random.nextDouble() * 0.5);
    }

    // 3. Update phase for rapid vibration
    _stubPhase += 0.8;

    // 4. Generate standing wave data
    const count = 32;
    final newData = List.generate(count, (index) {
      if (_pluckIntensity == 0.0) return 0.0;

      // Spatial envelope: 1.0 at center (index 0), 0.0 at edge (index 31)
      final progress = index / (count - 1);
      final envelope = math.cos(progress * (math.pi / 2));
      
      // Standing wave vibration: Oscillation(time) * Shape(space)
      // Fundamental freq + some high-freq jitter for the "pluck" feel
      final fundamental = math.sin(_stubPhase) * math.sin(index * 0.15);
      final harmonic = math.sin(_stubPhase * 2.5) * math.sin(index * 0.45) * 0.3;
      
      return (fundamental + harmonic) * envelope * _pluckIntensity;
    });

    _internalVoiceAmplitudes.value = newData;
  }

  Future<void> _toggleChat() async {
    _showChat = !_showChat;
    if (_showChat) {
      await _chatOffsetController.forward();
      _fabState.value = .listening;
    } else {
      await _chatOffsetController.reverse();
      _fabState.value = .idle;
    }
  }

  Future<void> _onFabPressed(ArcSliderMode mode) async {
    await _toggleChat();
    widget.onShowChatChanged(_showChat);
  }

  @override
  void dispose() {
    _sliderMode.removeListener(_handleModeChange);
    _chatOffsetController.dispose();
    _fabState.dispose();
    _sliderMode.dispose();
    _textGlitchTrigger.dispose();
    _voiceGlitchTrigger.dispose();
    _stubTimer?.cancel();
    if (widget.voiceAmplitudes == null) {
      _internalVoiceAmplitudes.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .passthrough,
      children: [
        Positioned.fill(
          child: InteractiveGrid(
            child: widget.backgroundChild,
          ),
        ),
        Positioned.fill(
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 1.0),
                  end: .zero,
                ).animate(
                  CurvedAnimation(
                    parent: _chatOffsetController,
                    curve: context.myoTheme.curveEaseOut,
                  ),
                ),
            child: MyoChat(
              child: ValueListenableBuilder(
                valueListenable: _sliderMode,
                builder: (context, mode, child) {
                  return AnimatedPadding(
                    padding: EdgeInsets.only(
                      bottom: mode == ArcSliderMode.centered
                          ? ArcFABSlider.trackHeight : (ArcFABSlider.trackHeight / 2.0),
                    ),
                    duration: context.myoTheme.motionNormal,
                    curve: Curves.easeOut,
                    child: widget.chatChild,
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          left: spacing64 + spacing24, // Space for scaled FAB on left
          right: spacing16,
          bottom: spacing16, // Align perfectly with the dropped FAB's center
          child: ValueListenableBuilder(
            valueListenable: _sliderMode,
            builder: (context, mode, child) {
              final isVoiceMode = mode == ArcSliderMode.voice;
              return AnimatedSlide(
                offset: isVoiceMode ? Offset.zero : const Offset(-1.2, 0),
                duration: context.myoTheme.motionNormal,
                curve: Curves.easeOutBack,
                onEnd: () {
                  if (isVoiceMode) {
                    _voiceGlitchTrigger.value++;
                  }
                },
                child: AnimatedOpacity(
                  opacity: isVoiceMode ? 1.0 : 0.0,
                  duration: context.myoTheme.motionFast,
                  curve: Curves.easeOut,
                  child: IgnorePointer(
                    ignoring: !isVoiceMode,
                    child: ValueListenableBuilder(
                      valueListenable: _voiceGlitchTrigger,
                      builder: (context, glitchKey, child) {
                        return MyoAudioOscilloscope(
                          glitchKey: glitchKey,
                          amplitudes: _internalVoiceAmplitudes,
                          isListening: isVoiceMode,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          left: spacing16,
          right: spacing64 + spacing24, // Space for scaled FAB on right
          bottom: spacing16, // Align perfectly with the dropped FAB's center
          child: ValueListenableBuilder(
            valueListenable: _sliderMode,
            builder: (context, mode, child) {
              final isTextMode = mode == ArcSliderMode.text;
              return AnimatedSlide(
                offset: isTextMode ? Offset.zero : const Offset(1.2, 0),
                duration: context.myoTheme.motionNormal,
                curve: Curves.easeOutBack,
                onEnd: () {
                  if (isTextMode) {
                    _textGlitchTrigger.value++;
                  }
                },
                child: AnimatedOpacity(
                  opacity: isTextMode ? 1.0 : 0.0,
                  duration: context.myoTheme.motionFast,
                  curve: Curves.easeOut,
                  child: IgnorePointer(
                    ignoring: !isTextMode,
                    child: ValueListenableBuilder(
                      valueListenable: _textGlitchTrigger,
                      builder: (context, glitchKey, child) {
                        return MyoTextField(
                          glitchKey: glitchKey,
                          hint: 'ENTER_COMMAND...',
                          prefixIcon: const MyoIcon(intent: 'terminal', size: 18),
                          onSubmitted: (value) {
                            debugPrint('Submitted: $value');
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          left: spacing16,
          right: spacing16,
          bottom: 0,
          child: Center(
            child: ValueListenableBuilder(
              valueListenable: _fabState,
              builder: (context, state, child) {
                return ArcFABSlider(
                  fabState: state,
                  onFabPressed: _onFabPressed,
                  onModeChanged: (value) {
                    _sliderMode.value = value;
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
