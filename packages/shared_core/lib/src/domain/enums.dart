/// Categorizes the different types of decision-based interactions Motus can initiate.
enum IntentType {
  /// A proactive nudge based on session analysis.
  notification,

  /// A request for user feedback or symptom reporting.
  survey,

  /// A specific biomechanical intervention or workout proposal.
  actionProposal,

  /// A deep-dive synthesis of server-side research.
  researchSummary,

  /// A standard text/voice conversation.
  chat,
}

/// Represents the current lifecycle state of a user's biological or performance objective.
enum GoalStatus {
  /// Currently being tracked and analyzed by Motus.
  active,

  /// Temporarily on hold (e.g., during acute injury flare-up).
  paused,

  /// Objective successfully reached.
  achieved,

  /// No longer pursued by the user.
  abandoned,
}
