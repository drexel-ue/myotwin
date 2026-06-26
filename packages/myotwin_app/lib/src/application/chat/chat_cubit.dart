import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myotwin_app/src/infrastructure/chat/chat_repository.dart';
import 'package:shared_core/shared_core.dart';
import 'package:uuid/uuid.dart';

/// The UI state for the HUD chat interaction.
class ChatState implements Loggable {
  /// Creates a [ChatState].
  const ChatState({
    this.messages = const [],
    this.isProcessing = false,
    this.isThinking = false,
    this.isResponding = false,
    this.isTransitioning = false,
    this.activeGoal,
    this.pendingToolCalls = const [],
    this.statusUpdate,
  });

  /// Full conversation history from the database.
  final List<IntentRecord> messages;

  /// Whether Motus is currently generating a response.
  final bool isProcessing;

  /// Whether the agent is in the initial inference/thinking phase.
  final bool isThinking;

  /// Whether the agent is currently streaming a response or GenUI.
  final bool isResponding;

  /// Whether the UI is currently transitioning between goal contexts.
  final bool isTransitioning;

  /// The current active goal context.
  final Goal? activeGoal;

  /// Pending tool calls that should be executed by the UI layer.
  final List<ChatToolCallEvent> pendingToolCalls;

  /// A transient status update from the AI (e.g. "Searching index...").
  final String? statusUpdate;

  /// Shortcut for the active goal ID.
  String? get activeGoalId => activeGoal?.id;

  /// Creates a copy of this state with the given fields replaced.
  ChatState copyWith({
    List<IntentRecord>? messages,
    bool? isProcessing,
    bool? isThinking,
    bool? isResponding,
    bool? isTransitioning,
    Goal? activeGoal,
    List<ChatToolCallEvent>? pendingToolCalls,
    bool clearPendingToolCalls = false,
    String? statusUpdate,
    bool clearStatusUpdate = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isProcessing: isProcessing ?? this.isProcessing,
      isThinking: isThinking ?? this.isThinking,
      isResponding: isResponding ?? this.isResponding,
      isTransitioning: isTransitioning ?? this.isTransitioning,
      activeGoal: activeGoal ?? this.activeGoal,
      pendingToolCalls: clearPendingToolCalls ? const [] : (pendingToolCalls ?? this.pendingToolCalls),
      statusUpdate: clearStatusUpdate ? null : (statusUpdate ?? this.statusUpdate),
    );
  }

  @override
  String toDiagnosticString() =>
      'ChatState(msgs: ${messages.length}, thinking: $isThinking, responding: $isResponding, goal: ${activeGoal?.label}, tools: ${pendingToolCalls.length}, status: $statusUpdate)';

  @override
  String toSummaryString() => 'CHAT: ${messages.length} msgs | GOAL: ${activeGoal?.label}';

  @override
  String toString() => toDiagnosticString();
}

/// Manages the dynamic chat interaction loop and AI streaming.
class ChatCubit extends Cubit<ChatState> {
  /// Creates a [ChatCubit].
  ChatCubit({
    required ChatRepository repository,
  }) : _repository = repository,
       super(const ChatState());

  final ChatRepository _repository;
  StreamSubscription<List<IntentRecord>>? _historySubscription;

  /// Hydrates the chat history and ensures an active goal exists.
  Future<void> initialize() async {
    final goalId = await _repository.getOrCreateActiveGoalId();
    final goal = await _repository.getGoal(goalId);

    emit(state.copyWith(activeGoal: goal));

    await _historySubscription?.cancel();
    _historySubscription = _repository.watchMessages(goalId).listen((messages) {
      emit(state.copyWith(messages: messages));
    });
  }

  /// Dispatches a predefined prompt and explicitly sets the expert context, bypassing the router.
  Future<bool> quickAction(String text, MotusExpert expert) async {
    final currentGoal = state.activeGoal;
    if (currentGoal != null) {
       final newMetadataData = Map<String, dynamic>.from(currentGoal.metadata.data);
       newMetadataData['expert'] = expert.name;
       final newGoal = currentGoal.copyWith(metadata: GoalMetadata(newMetadataData));
       
       await _repository.updateGoal(newGoal);
       emit(state.copyWith(activeGoal: newGoal));
    }
    
    return submit(text);
  }

