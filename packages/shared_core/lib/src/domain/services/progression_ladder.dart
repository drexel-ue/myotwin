import 'package:shared_core/core.dart';

/// Domain service for ProgressionLadder use case.
/// Determines regression/progression steps on the Recovery Ladder.
class ProgressionLadder {
  /// Determines the next exercise step on the recovery ladder.
  ///
  /// [exerciseId] Exercise ID from the exercise catalog.
  /// [currentIntegrity] IntegrityScore for the relevant body segment.
  /// [direction] Optional: 'regression' or 'progression'. Auto-determined by integrity if omitted.
  /// [driveLevel] Optional: 0.0–1.0 current drive setting (default 0.5).
  ///
  /// Returns an [ExerciseDetails] with the recommended step.
  static ExerciseDetails getNextStep({
    required String exerciseId,
    required double currentIntegrity,
    String? direction,
    double driveLevel = 0.5,
  }) {
    final isRegression = direction == 'regression' || (direction == null && currentIntegrity < 0.7);

    // Regression/progression ladder steps
    final steps = _getLadderSteps(exerciseId, driveLevel, isRegression);

    return steps;
  }

  /// Internal ladder steps for a given exercise.
  ///
  /// [exerciseId] The exercise identifier.
  /// [driveLevel] Drive level 0.0–1.0.
  /// [isRegression] Whether to produce a regression (softer) or progression (harder) step.
  static ExerciseDetails _getLadderSteps(
    String exerciseId,
    double driveLevel,
    bool isRegression,
  ) {
    double baseDuration;

    if (isRegression) {
      baseDuration = 30.0 * driveLevel; // shorter duration for regression
    } else {
      baseDuration = 120.0 + 60.0 * driveLevel; // longer duration for progression
    }

    return ExerciseDetails(
      name: '$exerciseId — ${isRegression ? 'Regression' : 'Progression'}',
      description: 'Recovery ladder ${isRegression ? "step down from" : "next step for"} $exerciseId.',
      requiredEquipment: 'none',
      durationSecs: baseDuration.toInt(),
      notes: isRegression ? 'Reduced load for recovery phase.' : 'Increased load for strengthening phase.',
      scientificRationale: isRegression
          ? 'Regression reduces mechanical tension to allow tissue recovery while maintaining motor pattern activation.'
          : 'Progression increases mechanical tension to rebuild tendon and bone integrity.',
      targetMuscles: [],
      ringHeight: isRegression ? RingHeight.knee : RingHeight.waistHip,
      mode: _resolveMode(driveLevel, isRegression),
    );
  }

  static String _resolveMode(double driveLevel, bool isRegression) {
    if (isRegression) {
      return 'neural_priming';
    }
    return driveLevel > 0.7 ? 'structural_loading' : 'neural_priming';
  }
}

/// Result type for progression ladder.
class ExerciseDetails {
  /// Creates exercise details with the recommended step.
  const ExerciseDetails({
    required this.name,
    required this.description,
    this.requiredEquipment,
    this.ringHeight,
    required this.durationSecs,
    this.notes,
    required this.scientificRationale,
    required this.targetMuscles,
    this.mode,
  });

  /// Name of the recommended exercise.
  final String name;

  /// Description of the exercise step.
  final String description;

  /// Required equipment.
  final String? requiredEquipment;

  /// Ring height for gymnastics rings (e.g., waistHip, sternum).
  final RingHeight? ringHeight;

  /// Duration in seconds.
  final int durationSecs;

  /// Additional notes for the user.
  final String? notes;

  /// Clinical biomechanical rationale.
  final String scientificRationale;

  /// Target muscle list.
  final List<String> targetMuscles;

  /// Mode: neural_priming or structural_loading.
  final String? mode;
}
