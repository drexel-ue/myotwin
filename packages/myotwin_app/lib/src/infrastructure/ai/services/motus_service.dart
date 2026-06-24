import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

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
    required AnatomySemanticService semanticService,
  }) : _engine = engine ?? LlamaEngine(LlamaBackend()),
       _logger = logger,
       _semanticService = semanticService;

  final LlamaEngine _engine;
  final LoggerService _logger;
  final AnatomySemanticService _semanticService;
  ChatSession? _session;
  bool _isInitialized = false;
  String? _initializationError;

  /// Available tools for Motus to call.
  late final List<ToolDefinition> _tools = [
    ToolDefinition(
      name: 'set_anatomy_layer',
      description: 'Isolate a whole anatomical system (skeletal, muscular, nervous, cardiovascular, joints). Use this ONLY when the user asks to "see", "view", or "show" a complete system. Use "default" to reset. DO NOT use this for pain or injury reports.',
      parameters: [
        ToolParam.enumType(
          'layer',
          values: [...AnatomyLayer.values.map((e) => e.name), 'default'],
          description: 'The anatomical system to isolate.',
          required: true,
        ),
      ],
      handler: (params) async => null, // UI handles execution
    ),
    ToolDefinition(
      name: 'highlight_anatomy_node',
      description: 'Mark specific parts or regions with a severity color. Use this for ALL reports of pain, tightness, or injury. If the user mentions a layman area (e.g., "knee"), use `query_anatomy` first to find technical IDs.',
      parameters: [
        ToolParam.string(
          'target',
          description: 'A technical ID (e.g., "Patella_R") or a region found via `query_anatomy`.',
          required: true,
        ),
        ToolParam.enumType(
          'severity',
          values: ['low', 'medium', 'high', 'critical'],
          description: 'The intensity of the pain reported.',
          required: true,
        ),
        ToolParam.string(
          'description',
          description: 'A brief summary of the reported issue.',
        ),
      ],
      handler: (params) async => null, // UI handles execution
    ),
    ToolDefinition(
      name: 'clear_anatomy_highlights',
      description: 'Remove all active highlights from the 3D model.',
      parameters: [],
      handler: (params) async => null, // UI handles execution
    ),
    ToolDefinition(
      name: 'query_anatomy',
      description: 'Search the anatomical database for technical IDs based on layman terms or regions. Use this before highlighting to ensure you have the correct technical ID for the specific part the user is describing.',
      parameters: [
        ToolParam.string(
          'query',
          description: 'The layman term or region to search for (e.g., "bicep", "neck").',
          required: true,
        ),
      ],
      handler: (params) async {
        final query = params.getString('query') ?? '';
        final results = _semanticService.search(query);
        if (results.isEmpty) {
          return {'error': 'No matches found for "$query". Ask the user to clarify.'};
        }
        // Only return necessary fields to keep token count low
        // Return max 15 results to avoid overwhelming context
        return results.take(15).map((e) => {'id': e.id, 'name': e.laymanName}).toList();
      },
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
    String systemPrompt = 'You are Motus, an advanced biomechanical coaching intelligence. You MUST ALWAYS provide a written text response to the user explaining your findings or actions. If you search for anatomy and cannot find a specific target, explain this to the user instead of staying silent.',
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
      var contents = <LlamaContentPart>[LlamaTextContent(message)];

      while (true) {
        await for (final chunk in _session!.create(contents, tools: _tools)) {
          if (chunk.choices.isEmpty) continue;
          final delta = chunk.choices.first.delta;

          if (delta.thinking != null) {
            yield ChatThinkingEvent(delta.thinking!);
          }

          final text = delta.content;
          if (text != null) {
            yield ChatTextEvent(text);
          }
        }

        // ... yields thinking and text ...
        contents = [];

        final lastMessage = _session!.history.last;
        _logger
          ..detail('MOTUS_SERVICE: LAST_MESSAGE_ROLE: ${lastMessage.role.name}')
          ..detail('MOTUS_SERVICE: MESSAGE_PARTS_COUNT: ${lastMessage.parts.length}');

        for (final part in lastMessage.parts) {
          _logger.detail('MOTUS_SERVICE: PART_TYPE: ${part.runtimeType}');
          if (part is LlamaTextContent) {
            _logger.detail(
              'MOTUS_SERVICE: TEXT_PART_PREVIEW: ${part.text.substring(0, math.min(20, part.text.length))}',
            );
          }
        }

        if (lastMessage.role != LlamaChatRole.assistant || lastMessage.parts.isEmpty) break;

        final toolCalls = lastMessage.parts.whereType<LlamaToolCallContent>().toList();
        _logger.detail('MOTUS_SERVICE: DETECTED_TOOL_CALLS: ${toolCalls.length}');

        if (toolCalls.isEmpty) {
          // If no tool calls and no text (parts.isEmpty handled above), just break
          break;
        }

        final toolResults = <LlamaContentPart>[];

        for (final toolCall in toolCalls) {
          _logger.info('MOTUS_SERVICE: PROCESSING_TOOL: ${toolCall.name}');

          // If the tool is 'query_anatomy', we handle it internally and feed results back.
          if (toolCall.name == 'query_anatomy') {
            final query = toolCall.arguments['query'] as String? ?? 'anatomy';
            yield ChatThoughtEvent('Searching anatomical index for "$query"...');

            final definition = _tools.firstWhere((t) => t.name == 'query_anatomy');
            final result = await definition.invoke(toolCall.arguments);

            toolResults.add(
              LlamaToolResultContent(
                id: toolCall.id,
                name: toolCall.name,
                result: jsonEncode(result),
              ),
            );
          } else {
            // It's a terminal/external tool (UI handles it)
            if (toolCall.name == 'highlight_anatomy_node') {
              final target = toolCall.arguments['target'] as String? ?? 'area';
              yield ChatThoughtEvent('Resolving technical mesh targets for "$target"...');
            } else if (toolCall.name == 'set_anatomy_layer') {
              yield const ChatThoughtEvent('Adjusting anatomical layers...');
            }

            _logger.info('MOTUS_SERVICE: YIELDING_EXTERNAL_TOOL: ${toolCall.name}');
            yield ChatToolCallEvent(
              toolName: toolCall.name,
              arguments: toolCall.arguments,
            );
            
            // Provide immediate success result so the LLM can continue reasoning
            toolResults.add(
              LlamaToolResultContent(
                id: toolCall.id,
                name: toolCall.name,
                result: jsonEncode({'status': 'success'}),
              ),
            );
          }
        }

        if (toolResults.isNotEmpty) {
          _session!.addMessage(
            LlamaChatMessage.withContent(
              role: LlamaChatRole.tool,
              content: toolResults,
            ),
          );

          _logger.detail('MOTUS_SERVICE: CONTINUING_INFERENCE_LOOP');
          // Provide empty contents to let the assistant generate the next response directly from history
          contents = const [];
          continue;
        }

        break;
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
