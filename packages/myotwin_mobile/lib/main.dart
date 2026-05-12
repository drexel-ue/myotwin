import 'package:flutter/material.dart';

/// Entry point for MyoTwin mobile app.
///
/// Initializes navigation (GoRouter), BLoC providers, and the Drift
/// background database. The FAB is the primary interaction point.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyotwinApp());
}

/// Top-level MyoTwin application widget.
class MyotwinApp extends StatefulWidget {
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
        body: Center(child: Text('MyoTwin Mobile — Phase 1 scaffold')),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          tooltip: 'Motus FAB placeholder',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
