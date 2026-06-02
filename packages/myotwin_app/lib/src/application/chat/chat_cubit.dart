import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myotwin_app/src/infrastructure/chat/chat_repository.dart';
import 'package:shared_core/shared_core.dart';
import 'package:uuid/uuid.dart';

/// The UI state for the HUD chat interaction.
class ChatState {
  /// Creates a [ChatState].
  const ChatState({
    this.messages = const [],
    this.isProcessing = false,
    this.isThinking = false,
    this.isResponding = false,
    this.isTransitioning = false,
    this.activeGoal,
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
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isProcessing: isProcessing ?? this.isProcessing,
      isThinking: isThinking ?? this.isThinking,
      isResponding: isResponding ?? this.isResponding,
      isTransitioning: isTransitioning ?? this.isTransitioning,
      activeGoal: activeGoal ?? this.activeGoal,
    );
  }
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

  /// Submits a user message and triggers the AI response stream.
  /// Returns true if the interaction was successful.
  Future<bool> submit(String text) async {
    final goalId = state.activeGoalId;
    if (goalId == null || text.trim().isEmpty) return false;

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
        ),
      );

      final responseId = const Uuid().v4();
      final buffer = StringBuffer();

      final stream = _repository.getResponseStream(text, context: state.messages);

      var hasReceivedTokens = false;

      await stream.forEach((token) {
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
        buffer.write(token);
      });

      // 3. Persist finalized Motus response
      final agentIntent = IntentRecord(
        id: responseId,
        goalId: goalId,
        type: IntentType.chat,
        scheduledTime: DateTime.now(),
        reason: 'MOTUS_RESPONSE',
        payload: IntentPayload({
          'items': [
            {
              'type': 'terminal_text',
              'data': {'text': buffer.toString()},
            },
          ],
        }),
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
        ),
      );
    }
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
