import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.onMessageSubmitted,
    this.fabState,
    this.onCommandNodeSelected,
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

  /// Called when a message is submitted from the text input.
  /// Returns true if the message was successfully processed.
  final Future<bool> Function(String)? onMessageSubmitted;

  /// An optional notifier to drive the FAB's state externally.
  /// If null, the canvas manages the state internally (idle/listening).
  final ValueNotifier<HoloState>? fabState;

  /// Called when a node is selected from the quick command menu.
  final ValueChanged<String>? onCommandNodeSelected;

  @override
  State<MyoCanvas> createState() => _MyoCanvasState();
}

class _MyoCanvasState extends State<MyoCanvas>
    with TickerProviderStateMixin, HoloGlitchLogicMixin {
  late final AnimationController _chatOffsetController;
  bool _showChat = false;
  late final ValueNotifier<HoloState> _fabState;
  final _sliderMode = ValueNotifier<ArcSliderMode>(ArcSliderMode.centered);
  final _slideProgress = ValueNotifier<double>(0.0);
  final _textGlitchTrigger = ValueNotifier<int>(0);
  final _voiceGlitchTrigger = ValueNotifier<int>(0);

  // Fallback for voice visualizer if none provided
  late final ValueNotifier<List<double>> _internalVoiceAmplitudes;

  // Stub animation state
  Timer? _stubTimer;
  double _stubPhase = 0.0;

  // Text input management
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _chatOffsetController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _internalVoiceAmplitudes =
        widget.voiceAmplitudes ?? ValueNotifier<List<double>>(List.filled(128, 0.0));
    _fabState = widget.fabState ?? ValueNotifier<HoloState>(HoloState.idle);

    // Listen for mode changes to manage the stub timer
    _sliderMode.addListener(_handleModeChange);
  }

  Future<void> _handleModeChange() async {
    final mode = _sliderMode.value;

    if (mode == ArcSliderMode.text) {
      _textFocusNode.requestFocus();
    } else {
      _textFocusNode.unfocus();
    }

    // Auto-open chat when sliding to either side
    if (mode != ArcSliderMode.centered && !_showChat) {
      await _toggleChat();
      widget.onShowChatChanged(_showChat);
    }

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
    // Reset to flat line when stopping
    _internalVoiceAmplitudes.value = List.filled(128, 0.0);
  }

  void _updateStubAmplitudes() {
    // Steady phase progression for the traveling wave
    _stubPhase += 0.15;

    // Cycle repeats periodically. Pulse moves from 0 (center) to 1.5 (past edge).
    final beatTime = (_stubPhase * 0.25) % 1.5;

    const count = 128;
    final newData = List.generate(count, (index) {
      // Spatial progress: 0.0 at center (index 0), 1.0 at edge (index 127)
      final progress = index / (count - 1);

      // 1. Primary Pulse ("Dub")
      final distance1 = (progress - beatTime).abs();
      // Gaussian curve: creates a highly localized sharp peak
      final envelope1 = math.exp(-(distance1 * distance1) * 80.0);
      // Traveling carrier wave inside the pulse
      final wave1 =
          math.sin((progress - _stubPhase) * math.pi * 12) * envelope1;

      // 2. Secondary Pulse ("Lub") - trailing slightly behind
      final distance2 = (progress - (beatTime - 0.15)).abs();
      final envelope2 = math.exp(-(distance2 * distance2) * 120.0);
      final wave2 =
          math.sin((progress - _stubPhase) * math.pi * 18) * envelope2 * 0.4;

      // 3. Ambient baseline (very subtle constant vibration)
      final ambient = math.sin(_stubPhase * 2 + progress * math.pi * 8) * 0.01;

      // 4. Spatial Taper to ensure it stays locked at the sides
      final edgeTaper = math.cos(progress * (math.pi / 2));

      return (wave1 + wave2 + ambient) * edgeTaper * 1.6;
    });

    _internalVoiceAmplitudes.value = newData;
  }

  Future<void> _toggleChat() async {
    _showChat = !_showChat;
    if (_showChat) {
      await _chatOffsetController.forward();
      _fabState.value = HoloState.listening;
    } else {
      await _chatOffsetController.reverse();
      _fabState.value = HoloState.idle;
    }
  }

  Future<void> _onFabPressed(ArcSliderMode mode) async {
    await _toggleChat();
    widget.onShowChatChanged(_showChat);
  }

  Future<void> _handleSubmit(String text) async {
    if (text.trim().isEmpty) return;

    // 1. Capture and clear immediately for visual responsiveness
    final capturedText = text;
    _textController.clear();

    // 2. Dispatch to agent
    if (widget.onMessageSubmitted != null) {
      final success = await widget.onMessageSubmitted!(capturedText);

      // 3. Auto-recovery logic: if processing failed, restore the text
      if (!success && mounted) {
        _textController.text = capturedText;
        // Trigger a "Transmission Error" glitch spike on the input field
        _textGlitchTrigger.value++;
      }
    }
  }

  @override
  void dispose() {
    _sliderMode.removeListener(_handleModeChange);
    _chatOffsetController.dispose();
    if (widget.fabState == null) {
      _fabState.dispose();
    }
    _sliderMode.dispose();
    _slideProgress.dispose();
    _textGlitchTrigger.dispose();
    _voiceGlitchTrigger.dispose();
    _stubTimer?.cancel();
    _textController.dispose();
    _textFocusNode.dispose();
    if (widget.voiceAmplitudes == null) {
      _internalVoiceAmplitudes.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: InteractiveGrid(
              onLongPress: () {
                // --- CINEMATIC RESET PROTOCOL ---
                // 1. Ignite the visual noise and haptics
                triggerGlitch();
                unawaited(HapticFeedback.heavyImpact());

                // 2. Wait for the peak of the glitch to mask the jump
                Timer(const Duration(milliseconds: 150), () {
                  if (mounted) {
                    widget.onCommandNodeSelected?.call('RESET');
                  }
                });
              },
              child: widget.backgroundChild,
            ),
          ),
          Positioned.fill(
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1.0),
                end: Offset.zero,
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
                        bottom: (mode == ArcSliderMode.centered
                                ? ArcFABSlider.trackHeight
                                : (ArcFABSlider.trackHeight / 2.0)) +
                            bottomInset,
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
            bottom: spacing16 +
                bottomInset, // Align perfectly with the dropped FAB's center
            child: ValueListenableBuilder(
              valueListenable: _sliderMode,
              builder: (context, mode, child) {
                final isVoiceMode = mode == ArcSliderMode.voice;
                return AnimatedSlide(
                  offset: isVoiceMode ? Offset.zero : const Offset(-1.2, 0),
                  duration: context.myoTheme.motionHolographic,
                  curve: Curves.easeOutExpo,
                  onEnd: () {
                    if (isVoiceMode) {
                      _voiceGlitchTrigger.value++;
                    }
                  },
                  child: AnimatedOpacity(
                    opacity: isVoiceMode ? 1.0 : 0.0,
                    duration: context.myoTheme.motionNormal,
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
            bottom: spacing16 +
                bottomInset, // Align perfectly with the dropped FAB's center
            child: ValueListenableBuilder(
              valueListenable: _sliderMode,
              builder: (context, mode, child) {
                final isTextMode = mode == ArcSliderMode.text;
                return AnimatedSlide(
                  offset: isTextMode ? Offset.zero : const Offset(1.2, 0),
                  duration: context.myoTheme.motionHolographic,
                  curve: Curves.easeOutExpo,
                  onEnd: () {
                    if (isTextMode) {
                      _textGlitchTrigger.value++;
                    }
                  },
                  child: AnimatedOpacity(
                    opacity: isTextMode ? 1.0 : 0.0,
                    duration: context.myoTheme.motionNormal,
                    curve: Curves.easeOut,
                    child: IgnorePointer(
                      ignoring: !isTextMode,
                      child: ValueListenableBuilder(
                        valueListenable: _textGlitchTrigger,
                        builder: (context, glitchKey, child) {
                          return MyoTextField(
                            controller: _textController,
                            focusNode: _textFocusNode,
                            glitchKey: glitchKey,
                            hint: 'ENTER_COMMAND...',
                            prefixIcon:
                                const MyoIcon(intent: 'terminal', size: 18),
                            onSubmitted: _handleSubmit,
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
            bottom: bottomInset,
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: _fabState,
                builder: (context, state, child) {
                  return ArcFABSlider(
                    fabState: state,
                    slideProgress: _slideProgress,
                    onFabPressed: _onFabPressed,
                    onCommandSelected: (index) {
                      widget.onCommandNodeSelected?.call(index.toString());
                    },
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
    });
  }
}
