import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:uuid/uuid.dart';

/// A scrollable list of chat messages with velocity tracking.
class MyoChatList extends StatefulWidget {
  /// Creates a [MyoChatList].
  const MyoChatList({super.key});

  @override
  State<MyoChatList> createState() => _MyoChatListState();
}

class _MyoChatListState extends State<MyoChatList> {
  // 1. The Sensor output (Broadcasts velocity to the bubbles)
  final ValueNotifier<double> scrollVelocity = ValueNotifier(0.0);

  // 2. The Actuator (Controls the scrolling imperative actions)
  final ItemScrollController chatScrollController = ItemScrollController();

  static final _entries = <String>[
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
    const Uuid().v4(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ShaderMask(
          // 1. Create the gradient mask
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent, // Top edge (fully faded)
                Colors.black, // Safe zone (fully visible)
                Colors.black, // Safe zone (fully visible)
                Colors.transparent, // Bottom edge (fully faded)
              ],
              stops: [
                0.0, // Start transparent at 0%
                0.05, // Become fully visible at 5% down
                0.95, // Stay fully visible until 95% down
                1.0, // Fade to transparent at 100%
              ],
            ).createShader(rect);
          },
          // 2. dstIn means "Keep the Destination (the List) where the Source (the Gradient) is opaque"
          blendMode: BlendMode.dstIn,

          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              // Harvest the scroll velocity and broadcast it to your bubbles
              if (notification is ScrollUpdateNotification) {
                scrollVelocity.value = notification.scrollDelta ?? 0.0;
              } else if (notification is ScrollEndNotification) {
                // Trigger your spring simulation to snap the bubbles back to 0
                scrollVelocity.value = 0.0;
              }
              return false; // Let the notification continue up the tree
            },
            child: ScrollablePositionedList.builder(
              itemScrollController: chatScrollController, // Attach the motor
              shrinkWrap: true,
              reverse: true, // Crucial for chat apps (bottom-up layout)
              padding: const EdgeInsets.only(bottom: spacing32, left: spacing16, right: spacing16),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: topPadding16,
                  child: _ChatEntry(
                    index: index,
                    message: _entries[index],
                    // Pass the velocity tracker down so the bubble can stretch itself
                    velocityTracker: scrollVelocity,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ChatEntry extends StatelessWidget {
  const _ChatEntry({
    super.key,
    required this.index,
    required this.message,
    required this.velocityTracker,
  });

  final int index;
  final String message;
  final ValueNotifier<double> velocityTracker;

  @override
  Widget build(BuildContext context) {
    return FrostedHUD(
      impactPoint: .zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '($index): $message',
          style: context.myoTheme.bodyLarge,
        ),
      ),
    );
  }
}
