import 'package:flutter/material.dart';
import 'package:myotwin_app/src/theme/myotwin_theme.dart';
import 'package:myotwin_app/src/widgets/graph_paper_background.dart';

/// Entry point for MyoTwin mobile app.
///
/// Initializes navigation (GoRouter), BLoC providers, and the Drift
/// background database. The FAB is the primary interaction point.
/// Entry point function that initializes the app and runs the mobile MyoTwin application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyotwinApp());
}

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
