import 'package:flutter/material.dart';

/// Entry point for MyoTwin desktop app.
///
/// Initializes navigation (GoRouter), BLoC providers, and the Drift
/// background database. Detects desktop platform to enable floating
/// callout windows instead of full-screen flow.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyotwinDesktopApp());
}

/// Top-level MyoTwin desktop application widget.
class MyotwinDesktopApp extends StatelessWidget {
  const MyotwinDesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyoTwin Desktop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white10,
          surface: Colors.black,
        ),
      ),
      home: const Scaffold(
        body: Center(child: Text('MyoTwin Desktop — Phase 1 scaffold')),
      ),
    );
  }
}
