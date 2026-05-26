import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

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
    // Placeholder — will be scaffolded with BLoC providers and GoRouter.
    return MaterialApp(
      title: 'MyoTwin',
      debugShowCheckedModeBanner: false,
      theme: MyoTwinThemeDataFactory.build(),
      home: Builder(
        builder: (context) {
          return const Scaffold(
            body: InteractiveGrid(
              child: emptyWidget,
            ),

          );
        },
      ),
    );
  }
}
