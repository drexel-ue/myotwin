import 'package:flutter/material.dart';
import 'package:myotwin_mobile/src/theme/myotwin_theme.dart';
import 'package:myotwin_mobile/src/widgets/graph_paper_background_2.dart';

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
          return const Scaffold(
            body: Stack(
              fit: .expand,
              children: [
                GraphPaperBackground(),
                // TODO: place actual app content here (BLoC providers, GoRouter).
                Center(
                  child: Text(
                    'MyoTwin',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: .w300,
                      letterSpacing: 2.5,
                    ),
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
