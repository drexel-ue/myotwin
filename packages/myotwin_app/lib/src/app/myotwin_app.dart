import 'package:flutter/material.dart';
import 'package:myotwin_app/src/app/boot_screen.dart';
import 'package:myotwin_app/src/infrastructure/ai/local_motus_agent.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:provider/provider.dart';

/// Top-level MyoTwin application widget.
class MyotwinApp extends StatefulWidget {
  /// Creates a MyoTwin mobile application widget.
  const MyotwinApp({super.key});

  @override
  State<MyotwinApp> createState() => _MyotwinAppState();
}

class _MyotwinAppState extends State<MyotwinApp> {
  @override
  Widget build(BuildContext context) {
    final agent = context.watch<LocalMotusAgent>();

    return MaterialApp(
      title: 'MyoTwin',
      debugShowCheckedModeBanner: false,
      theme: MyoTwinThemeDataFactory.build(),
      home: Material(
        child: ListenableBuilder(
          listenable: agent.loadingProgress,
          builder: (context, _) {
            final progress = agent.loadingProgress.value;
            final isReady = agent.isInitialized;

            if (!isReady) {
              return BootScreen(progress: progress);
            }

            return MyoCanvas(
              backgroundChild: const InteractiveGrid(
                child: emptyWidget,
              ),
              chatChild: const MyoChatList(),
              onShowChatChanged: (visible) {
                // TODO: Handle chat visibility state if needed
              },
            );
          },
        ),
      ),
    );
  }
}
