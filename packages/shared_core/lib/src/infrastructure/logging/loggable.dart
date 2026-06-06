/// A contract for objects that can be represented as structured log messages.
///
/// Implementing [Loggable] ensures that state and domain objects provide
/// consistent, informative output for both detailed diagnostics and
/// high-level summaries.
abstract class Loggable {
  /// A detailed, structured representation of the object's internal state.
  /// Used primarily for developer-facing debug logs or BLoC state transitions.
  String toDiagnosticString();

  /// A concise, human-readable summary of the object.
  /// Used for high-level info logs or potential UI display.
  String toSummaryString() => toDiagnosticString();

  @override
  String toString() => toDiagnosticString();
}
