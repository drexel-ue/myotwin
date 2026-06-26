import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:llamadart/llamadart.dart';
import 'package:shared_core/shared_core.dart';

/// Configuration for a specific expert domain's LoRA adapter.
class LoRAAdapterConfig {
  /// Creates a [LoRAAdapterConfig].
  const LoRAAdapterConfig({
    this.path,
    required this.systemPrompt,
    required this.availableToolNames,
  });

  /// The path to the .gguf LoRA file. If null, the base model is used.
  final String? path;

  /// The persona instructions to feed to the LLM.
  final String systemPrompt;

  /// The list of tools this expert is allowed to use.
  final List<String> availableToolNames;
}

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
  
  MotusExpert _currentExpert = MotusExpert.router;

  static const Map<MotusExpert, LoRAAdapterConfig> _expertConfigs = {
    MotusExpert.router: LoRAAdapterConfig(
      systemPrompt: "You are Motus, a smart routing assistant. Classify the user's intent into one of the following domains: [ANATOMY], [REHAB], [SCHEDULER], or [GENERAL]. Reply ONLY with the domain tag.",
      availableToolNames: [],
    ),
    MotusExpert.anatomy: LoRAAdapterConfig(
      // We assume the adapter is served or downloaded to assets/models
      path: 'packages/motus_server/assets/models/anatomy_expert_lora-unsloth.Q4_K_M.gguf',
      systemPrompt: 'You are Motus, an expert biomechanical AI. You MUST ALWAYS provide a written text response to the user explaining your findings or actions. If you search for anatomy and cannot find a specific target, explain this to the user instead of staying silent. Use your tools to highlight anatomy related to pain or injury.',
      availableToolNames: ['query_anatomy', 'highlight_anatomy_node', 'set_anatomy_layer', 'clear_anatomy_highlights'],
    ),
    MotusExpert.rehab: LoRAAdapterConfig(
      path: 'packages/motus_server/assets/models/rehab_expert_lora-unsloth.Q4_K_M.gguf',
      systemPrompt: 'You are Motus, a world-class AI physical therapist and rehabilitation expert. Your goal is to help users address their aches and pains by generating highly specific rehab and workout protocols based on clinical knowledge.',
      availableToolNames: ['generate_workout_protocol'],
    ),
    // Additional experts will be added here
  };

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
    ToolDefinition(
      name: 'generate_workout_protocol',
      description: 'Generates a structured physical therapy or workout protocol based on the users described symptoms and clinical goals.',
      parameters: [
        ToolParam.string(
          'target_area',
          description: 'The body part or area the protocol targets.',
        ),
        ToolParam.array(
          'focus_areas',
          itemType: ToolParam.string('focus', description: 'A focus area (e.g. strength, mobility)'),
          description: 'Key areas to focus on for this protocol.',
        ),
        ToolParam.array(
          'exercises',
          itemType: ToolParam.string('exercise', description: 'Name of the exercise'),
          description: 'A list of specific exercises to include in the protocol.',
        ),
        ToolParam.string(
          'intensity',
          description: 'The recommended intensity level (e.g. low, moderate, progressive).',
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
      
      // Initialize with Router as default
      await setExpert(MotusExpert.router);
      
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
  Future<void> setExpert(MotusExpert expert) async {
    _logger.info('MOTUS_SERVICE: SETTING_EXPERT: ${expert.name}');
    final config = _expertConfigs[expert]!;
    
    // Clear any existing LoRA adapters
    await _engine.clearLoras();
    
    // Load new adapter if one is configured for this domain
    if (config.path != null) {
      _logger.info('MOTUS_SERVICE: LOADING_LORA: ${config.path}');
      try {
        await _engine.setLora(config.path!);
      } catch (e, stack) {
         _logger.error('MOTUS_SERVICE: FAILED_TO_LOAD_LORA: ${config.path}', error: e, stackTrace: stack);
         // Gracefully fallback to base model if adapter file is missing
      }
    }

    _currentExpert = expert;
    
    // Preserve history when recreating session
    final history = _session?.history.toList() ?? [];
    _session = ChatSession(_engine, systemPrompt: config.systemPrompt);
    for (final message in history) {
      // Don't carry over system prompts from previous sessions, just chat messages
      if (message.role != LlamaChatRole.system) {
        _session!.addMessage(message);
      }
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
      
      final activeConfig = _expertConfigs[_currentExpert]!;
      final activeTools = _tools.where((t) => activeConfig.availableToolNames.contains(t.name)).toList();

      while (true) {
        await for (final chunk in _session!.create(contents, tools: activeTools)) {
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
            } else if (toolCall.name == 'generate_workout_protocol') {
              yield const ChatThoughtEvent('Structuring clinical rehab protocol...');
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
