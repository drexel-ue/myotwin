/// Enumeration of hypothesis status in the scientific method loop.
enum HypothesisStatus {
  /// Hypothesis is currently being tested
  active,

  /// Hypothesis was supported by evidence
  proven,

  /// Hypothesis was contradicted by evidence
  refuted,

  /// Hypothesis was dismissed by the user
  blacklisted,
}
