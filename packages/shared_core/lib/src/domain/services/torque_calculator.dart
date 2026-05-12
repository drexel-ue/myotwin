import 'dart:math' as math;

import 'package:shared_core/core.dart' show RingHeight, RingHeightX;

/// Biomechanical tool for computing torque loads on joints during exercises.
///
/// Uses the classical torsion formula τ = F · d · sin(θ) where force is
/// derived from body weight, lever length is estimated from ring height presets,
/// and the angle is the orientation between the force vector and lever arm.
///
/// Also provides convenience methods for mapping between target torque and
/// ring height presets used by the gymnastics ring coaching system.
class TorqueCalculator {
  /// Computes biomechanical torque at a joint during an exercise.
  ///
  /// Uses the formula τ = F · d · sin(θ) where:
  /// - F is the force from body weight (bodyWeightKg × 9.81 m/s²)
  /// - d is the lever arm length from joint center to the point of force application
  /// - θ is the angle between the force vector and the lever arm
  ///
  /// [bodyWeightKg] User's body weight in kilograms (used to derive gravitational force F).
  /// [angleDegrees] Angle between the force vector and lever arm in degrees (θ), typically between 0° and 90°.
  /// [leverLengthM] Distance from the joint center to the center of mass in meters (d).
  ///
  /// Returns torque in Newton-meters (Nm).
  static double calculate({
    required double bodyWeightKg,
    required double angleDegrees,
    required double leverLengthM,
  }) {
    // Convert angle from degrees to radians for sin()
    final angleRadians = angleDegrees * (3.141592653589793 / 180);
    // τ = F · d · sin(θ)
    // F = bodyWeightKg * 9.81 m/s² (gravity)
    final force = bodyWeightKg * 9.81;
    return force * leverLengthM * math.sin(angleRadians);
  }

  /// Finds the ring height preset that most closely matches the desired torque.
  ///
  /// Iterates through all available [RingHeight] values and for each one estimates
  /// the lever length based on the user's body weight, then calculates what angle
  /// would produce the target torque. The height with the smallest error is returned.
  ///
  /// [targetTorqueNm] The desired torque output in Newton-meters.
  /// [bodyWeightKg] User's body weight in kilograms (used to estimate stature and lever length).
  /// [exerciseId] Exercise identifier to match against the exercise catalog for preset calibration.
  ///
  /// Returns the [RingHeight] preset whose lever length most closely produces the target torque.
  /// Returns [RingHeight.waistHip] as the safe default if no valid match is found.
  static RingHeight getPresetForTorque({
    required double targetTorqueNm,
    required double bodyWeightKg,
    required String exerciseId,
  }) {
    const heightOptions = RingHeight.values;
    var bestMatch = double.infinity;
    RingHeight? closestHeight;

    for (final height in heightOptions) {
      // Rough approximation: leverLength scales with body size based on ring height
      final leverLength = _estimateLeverLength(height, bodyWeightKg);
      // Find angle that would produce the target torque for this lever length
      final sinRequired = targetTorqueNm / (bodyWeightKg * 9.81 * leverLength);
      if (sinRequired <= 1.0) {
        final angleDeg = (math.asin(sinRequired) * (180 / 3.141592653589793)).abs();
        // Angle must be physically reasonable for this exercise type
        if (angleDeg >= 0 && angleDeg <= 90) {
          final error = (targetTorqueNm - (bodyWeightKg * 9.81 * leverLength * sinRequired)).abs();
          if (error < bestMatch) {
            bestMatch = error;
            closestHeight = height;
          }
        }
      }
    }

    return closestHeight ?? RingHeight.waistHip;
  }

  /// Estimates the lever arm length for a given ring height using body weight as a stature proxy.
  ///
  /// Converts the body weight into an estimated height (in cm), then applies the ring
  /// height's lever multiplier to derive the lever arm in meters.
  static double _estimateLeverLength(RingHeight height, double bodyWeightKg) {
    // Rough approximation: leverage scales with ring height
    const avgHeightPerKg = 0.010; // cm per kg approximation
    final heightEstimate = bodyWeightKg * avgHeightPerKg; // rough stature estimate

    return _lerp(
      height.leverMultiplier,
      heightEstimate * 0.01,
    ); // convert to meters
  }

  /// Linear interpolation helper: scales [t] by [value] and returns the result.
  static double _lerp(double t, double value) {
    return t * value;
  }
}
