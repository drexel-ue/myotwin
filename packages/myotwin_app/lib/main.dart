import 'dart:async';

import 'package:flutter/material.dart';
import 'package:llamadart/llamadart.dart';
import 'package:myotwin_app/src/app/myotwin_app.dart';
import 'package:myotwin_app/src/infrastructure/ai/local_motus_agent.dart';
import 'package:provider/provider.dart';
import 'package:shared_core/shared_core.dart';

/// Entry point for MyoTwin mobile app.
///
/// Initializes navigation (GoRouter), BLoC providers, and the Drift
/// background database. The FAB is the primary interaction point.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Instantiate the local LLM agent.
  final motusAgent = LocalMotusAgent();

  // 2. Wrap the app with MultiProvider for DI.
  runApp(
    MultiProvider(
      providers: [
        // Provide the base interface for domain logic
        Provider<MotusAgent>.value(value: motusAgent),
        // Provide the concrete implementation for app-level state/initialization
        Provider<LocalMotusAgent>.value(value: motusAgent),
      ],
      child: const MyotwinApp(),
    ),
  );

  // 3. Initiate model initialization in the background.
  // We use Gemma 4 E2B Q4_K_M as our default mobile brain.
  unawaited(
    motusAgent.initialize(
      ModelSource.parse(
        'hf://ggml-org/gemma-4-E2B-it-GGUF/gemma-4-E2B-it-Q8_0.gguf',
      ),
    ),
  );
}
