import 'package:shared_core/core.dart';

/// Domain service that navigates the Recovery Ladder — a graduated exercise
/// progression framework for injury recovery and performance building.
///
/// Given an exercise ID, current integrity score, and drive level, the service
/// computes the next step (either regression for tissue recovery or progression
/// for strengthening) along with the recommended ring height and coaching mode.
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

  /// Computes the appropriate ladder step for regression or progression.
  ///
  /// Uses heuristic logic to adjust exercise duration, coaching mode, and
  /// ring height based on the current drive level and recovery direction.
  ///
  /// [exerciseId] The exercise identifier from the exercise catalog.
  /// [driveLevel] Drive level between 0.0 (resting) and 1.0 (max effort).
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

  /// Resolves the coaching mode based on drive level and recovery direction.
  ///
  /// Regression always uses neural priming to maintain motor patterns with reduced load.
  /// Progression uses structural loading when drive level exceeds 0.7, otherwise neural priming.
  static String _resolveMode(double driveLevel, bool isRegression) {
    if (isRegression) {
      return 'neural_priming';
    }
    return driveLevel > 0.7 ? 'structural_loading' : 'neural_priming';
  }
}

/// Result type for progression ladder.
/// Detailed prescription for a single Recovery Ladder step.
///
/// Contains all information needed to present the recommended exercise to the
/// user, including biomechanical parameters, coaching rationale, and ring setup.
class ExerciseDetails {
  /// Creates a prescribed Recovery Ladder exercise step with all parameters.
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
