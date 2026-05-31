import 'package:shared_core/src/domain/intent_record.dart';

/// The core interface for interacting with the Motus biomechanical intelligence.
///
/// Implementations handle local or remote LLM orchestration, symptom tagging,
/// and decision making.
abstract interface class MotusAgent {
  /// Initiates a streaming conversation with the agent.
  ///
  /// Takes a [message] and an optional [context] of past [IntentRecord]s
  /// to ground the conversation in previous biomechanical decisions.
  Stream<String> streamChatResponse(
    String message, {
    List<IntentRecord>? context,
  });

  /// Analyzes a recently completed session to formulate new intents.
  ///
  /// This is a stub for the proactive heuristic engine.
  Future<IntentRecord> evaluateSession(Object session);
}