  /// Submits a user message and triggers the AI response stream.
  /// Returns true if the interaction was successful.
  Future<bool> submit(String text) async {
    final goalId = state.activeGoalId;
    if (goalId == null || text.trim().isEmpty) return false;

    final currentToolCalls = <ChatToolCallEvent>[];

    try {
      // 1. Persist the user's message
      final userIntent = IntentRecord(
        id: const Uuid().v4(),
        goalId: goalId,
        type: IntentType.chat,
        scheduledTime: DateTime.now(),
        reason: 'USER_INPUT',
        payload: IntentPayload({
          'items': [
            {
              'type': 'terminal_text',
              'data': {'text': text},
            },
          ],
        }),
      );
      await _repository.saveIntent(userIntent);

      // 2. Start AI streaming
      emit(
        state.copyWith(
          isProcessing: true,
          isThinking: true,
          isResponding: false,
          clearPendingToolCalls: true,
        ),
      );

      final responseId = const Uuid().v4();
      final buffer = StringBuffer();

      // Determine the active expert
      final expertStr = state.activeGoal?.metadata.data['expert'] as String?;
      var targetExpert = MotusExpert.router;
      
      if (expertStr != null) {
        targetExpert = MotusExpert.values.firstWhere(
          (e) => e.name == expertStr,
          orElse: () => MotusExpert.router,
        );
      }

      if (targetExpert == MotusExpert.router) {
         emit(state.copyWith(statusUpdate: 'Analyzing intent...'));
         await _repository.setExpert(MotusExpert.router);
         
         final routerStream = _repository.getResponseStream(text, context: state.messages);
         final routerBuffer = StringBuffer();
         await for (final event in routerStream) {
           if (event is ChatTextEvent) {
             routerBuffer.write(event.text);
           }
         }
         
         final routerResult = routerBuffer.toString().toUpperCase();
         if (routerResult.contains('[ANATOMY]')) {
           targetExpert = MotusExpert.anatomy;
         } else if (routerResult.contains('[REHAB]')) {
           targetExpert = MotusExpert.rehab;
         } else if (routerResult.contains('[SCHEDULER]')) {
           targetExpert = MotusExpert.scheduler;
         } else {
           // Default fallback
           targetExpert = MotusExpert.anatomy;
         }
         
         // Persist this expert for the rest of the conversation
         final currentGoal = state.activeGoal;
         if (currentGoal != null) {
           final newMetadataData = Map<String, dynamic>.from(currentGoal.metadata.data);
           newMetadataData['expert'] = targetExpert.name;
           final newGoal = currentGoal.copyWith(metadata: GoalMetadata(newMetadataData));
           
           await _repository.updateGoal(newGoal);
           emit(state.copyWith(activeGoal: newGoal));
         }
      }

      emit(state.copyWith(statusUpdate: 'Consulting Expert...'));
      await _repository.setExpert(targetExpert);

      final stream = _repository.getResponseStream(text, context: state.messages);

      var hasReceivedTokens = false;

      await for (final event in stream) {
        if (event is ChatTextEvent) {
          if (!hasReceivedTokens) {
            hasReceivedTokens = true;
            // First token received: Move from Thinking to Responding
            emit(
              state.copyWith(
                isThinking: false,
                isResponding: true,
              ),
            );
          }

          // Strip tool call tags that leak into the text stream
          // Handles <|tool_call|>, <|tool_call>, etc.
          final cleanText = event.text.replaceAll(RegExp(r'<\|?tool_call\|?>.*', dotAll: true), '');
          if (cleanText.isNotEmpty) {
            buffer.write(cleanText);
          }
        } else if (event is ChatThoughtEvent) {
          emit(state.copyWith(statusUpdate: event.status));
        } else if (event is ChatThinkingEvent) {
          // If we receive raw reasoning tokens, show a generic status
          // to avoid cluttering the UI with too much raw logic,
          // but enough to let the user know the "brain" is active.
          if (state.statusUpdate == null) {
            emit(state.copyWith(statusUpdate: 'Motus is analyzing biomechanics...'));
          }
        } else if (event is ChatToolCallEvent) {
          currentToolCalls.add(event);
        }
      }

      // 3. Synthesize payload and persist Motus response
      final payloadItems = <Map<String, dynamic>>[];
      var finalText = buffer.toString().trim();

      if (currentToolCalls.isNotEmpty) {
        final toolTexts = <String>[];
        for (final tc in currentToolCalls) {
          if (tc.toolName == 'set_anatomy_layer') {
            final layerStr = tc.arguments['layer'] as String? ?? 'anatomy';
            if (layerStr == 'default') {
              toolTexts.add('Restoring Default View.');
            } else {
              final capitalizedLayer =
                  layerStr.isNotEmpty ? '${layerStr[0].toUpperCase()}${layerStr.substring(1)}' : layerStr;
              toolTexts.add('Isolating $capitalizedLayer System.');
            }
          } else if (tc.toolName == 'highlight_anatomy_node') {
            final target = tc.arguments['target'] as String? ?? 'area';
            final severity = tc.arguments['severity'] as String? ?? 'medium';
            toolTexts.add('Flagging $target with ${severity.toUpperCase()} priority.');
          } else if (tc.toolName == 'clear_anatomy_highlights') {
            toolTexts.add('Clearing all active anatomical markers.');
          } else if (tc.toolName == 'generate_workout_protocol') {
            toolTexts.add('Generating custom clinical rehab protocol...');
          }

          // Preserve raw data for tracing (applies to ALL tool calls)
          payloadItems.add({
            'type': 'system_tool_call',
            'data': {
              'toolName': tc.toolName,
              'arguments': tc.arguments,
              'raw_output': buffer.toString(),
            },
          });
        }
        if (toolTexts.isNotEmpty) {
          if (finalText.isNotEmpty) finalText += '\n\n';
          finalText += toolTexts.join('\n');
        }
      }

      if (finalText.isEmpty) {
        finalText = "I couldn't identify a specific action or response based on that. Could you provide more details?";
      }

      // Add user-facing text
      payloadItems.add({
        'type': 'terminal_text',
        'data': {'text': finalText},
      });

      final agentIntent = IntentRecord(
        id: responseId,
        goalId: goalId,
        type: IntentType.chat,
        scheduledTime: DateTime.now(),
        reason: 'MOTUS_RESPONSE',
        payload: IntentPayload({'items': payloadItems}),
      );
      await _repository.saveIntent(agentIntent);

      return true;
    } catch (e) {
      developer.log('ChatCubit Error', error: e);
      return false;
    } finally {
      emit(
        state.copyWith(
          isProcessing: false,
          isThinking: false,
          isResponding: false,
          pendingToolCalls: currentToolCalls,
          clearStatusUpdate: true,
        ),
      );
    }
  }

  /// Clears the pending tool calls after they have been handled by the UI.
  void clearToolCalls() {
    emit(state.copyWith(clearPendingToolCalls: true));
  }

  /// Switches the active goal context with a cinematic visual transition.
  Future<void> switchGoal(String newGoalId) async {
    if (state.activeGoalId == newGoalId) return;

    // 1. Trigger visual glitch mask
    emit(state.copyWith(isTransitioning: true));

    // 2. Short delay to allow the glitch to fully cover the screen
    await Future<void>.delayed(const Duration(milliseconds: 400));

    // 3. Swap the database subscription
    await _historySubscription?.cancel();

    final newGoal = await _repository.getGoal(newGoalId);

    _historySubscription = _repository.watchMessages(newGoalId).listen((messages) {
      emit(
        state.copyWith(
          activeGoal: newGoal,
          messages: messages,
        ),
      );
    });

    // 4. Hold the glitch for a moment to allow the new context to "scan in"
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // 5. Clear transition state
    emit(state.copyWith(isTransitioning: false));
  }

  /// Fetches all user goals.
  Future<List<Goal>> fetchGoals() => _repository.fetchGoals();

  @override
  Future<void> close() async {
    await _historySubscription?.cancel();
    return super.close();
  }
}
