import 'package:shared_core/src/domain/intent_record.dart';

/// Represents a single discrete event in a streaming Motus conversation.
sealed class ChatEvent {
  const ChatEvent();
}

/// A chunk of plain text from the agent.
class ChatTextEvent extends ChatEvent {
  /// Creates a [ChatTextEvent].
  const ChatTextEvent(this.text);

  /// The text content of this chunk.
  final String text;
}

/// A chunk of raw reasoning/thinking from the agent.
class ChatThinkingEvent extends ChatEvent {
  /// Creates a [ChatThinkingEvent].
  const ChatThinkingEvent(this.thinking);

  /// The raw thinking content.
  final String thinking;
}

/// A synthesized status update about the agent's internal process.
class ChatThoughtEvent extends ChatEvent {
  /// Creates a [ChatThoughtEvent].
  const ChatThoughtEvent(this.status);

  /// The human-readable status message.
  final String status;
}

/// A request from the agent to execute a specific tool.
class ChatToolCallEvent extends ChatEvent {
  /// Creates a [ChatToolCallEvent].
  const ChatToolCallEvent({
    required this.toolName,
    required this.arguments,
  });

  /// The name of the tool to execute.
  final String toolName;

  /// The arguments to pass to the tool.
  final Map<String, dynamic> arguments;
}

/// Represents a known expert domain for Motus.
enum MotusExpert {
  /// Base model zero-shot router.
  router,

  /// Expert on human anatomy and pain mapping.
  anatomy,

  /// Expert on rehabilitation protocols.
  rehab,

  /// Expert on scheduling and routines.
  scheduler,
}

/// The core interface for interacting with the Motus biomechanical intelligence.
///
/// Implementations handle local or remote LLM orchestration, symptom tagging,
/// and decision making.
abstract interface class MotusAgent {
  /// Initiates a streaming conversation with the agent.
  ///
  /// Takes a [message] and an optional [context] of past [IntentRecord]s
  /// to ground the conversation in previous biomechanical decisions.
  Stream<ChatEvent> streamChatResponse(
    String message, {
    List<IntentRecord>? context,
  });

  /// Sets the active expert domain (e.g. by loading a LoRA adapter).
  Future<void> setExpert(MotusExpert expert);

  /// Analyzes a recently completed session to formulate new intents.
  ///
  /// This is a stub for the proactive heuristic engine.
  Future<IntentRecord> evaluateSession(Object session);
}
