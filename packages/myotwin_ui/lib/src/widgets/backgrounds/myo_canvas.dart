import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

class MyoCanvas extends StatefulWidget {
  const MyoCanvas({super.key});

  @override
  State<MyoCanvas> createState() => _MyoCanvasState();
}

class _MyoCanvasState extends State<MyoCanvas> with SingleTickerProviderStateMixin {
  late final AnimationController _chatOffsetController;
  bool _showChat = false;

  @override
  void initState() {
    super.initState();
    _chatOffsetController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  void _toggleChat() {
    _showChat = !_showChat;
    if (_showChat) {
      _chatOffsetController.forward().ignore();
    } else {
      _chatOffsetController.reverse().ignore();
    }
  }

  @override
  void dispose() {
    _chatOffsetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .passthrough,
      children: [
        const Positioned.fill(child: InteractiveGrid()),
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
            child: const MyoChat(),
          ),
        ),
        Positioned(
          left: spacing16,
          right: spacing16,
          bottom: spacing16,
          child: Center(
            child: AnimatedHoloFAB(
              state: .idle,
              onPressed: _toggleChat,
              icon: emptyWidget,
            ),
          ),
        ),
      ],
    );
  }
}
