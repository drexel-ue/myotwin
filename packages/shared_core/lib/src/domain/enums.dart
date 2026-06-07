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

/// The distinct anatomical systems available in the MyoTwin 3D model.
enum AnatomyLayer {
  /// All major bones.
  skeletal,

  /// Major muscle groups.
  muscular,

  /// Brain, spinal cord, and major nerves.
  nervous,

  /// Heart and major blood vessels.
  cardiovascular,

  /// Joint capsules and ligaments.
  joints,

  /// Points where muscles connect to bones.
  insertions,
}

/// Categorizes the different high-level commands available in the radial menu.
enum QuickCommand {
  /// Log a physical symptom or flare-up.
  logSymptom,

  /// Revert the last 3D scene state or camera transformation.
  revertLadder,

  /// Toggle the translucent X-Ray material overlay.
  xrayOverlay,

  /// Open the semantic search sidebar for anatomical targeting.
  anatomyTargeter,

  /// Open the biological objectives and research explorer.
  goalExplorer,

  /// Toggle the heatmap visualization layer.
  bodyHeatmap,

  /// Calibrate sensors or the 3D model orientation.
  calibrate,

  /// Open the HUD theme and PBR calibration window.
  themeSettings,

  /// Fallback for unrecognized interactions.
  unknown,
}
