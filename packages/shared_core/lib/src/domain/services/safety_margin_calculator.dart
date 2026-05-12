/// Calculator for SafetyMargin: determines the safety threshold for body region recovery.
/// Low values trigger GenPop logic. High values unlock Elite cues.
class SafetyMarginCalculator {
  /// Computes the SafetyMargin for a body region.
  ///
  /// [injuryIntegrity] IntegrityScore 0.0–1.0 for the body region.
  /// [acuteSymptomIntensity] Acute symptom intensity 0.0–10.0 (average of recent symptoms).
  /// [consistencyWeight] Defaults to 1.0. Higher weight for consistent recovery patterns.
  ///
  /// Returns safety margin as a double. Higher = more aggressive cues allowed.
  /// Low values (< 0.5) trigger GenPop safety logic.
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

  /// Determines the safety tier for exercise selection.
  ///
  /// [margin] The computed safety margin.
  ///
  /// Returns 'safety' if margin < 1.0 (GenPop logic), 'performance' otherwise (Elite cues allowed).
  static String determineTier(double margin) {
    if (margin < 1.0) {
      return 'safety';
    }
    return 'performance';
  }

  /// Whether Elite cues are unlocked based on safety margin and integrity threshold.
  /// Elite cues require integrity > 0.75 and margin < 5.0 (not dangerously low).
  static bool isEliteUnlocked(double integrityScore, double margin) {
    if (integrityScore < 0.75) return false;
    if (margin < 0.5) return false; // Too unstable
    return true;
  }
}
