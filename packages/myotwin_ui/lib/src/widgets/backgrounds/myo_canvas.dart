import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

class MyoCanvas extends StatefulWidget {
  const MyoCanvas({
    super.key,
    required this.backgroundChild,
    required this.chatChild,
    required this.onShowChatChanged,
  });

  final Widget backgroundChild;

  final Widget chatChild;

  final ValueChanged<bool> onShowChatChanged;

  @override
  State<MyoCanvas> createState() => _MyoCanvasState();
}

class _MyoCanvasState extends State<MyoCanvas> with SingleTickerProviderStateMixin {
  late final AnimationController _chatOffsetController;
  bool _showChat = false;
  final _fabState = ValueNotifier<HoloState>(.idle);

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

  @override
  void dispose() {
    _chatOffsetController.dispose();
    _fabState.dispose();
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
              child: widget.chatChild,
            ),
          ),
        ),
        Positioned(
          left: spacing16,
          right: spacing16,
          bottom: spacing16,
          child: Center(
            child: ValueListenableBuilder(
              valueListenable: _fabState,
              builder: (context, state, child) {
                return AnimatedHoloFAB(
                  state: state,
                  onPressed: () {
                    _toggleChat();
                    widget.onShowChatChanged(_showChat);
                  },
                  icon: emptyWidget,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
