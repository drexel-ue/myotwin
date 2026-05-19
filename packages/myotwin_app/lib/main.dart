
import 'package:flutter/material.dart';
import 'package:myotwin_app/src/app/myotwin_app.dart';

/// Entry point for MyoTwin mobile app.
///
/// Initializes navigation (GoRouter), BLoC providers, and the Drift
/// background database. The FAB is the primary interaction point.
/// Entry point function that initializes the app and runs the mobile MyoTwin application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyotwinApp());
}
