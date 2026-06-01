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
    this.activeGoalId,
  });

  /// Full conversation history from the database.
  final List<IntentRecord> messages;

  /// Whether Motus is currently generating a response.
  final bool isProcessing;

  /// Whether the agent is in the initial inference/thinking phase.
  final bool isThinking;

  /// Whether the agent is currently streaming a response or GenUI.
  final bool isResponding;

  /// The current active goal context.
  final String? activeGoalId;

  /// Creates a copy of this state with the given fields replaced.
  ChatState copyWith({
    List<IntentRecord>? messages,
    bool? isProcessing,
    bool? isThinking,
    bool? isResponding,
    String? activeGoalId,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isProcessing: isProcessing ?? this.isProcessing,
      isThinking: isThinking ?? this.isThinking,
      isResponding: isResponding ?? this.isResponding,
      activeGoalId: activeGoalId ?? this.activeGoalId,
    );
  }
}

/// Manages the dynamic chat interaction loop and AI streaming.
class ChatCubit extends Cubit<ChatState> {
  /// Creates a [ChatCubit].
  ChatCubit({
    required ChatRepository repository,
  })  : _repository = repository,
        super(const ChatState());

  final ChatRepository _repository;
  StreamSubscription<List<IntentRecord>>? _historySubscription;

  /// Hydrates the chat history and ensures an active goal exists.
  Future<void> initialize() async {
    final goalId = await _repository.getOrCreateActiveGoalId();
    emit(state.copyWith(activeGoalId: goalId));

    await _historySubscription?.cancel();
    _historySubscription = _repository.watchMessages(goalId).listen((messages) {
      emit(state.copyWith(messages: messages));
    });
  }

  /// Submits a user message and triggers the AI response stream.
  /// Returns true if the interaction was successful.
  Future<bool> submit(String text) async {
    if (state.activeGoalId == null || text.trim().isEmpty) return false;

    try {
      // 1. Persist the user's message
      final userIntent = IntentRecord(
        id: const Uuid().v4(),
        goalId: state.activeGoalId!,
        type: IntentType.chat,
        scheduledTime: DateTime.now(),
        reason: 'USER_INPUT',
        payload: IntentPayload({
          'items': [
            {
              'type': 'terminal_text',
              'data': {'text': text},
            }
          ]
        }),
      );
      await _repository.saveIntent(userIntent);

      // 2. Start AI streaming
      emit(state.copyWith(
        isProcessing: true,
        isThinking: true,
        isResponding: false,
      ));

      final responseId = const Uuid().v4();
      final buffer = StringBuffer();

      final stream =
          _repository.getResponseStream(text, context: state.messages);

      var hasReceivedTokens = false;

      await stream.forEach((token) {
        if (!hasReceivedTokens) {
          hasReceivedTokens = true;
          // First token received: Move from Thinking to Responding
          emit(state.copyWith(
            isThinking: false,
            isResponding: true,
          ));
        }
        buffer.write(token);
      });

      // 3. Persist finalized Motus response
      final agentIntent = IntentRecord(
        id: responseId,
        goalId: state.activeGoalId!,
        type: IntentType.chat,
        scheduledTime: DateTime.now(),
        reason: 'MOTUS_RESPONSE',
        payload: IntentPayload({
          'items': [
            {
              'type': 'terminal_text',
              'data': {'text': buffer.toString()},
            }
          ]
        }),
      );
      await _repository.saveIntent(agentIntent);
      return true;
    } catch (e) {
      developer.log('ChatCubit Error', error: e);
      return false;
    } finally {
      emit(state.copyWith(
        isProcessing: false,
        isThinking: false,
        isResponding: false,
      ));
    }
  }

  @override
  Future<void> close() async {
    await _historySubscription?.cancel();
    return super.close();
  }
}
