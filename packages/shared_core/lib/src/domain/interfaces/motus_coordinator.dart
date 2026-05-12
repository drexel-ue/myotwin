import 'package:fpdart/fpdart.dart';

/// Interface for Motus coordinator: manages local and external inference models.
/// At runtime, decides which Motus implementation to use based on availability.
abstract class MotusCoordinator {
  /// Returns the current inference mode: local or external.
  String get currentMode;

  /// Checks if external Ollama model is available on the network.
  Future<bool> get externalModelAvailable;

  /// Sends a message to the Motus inference engine and returns the response.
  ///
  /// [message] The user message or prompt.
  /// [context] Optional context (injury info, active hypotheses, etc.).
  /// [mode] Optional mode override. Defaults to auto-detect based on availability.
  Either<String, Failure> sendMessage(
    String message, {
    Map<String, dynamic>? context,
    String? mode,
  });

  /// Sends a message asynchronously with streaming support.
  ///
  /// [message] The user message or prompt.
  /// [context] Optional context.
  /// [mode] Optional mode override.
  ///
  /// Returns a stream of response chunks.
  Future<Stream<Either<String, Failure>>> sendMessageStreaming(
    String message, {
    Map<String, dynamic>? context,
    String? mode,
  });

  /// Logs a symptom event via Motus tool calling.
  Either<bool, Failure> logSymptomViaMotus({
    required String muscleId,
    required int intensity,
    String? note,
    String? category,
  });

  /// Fetches integrity scores for multiple body segments.
  Future<Map<String, double>> fetchIntegrityScores(List<String> muscleIds);

  /// Gets the current context snapshot for system prompts.
  Future<String> getContextSnapshot();
}

/// Result type for Motus coordination operations, wrapping failures with metadata.
class Failure {
  /// Creates a failure with a message, optional error code, and optional underlying exception.
  const Failure(this.message, {this.code, this.underlying});

  /// Error message describing the failure.
  final String message;

  /// Optional error code for programmatic handling.
  final String? code;

  /// Optional underlying exception that caused the failure.
  final Exception? underlying;

  @override
  String toString() => 'Failure($code: $message)';
}
