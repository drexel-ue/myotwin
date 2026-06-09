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
    this.pendingTasks = const {'anatomy', 'motus_model'},
    this.logs = const [],
    this.error,
  });

  /// The overall progress of the initialization sequence (0.0 to 1.0).
  final double progress;

  /// A human-readable status message describing the current boot phase.
  final String status;

  /// A set of tasks that must complete before the system is ready.
  final Set<String> pendingTasks;

  /// Whether the system has completed all initialization and is ready for the HUD.
  bool get isReady => pendingTasks.isEmpty && error == null;

  /// Whether the LLM model has finished loading into memory.
  bool get isModelLoaded => !pendingTasks.contains('motus_model');

  /// A rolling buffer of system logs for terminal display.
  final List<String> logs;

  /// The error message if initialization failed.
  final String? error;

  /// Creates a copy of this state with the given fields replaced.
  AppInitState copyWith({
    double? progress,
    String? status,
    Set<String>? pendingTasks,
    List<String>? logs,
    String? error,
  }) {
    return AppInitState(
      progress: progress ?? this.progress,
      status: status ?? this.status,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      logs: logs ?? this.logs,
      error: error ?? this.error,
    );
  }

  @override
  String toDiagnosticString() =>
      'AppInitState(ready: $isReady, model: $isModelLoaded, tasks: ${pendingTasks.join(", ")}, logs: ${logs.length}, progress: ${progress.toStringAsFixed(2)}, status: $status)';

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

  /// Marks a specific initialization task as complete.
  void markTaskComplete(String taskName) {
    if (state.error != null) return;

    final updatedTasks = Set<String>.from(state.pendingTasks)..remove(taskName);

    if (updatedTasks.isEmpty) {
      emit(
        state.copyWith(
          pendingTasks: updatedTasks,
          progress: 1.0,
          status: 'SYSTEM_ONLINE',
        ),
      );
      _logger.success('APP_INIT: BOOT_SEQUENCE_COMPLETE');
      addLog('SYNCHRONIZATION_SUCCESSFUL');
      addLog('SYSTEM_READY_FOR_DEPLOYMENT');
    } else {
      emit(state.copyWith(pendingTasks: updatedTasks));
    }
  }

  /// Starts the critical initialization process (Model + Semantic Map).
  Future<void> initialize() async {
    _logger.info('APP_INIT: STARTING_BOOT_SEQUENCE');
    addLog('BOOT_SEQUENCE_INITIATED');

    _motusService.loadingProgress.addListener(_onMotusProgress);

    final isMobile = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
    final modelUri = isMobile
        ? 'hf://unsloth/gemma-4-E2B-it-qat-mobile-GGUF/gemma-4-E2B-it-qat-UD-Q2_K_XL.gguf'
        : 'hf://unsloth/gemma-4-E2B-it-qat-GGUF/gemma-4-E2B-it-qat-UD-Q4_K_XL.gguf';

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
        emit(
          state.copyWith(
            error: _motusService.initializationError,
            status: 'FATAL_CORE_ERROR',
          ),
        );
        addLog('FATAL_MODEL_LOAD_FAILED');
        return;
      }

      _logger.success('APP_INIT: MODEL_READY');
      addLog('MOTUS_CORE_INITIALIZED');
      markTaskComplete('motus_model');
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
    markTaskComplete('anatomy');
  }

  void _onMotusProgress() {
    final progress = _motusService.loadingProgress.value;
    if (!state.isReady) {
      // Throttle state emissions to 1% increments to prevent excessive UI rebuilds
      final currentPercent = (progress * 100).toInt();
      final lastPercent = (state.progress * 100).toInt();

      if (currentPercent != lastPercent || (progress >= 1.0 && state.progress < 1.0)) {
        emit(
          state.copyWith(
            progress: progress,
            status: progress < 1.0
                ? 'DOWNLOADING_MODEL_RESOURCES... ($currentPercent%)'
                : 'SYNCHRONIZING_CORE...',
          ),
        );
        if (progress >= 1.0) addLog('MODEL_RESOURCES_UNPACKED');
      }
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
