import 'dart:async';
import 'package:flutter/material.dart';
import 'package:llamadart/llamadart.dart';
import 'package:shared_core/shared_core.dart';

/// A single-concern service for high-performance local LLM inference.
///
/// Wraps the `llamadart` engine and manages the model lifecycle and chat sessions.
class MotusService extends ChangeNotifier implements MotusAgent {
  /// Creates a [MotusService].
  MotusService({
    LlamaEngine? engine,
    required LoggerService logger,
  }) : _engine = engine ?? LlamaEngine(LlamaBackend()),
       _logger = logger;

  final LlamaEngine _engine;
  final LoggerService _logger;
  ChatSession? _session;
  bool _isInitialized = false;
  String? _initializationError;

  /// Available tools for Motus to call.
  late final List<ToolDefinition> _tools = [
    ToolDefinition(
      name: 'set_anatomy_layer',
      description: 'Isolate a specific anatomical layer on the 3D model. Use this whenever the user asks to "show", "isolate", "view", or "switch to" a specific system (skeletal, muscular, nervous, cardiovascular, joints). Use "default" to reset to the standard view. Always call this tool immediately if the user mentions an anatomical system.',
      parameters: [
        ToolParam.enumType(
          'layer',
          values: [...AnatomyLayer.values.map((e) => e.name), 'default'],
          description: 'The anatomical layer to isolate, or "default" to reset.',
          required: true,
        ),
      ],
      handler: (params) async => null, // UI handles execution
    ),
  ];


  /// Notifies about model loading or downloading progress (0.0 to 1.0).
  final ValueNotifier<double> loadingProgress = ValueNotifier(0.0);

  /// Whether the agent has successfully loaded a model and is ready for inference.
  bool get isInitialized => _isInitialized;

  /// Returns the error message if initialization failed.
  String? get initializationError => _initializationError;

  /// Loads an LLM model into memory.
  Future<void> initialize(
    ModelSource source, {
    ModelLoadOptions? options,
    String systemPrompt = 'You are Motus, a biomechanical coaching intelligence.',
  }) async {
    _logger.info('MOTUS_SERVICE: INITIALIZING_MODEL_SOURCE');
    _initializationError = null;
    loadingProgress.value = 0.0;
    notifyListeners();

    final progress = _logger.progress('LOADING_MOTUS_MODEL');

    try {
      await _engine.loadModelSource(
        source,
        options: options ?? ModelLoadOptions(),
        onProgress: (p) {
          final fraction = p.fraction;
          if (fraction != null) {
            loadingProgress.value = fraction;
          }
        },
      );
      _session = ChatSession(_engine, systemPrompt: systemPrompt);
      _isInitialized = true;
      loadingProgress.value = 1.0;
      progress.complete('MOTUS_MODEL_READY');
    } catch (e, stack) {
      _initializationError = e.toString();
      _isInitialized = false;
      progress.fail('MOTUS_MODEL_LOAD_FAILED');
      _logger.error('MOTUS_SERVICE: INITIALIZATION_ERROR', error: e, stackTrace: stack);
    } finally {
      notifyListeners();
    }
  }

  @override
  Stream<ChatEvent> streamChatResponse(
    String message, {
    List<IntentRecord>? context,
  }) async* {
    if (!_isInitialized || _session == null) {
      _logger.error('MOTUS_SERVICE: ATTEMPTED_INFERENCE_WITHOUT_INITIALIZATION');
      throw StateError('MotusService must be initialized before use.');
    }

    _logger.detail('MOTUS_SERVICE: INFERENCE_START');

    try {
      final contents = [LlamaTextContent(message)];
      await for (final chunk in _session!.create(contents, tools: _tools)) {
        if (chunk.choices.isEmpty) continue;
        final delta = chunk.choices.first.delta;

        final text = delta.content;
        if (text != null) {
          yield ChatTextEvent(text);
        }
      }

      // After the stream completes, check the session history for any tool calls
      // that were accumulated by the ChatSession.
      final lastMessage = _session!.history.last;
      if (lastMessage.role == LlamaChatRole.assistant) {
        for (final part in lastMessage.parts) {
          if (part is LlamaToolCallContent) {
            _logger.info('MOTUS_SERVICE: TOOL_CALL_DETECTED: ${part.name} ${part.arguments}');
            yield ChatToolCallEvent(
              toolName: part.name,
              arguments: part.arguments,
            );
          }
        }
      }

      _logger.detail('MOTUS_SERVICE: INFERENCE_COMPLETE');
    } catch (e, stack) {
      _logger.error('MOTUS_SERVICE: INFERENCE_ERROR', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<IntentRecord> evaluateSession(Object session) {
    throw UnimplementedError('Heuristic session evaluation not yet implemented.');
  }

  @override
  Future<void> dispose() async {
    _logger.info('MOTUS_SERVICE: DISPOSING');
    await _engine.dispose();
    super.dispose();
  }
}
