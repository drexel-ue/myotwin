import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
    this.error,
  });

  /// The overall progress of the initialization sequence (0.0 to 1.0).
  final double progress;

  /// A human-readable status message describing the current boot phase.
  final String status;

  /// Whether the system has completed all initialization steps and is ready.
  final bool isReady;

  /// The error message if initialization failed.
  final String? error;

  /// Creates a copy of this state with the given fields replaced.
  AppInitState copyWith({
    double? progress,
    String? status,
    bool? isReady,
    String? error,
  }) {
    return AppInitState(
      progress: progress ?? this.progress,
      status: status ?? this.status,
      isReady: isReady ?? this.isReady,
      error: error ?? this.error,
    );
  }

  @override
  String toDiagnosticString() =>
      'AppInitState(ready: $isReady, progress: ${progress.toStringAsFixed(2)}, status: $status)';

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
    required LoggerService logger,
  }) : _motusService = motusService,
       _logger = logger,
       super(const AppInitState());

  final MotusService _motusService;
  final LoggerService _logger;

  /// Starts the initialization process.
  Future<void> initialize() async {
    _logger.info('APP_INIT: STARTING_BOOT_SEQUENCE');

    // 1. Listen to Motus loading progress
    _motusService.loadingProgress.addListener(_onMotusProgress);

    // 2. Select and Load Model
    final isMobile = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
    final modelUri = isMobile
        ? 'hf://mradermacher/Llama-3.2-1B-FitnessAssistant-GGUF/Llama-3.2-1B-FitnessAssistant.Q4_K_M.gguf'
        : 'hf://ggml-org/gemma-4-E2B-it-GGUF/gemma-4-E2B-it-Q8_0.gguf';

    try {
      emit(state.copyWith(status: 'CONNECTING_TO_MOTUS_MODEL...'));
      
      await _motusService.initialize(ModelSource.parse(modelUri));

      if (_motusService.initializationError != null) {
        emit(state.copyWith(
          error: _motusService.initializationError,
          status: 'FATAL_CORE_ERROR',
        ));
        return;
      }

      emit(state.copyWith(
        progress: 1.0,
        status: 'SYSTEM_READY_FOR_INPUT',
        isReady: true,
      ));
      
      _logger.success('APP_INIT: BOOT_SEQUENCE_COMPLETE');
    } catch (e, stack) {
      _logger.error('APP_INIT: FATAL_ERROR', error: e, stackTrace: stack);
      emit(state.copyWith(error: e.toString(), status: 'CRITICAL_FAILURE'));
    }
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
    }
  }

  @override
  Future<void> close() {
    _motusService.loadingProgress.removeListener(_onMotusProgress);
    return super.close();
  }
}
