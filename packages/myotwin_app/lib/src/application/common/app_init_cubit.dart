import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:llamadart/llamadart.dart' show ModelSource;
import 'package:myotwin_app/src/infrastructure/ai/services/motus_service.dart';
import 'package:shared_core/shared_core.dart';

/// The state for the application's initialization sequence.
class AppInitState implements Loggable {
  /// Creates an [AppInitState].
  const AppInitState({
    this.progress = 0.0,
    this.status = 'INITIALIZING_SYSTEM...',
    this.isReady = false,
    this.isModelLoaded = false,
    this.logs = const [],
    this.error,
  });

  /// The overall progress of the initialization sequence (0.0 to 1.0).
  final double progress;

  /// A human-readable status message describing the current boot phase.
  final String status;

  /// Whether the system has completed all initialization and is ready for the HUD.
  final bool isReady;

  /// Whether the LLM model has finished loading into memory.
  final bool isModelLoaded;

  /// A rolling buffer of system logs for terminal display.
  final List<String> logs;

  /// The error message if initialization failed.
  final String? error;

  /// Creates a copy of this state with the given fields replaced.
  AppInitState copyWith({
    double? progress,
    String? status,
    bool? isReady,
    bool? isModelLoaded,
    List<String>? logs,
    String? error,
  }) {
    return AppInitState(
      progress: progress ?? this.progress,
      status: status ?? this.status,
      isReady: isReady ?? this.isReady,
      isModelLoaded: isModelLoaded ?? this.isModelLoaded,
      logs: logs ?? this.logs,
      error: error ?? this.error,
    );
  }

  @override
  String toDiagnosticString() =>
      'AppInitState(ready: $isReady, model: $isModelLoaded, logs: ${logs.length}, progress: ${progress.toStringAsFixed(2)}, status: $status)';

  @override
  String toSummaryString() => 'SYSTEM_INIT: ${isReady ? "READY" : status}';

  @override
  String toString() => toDiagnosticString();
}

/// Orchestrates the application's boot sequence and service initialization.
class AppInitCubit extends Cubit<AppInitState> {
  /// Creates an [AppInitCubit].
  AppInitCubit({
    required MotusService motusService,
    required AnatomySemanticService semanticService,
    required LoggerService logger,
  }) : _motusService = motusService,
       _semanticService = semanticService,
       _logger = logger,
       super(const AppInitState());

  final MotusService _motusService;
  final AnatomySemanticService _semanticService;
  final LoggerService _logger;

  /// Adds a log message to the internal state buffer.
  void addLog(String message) {
    final timestamp = DateTime.now().toIso8601String().split('T').last.substring(0, 8);
    final formatted = '[$timestamp] $message';
    final updatedLogs = [...state.logs, formatted];
    
    // Keep a substantial history (100 entries)
    if (updatedLogs.length > 100) {
      updatedLogs.removeAt(0);
    }
    emit(state.copyWith(logs: updatedLogs));
  }

  /// Starts the critical initialization process (Model + Semantic Map).
  Future<void> initialize() async {
    _logger.info('APP_INIT: STARTING_BOOT_SEQUENCE');
    addLog('BOOT_SEQUENCE_INITIATED');

    _motusService.loadingProgress.addListener(_onMotusProgress);

    final isMobile = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
    final modelUri = isMobile
        ? 'hf://mradermacher/Llama-3.2-1B-FitnessAssistant-GGUF/Llama-3.2-1B-FitnessAssistant.Q4_K_M.gguf'
        : 'hf://ggml-org/gemma-4-E2B-it-GGUF/gemma-4-E2B-it-Q8_0.gguf';

    try {
      // 1. Load Semantic Map (Instant)
      emit(state.copyWith(status: 'LOADING_SEMANTIC_MAP...'));
      addLog('ACCESSING_SEMANTIC_ASSETS...');
      
      final jsonString = await rootBundle.loadString('assets/models/semantic_anatomy.json');
      _semanticService.load(jsonString);
      
      addLog('SEMANTIC_INDEX_READY: ${_semanticService.getAll().length}_NODES');

      // 2. Load Model (Slow)
      emit(state.copyWith(status: 'CONNECTING_TO_MOTUS_MODEL...'));
      addLog('INITIALIZING_NEURAL_CORE...');
      
      await _motusService.initialize(ModelSource.parse(modelUri));

      if (_motusService.initializationError != null) {
        emit(state.copyWith(
          error: _motusService.initializationError,
          status: 'FATAL_CORE_ERROR',
        ));
        addLog('FATAL_MODEL_LOAD_FAILED');
        return;
      }

      _logger.success('APP_INIT: MODEL_READY');
      addLog('MOTUS_CORE_INITIALIZED');
    } catch (e, stack) {
      _logger.error('APP_INIT: FATAL_ERROR', error: e, stackTrace: stack);
      addLog('CRITICAL_SYSTEM_FAILURE');
      emit(state.copyWith(error: e.toString(), status: 'CRITICAL_FAILURE'));
    }
  }

  /// Performs semantic indexing of the anatomical map.
  /// 
  /// (Deprecated: Semantic map is now pre-compiled, but kept for future dynamic GLBs)
  Future<void> indexAnatomy(Map<AnatomyLayer, List<String>> nodesByLayer) async {
    if (state.isReady) return;
    
    // MODEL LOADED: All critical data is enriched and ready.
    emit(state.copyWith(
      isModelLoaded: true,
      progress: 1.0,
      status: 'SYSTEM_ONLINE',
      isReady: true,
    ));
    
    _logger.success('APP_INIT: BOOT_SEQUENCE_COMPLETE');
    addLog('SYNCHRONIZATION_SUCCESSFUL');
    addLog('SYSTEM_READY_FOR_DEPLOYMENT');
  }

  void _onMotusProgress() {
    final progress = _motusService.loadingProgress.value;
    if (!state.isReady) {
      emit(state.copyWith(
        progress: progress,
        status: progress < 1.0 
          ? 'DOWNLOADING_MODEL_RESOURCES... (${(progress * 100).toInt()}%)'
          : 'SYNCHRONIZING_CORE...',
      ));
      if (progress >= 1.0) addLog('MODEL_RESOURCES_UNPACKED');
    }
  }

  /// (DEBUG ONLY) Dumps the discovered 3D nodes to a file to identify naming mismatches.
  Future<void> debugDumpNodes(Map<AnatomyLayer, List<String>> nodesByLayer) async {
    final allNodes = nodesByLayer.values.expand((e) => e).toList()..sort();
    try {
      final file = File('discovered_nodes.txt');
      await file.writeAsString(allNodes.join('\n'));
      _logger.info('DEBUG: DISCOVERED_NODES_DUMPED_TO: ${file.absolute.path}');
    } catch (e) {
      _logger.warn('DEBUG: FAILED_TO_DUMP_NODES: $e');
    }
  }

  @override
  Future<void> close() async {
    _motusService.loadingProgress.removeListener(_onMotusProgress);
    return super.close();
  }
}
