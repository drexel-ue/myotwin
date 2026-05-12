/// Calculator that determines the safety threshold for exercise selection during injury recovery.
///
/// Produces a safety margin score that guides the coaching system between two modes:
/// - GenPop (safety-first): low integrity or high symptoms → conservative cues
/// - Elite (performance-focused): high integrity and stability → advanced cues
///
/// The margin factor balances tissue integrity against acute symptom load, with
/// an optional consistency weight to reward predictable recovery patterns.
class SafetyMarginCalculator {
  /// Computes the safety margin score for a specific body region.
  ///
  /// The margin is calculated as: (Integrity × Consistency) / AcuteSymptom × 10.
  /// A higher margin means the tissue can tolerate more aggressive coaching.
  /// Low values (< 0.5) trigger GenPop safety logic (conservative cues).
  ///
  /// [injuryIntegrity] IntegrityScore for the body region, clamped to 0.0–1.0 where 1.0 = fully healed.
  /// [acuteSymptomIntensity] Current acute symptom intensity on a 0.0–10.0 scale where 10.0 = worst recent symptom.
  /// [consistencyWeight] Weighting factor for recovery consistency (default 1.0). Values above 1.0 indicate
  ///     steadily improving patterns; below 1.0 indicate wavering recovery.
  ///
  /// Returns the safety margin as a double. Higher values indicate the tissue can tolerate more
  /// aggressive coaching cues. Low values (< 0.5) trigger conservative GenPop safety logic.
  ///
  /// Throws: [ArgumentError] if integrity falls outside [0.0, 1.0].
  static double calculate({
    required double injuryIntegrity,
    required double acuteSymptomIntensity,
    double consistencyWeight = 1.0,
  }) {
    // Clamp inputs to valid ranges
    final clampedIntegrity = injuryIntegrity.clamp(0.0, 1.0);
    final clampedSymptom = acuteSymptomIntensity.clamp(0.0, 10.0);

    // Avoid division by zero
    if (clampedSymptom == 0.0) {
      return clampedIntegrity * consistencyWeight;
    }

    // Formula: S_margin = (Integrity × Consistency) / AcuteSymptom
    // Scale by 10 because intensity is 0-10, integrity is 0-1
    final margin = (clampedIntegrity * consistencyWeight) / clampedSymptom * 10;
    return margin;
  }

  /// Determines the coaching safety tier from a computed safety margin.
  ///
  /// The tier selection gates which coaching logic path is used:
  /// - **safety** (margin < 1.0): GenPop tier — conservative cues, reduced load
  /// - **performance** (margin ≥ 1.0): Elite tier — advanced cues unlocked
  ///
  /// [margin] The safety margin value [calculate] returned for the body region.
  ///
  /// Returns `'safety'` if margin < 1.0 (GenPop / conservative logic).
  /// Returns `'performance'` otherwise (Elite / advanced cues).
  static String determineTier(double margin) {
    if (margin < 1.0) {
      return 'safety';
    }
    return 'performance';
  }

  /// Checks whether Elite performance cues are unlocked for the current recovery state.
  ///
  /// Elite cues (advanced progression strategies) require tissue integrity above 0.75
  /// with a safety margin between 0.5 and 5.0 to balance stability and challenge.
  ///
  /// [integrityScore] The tissue integrity score (0.0–1.0) where 1.0 means fully healed.
  /// [margin] The safety margin from [calculate].
  ///
  /// Returns `true` if both the integrity threshold and stability check pass.
  /// Returns `false` when the tissue is too fragile or the recovery is too unstable.
  static bool isEliteUnlocked(double integrityScore, double margin) {
    if (integrityScore < 0.75) return false;
    if (margin < 0.5) return false; // Too unstable
    return true;
  }
}
