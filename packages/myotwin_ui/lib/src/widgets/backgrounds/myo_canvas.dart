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
  });

  /// {@macro myo_canvas.background_child}
  final Widget backgroundChild;

  /// {@template myo_canvas.chat_child}
  /// The chat widget that slides up from the bottom when activated.
  /// {@endtemplate}
  final Widget chatChild;

  /// {@macro myo_canvas.chat_child}
  final ValueChanged<bool> onShowChatChanged;

  @override
  State<MyoCanvas> createState() => _MyoCanvasState();
}

class _MyoCanvasState extends State<MyoCanvas> with SingleTickerProviderStateMixin {
  late final AnimationController _chatOffsetController;
  bool _showChat = false;
  final _fabState = ValueNotifier<HoloState>(.idle);
  final _sliderMode = ValueNotifier<ArcSliderMode>(.centered);
  final _textGlitchTrigger = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _chatOffsetController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
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
    _chatOffsetController.dispose();
    _fabState.dispose();
    _sliderMode.dispose();
    _textGlitchTrigger.dispose();
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
                      bottom: mode == .centered
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
          left: spacing16,
          right: spacing64 + spacing24, // Space for scaled FAB
          bottom: spacing16, // Align perfectly with the dropped FAB's center
          child: ValueListenableBuilder(
            valueListenable: _sliderMode,
            builder: (context, mode, child) {
              final isTextMode = mode == .text;
              return AnimatedSlide(
                offset: isTextMode ? .zero : const Offset(1.2, 0),
                duration: context.myoTheme.motionNormal,
                curve: Curves.easeOutExpo,
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
