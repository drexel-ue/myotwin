import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_scene/scene.dart';
import 'package:mason_logger/mason_logger.dart' show Level;
import 'package:myotwin_app/src/app/myotwin_app.dart';
import 'package:myotwin_app/src/application/common/app_init_cubit.dart';
import 'package:myotwin_app/src/application/common/myo_bloc_observer.dart';
import 'package:myotwin_app/src/application/theme/theme_cubit.dart';
import 'package:myotwin_app/src/infrastructure/ai/services/motus_service.dart';
import 'package:myotwin_app/src/infrastructure/persistence/myotwin_database.dart';
import 'package:provider/provider.dart';
import 'package:shared_core/shared_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Entry point for MyoTwin mobile app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 0. Initialize Foundation Services.
  final logger = LoggerService(level: kDebugMode ? Level.verbose : Level.info);
  Bloc.observer = MyoBlocObserver(logger: logger);

  logger.info('MYOTWIN_BOOT_SEQUENCE_START');

  // Disable the provider safety check...
  Provider.debugCheckInvalidValueType = null;

  // 1. Instantiate Core Services.
  final motusService = MotusService(logger: logger);
  final database = MyoTwinDatabase();
  final semanticService = AnatomySemanticService(logger: logger);
  
  // 1.1 Persistent Storage & Theme
  final prefs = await SharedPreferences.getInstance();
  final storage = LocalStorageService(prefs);
  final themeRepository = ThemeRepository(storage: storage, logger: logger);

  // 1.2 Initialize 3D engine resources.
  final sceneInit = logger.progress('INITIALIZING_SCENE_RESOURCES');
  await Scene.initializeStaticResources();
  sceneInit.complete('SCENE_READY');

  // 2. Start the App.
  runApp(
    MultiProvider(
      providers: [
        Provider<LoggerService>.value(value: logger),
        RepositoryProvider<MyoTwinDatabase>.value(value: database),
        Provider<LocalStorageService>.value(value: storage),
        Provider<ThemeRepository>.value(value: themeRepository),
        ChangeNotifierProvider<MotusService>.value(value: motusService),
        ChangeNotifierProvider<AnatomySemanticService>.value(value: semanticService),
        Provider<MotusAgent>.value(value: motusService),
      ],
      child: BlocProvider(
        create: (context) => ThemeCubit(repository: themeRepository)..initialize().ignore(),
        child: BlocProvider(
          create: (context) => AppInitCubit(
            motusService: motusService,
            semanticService: semanticService,
            logger: logger,
          )..initialize().ignore(),
          child: const MyotwinApp(),
        ),
      ),
    ),
  );
}
