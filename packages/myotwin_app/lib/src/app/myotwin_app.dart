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
          return Scaffold(
            body: Stack(
              fit: .expand,
              children: [
                const GraphPaperBackground(),
                // TODO: place actual app content here (BLoC providers, GoRouter).
                Center(
                  child: Text(
                    'MyoTwin',
                    style: context.myoTheme.displayLarge,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
