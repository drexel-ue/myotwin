import 'dart:async';
import 'package:flutter/material.dart';
import 'package:llamadart/llamadart.dart'
    show ChatSession, LlamaBackend, LlamaEngine, LlamaTextContent, ModelLoadOptions, ModelSource;
import 'package:shared_core/shared_core.dart';

/// A concrete implementation of [MotusAgent] that uses the `llamadart`
/// engine for high-performance local LLM inference.
class LocalMotusAgent extends ChangeNotifier implements MotusAgent {
  /// Creates a [LocalMotusAgent].
  LocalMotusAgent({
    LlamaEngine? engine,
  }) : _engine = engine ?? LlamaEngine(LlamaBackend());

  final LlamaEngine _engine;
  ChatSession? _session;
  bool _isInitialized = false;
  String? _initializationError;

  /// Notifies about model loading or downloading progress (0.0 to 1.0).
  final ValueNotifier<double> loadingProgress = ValueNotifier(0.0);

  /// Whether the agent has successfully loaded a model and is ready for inference.
  bool get isInitialized => _isInitialized;

  /// Returns the error message if initialization failed.
  String? get initializationError => _initializationError;

  /// Loads an LLM model into memory.
  ///
  /// This must be called before [streamChatResponse].
  Future<void> initialize(
    ModelSource source, {
    ModelLoadOptions? options,
    String systemPrompt = 'You are Motus, a biomechanical coaching intelligence.',
  }) async {
    _initializationError = null;
    loadingProgress.value = 0.0;
    notifyListeners();

    try {
      await _engine.loadModelSource(
        source,
        options: options ?? ModelLoadOptions(),
        onProgress: (progress) {
          final fraction = progress.fraction;
          if (fraction != null) {
            loadingProgress.value = fraction;
          }
        },
      );
      _session = ChatSession(_engine, systemPrompt: systemPrompt);
      _isInitialized = true;
      loadingProgress.value = 1.0;
    } catch (e) {
      _initializationError = e.toString();
      _isInitialized = false;
    } finally {
      notifyListeners();
    }
  }

  @override
  Stream<String> streamChatResponse(
    String message, {
    List<IntentRecord>? context,
  }) async* {
    if (!_isInitialized || _session == null) {
      throw StateError('LocalMotusAgent must be initialized before use.');
    }

    // Convert message into llamadart content
    final contents = [LlamaTextContent(message)];

    // Stream chunks from the session
    await for (final chunk in _session!.create(contents)) {
      final delta = chunk.choices.first.delta.content;
      if (delta != null) {
        yield delta;
      }
    }
  }

  @override
  Future<IntentRecord> evaluateSession(Object session) {
    // TODO: Implement heuristic session analysis
    throw UnimplementedError('Heuristic session evaluation not yet implemented.');
  }

  @override
  Future<void> dispose() async {
    await _engine.dispose();
    super.dispose();
  }
}
