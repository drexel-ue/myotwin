import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scene/scene.dart';
import 'package:llamadart/llamadart.dart';
import 'package:myotwin_app/src/app/myotwin_app.dart';
import 'package:myotwin_app/src/infrastructure/ai/local_motus_agent.dart';
import 'package:myotwin_app/src/infrastructure/persistence/myotwin_database.dart';
import 'package:provider/provider.dart';
import 'package:shared_core/shared_core.dart';

/// Entry point for MyoTwin mobile app.
///
/// Initializes navigation (GoRouter), BLoC providers, and the Drift
/// background database. The FAB is the primary interaction point.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable the provider safety check that prevents providing Listenables
  // as non-listenable types. This allows us to expose the MotusAgent interface
  // while the underlying LocalMotusAgent is a ChangeNotifier.
  Provider.debugCheckInvalidValueType = null;

  // 1. Instantiate the local LLM agent and database.
  final motusAgent = LocalMotusAgent();
  final database = MyoTwinDatabase();

  // 1.1 Initialize 3D engine resources.
  unawaited(Scene.initializeStaticResources());

  // 2. Wrap the app with MultiProvider for DI.
  runApp(
    MultiProvider(
      providers: [
        // Provide the persistence layer using RepositoryProvider
        RepositoryProvider<MyoTwinDatabase>.value(value: database),
        // Provide the concrete implementation for app-level state/initialization
        ChangeNotifierProvider<LocalMotusAgent>.value(value: motusAgent),
        // Provide the base interface for domain logic.
        Provider<MotusAgent>.value(value: motusAgent),
      ],
      child: const MyotwinApp(),
    ),
  );

  // 3. Initiate model initialization in the background.
  // We select the model based on the target platform to ensure memory stability.
  final isMobile = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  final modelUri = isMobile
      ? 'hf://mradermacher/Llama-3.2-1B-FitnessAssistant-GGUF/Llama-3.2-1B-FitnessAssistant.Q4_K_M.gguf'
      : 'hf://ggml-org/gemma-4-E2B-it-GGUF/gemma-4-E2B-it-Q8_0.gguf';

  unawaited(
    motusAgent.initialize(
      ModelSource.parse(modelUri),
    ),
  );
}
