import 'dart:math' as math;

import 'package:shared_core/core.dart' show RingHeight, RingHeightX;

/// Biomechanical calculator for torque loads.
/// Computes torque using the formula: τ = F · d · sin(θ)
class TorqueCalculator {
  /// Computes biomechanical torque.
  ///
  /// [bodyWeightKg] User body weight in kilograms.
  /// [angleDegrees] Angle between force vector and lever arm in degrees (θ).
  /// [leverLengthM] Distance from joint center to center of mass in meters (d).
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

  /// Computes the target ring height preset for a given torque load.
  ///
  /// [targetTorqueNm] The desired torque output in Newton-meters.
  /// [bodyWeightKg] User body weight in kilograms.
  /// [exerciseId] Exercise identifier to match against the exercise catalog.
  ///
  /// Returns [RingHeight] preset closest to achieving the target torque.
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

  /// Estimates lever length based on ring height and bodyweight (proxy for height).
  static double _estimateLeverLength(RingHeight height, double bodyWeightKg) {
    // Rough approximation: leverage scales with ring height
    const avgHeightPerKg = 0.010; // cm per kg approximation
    final heightEstimate = bodyWeightKg * avgHeightPerKg; // rough stature estimate

    return _lerp(
      height.leverMultiplier,
      heightEstimate * 0.01,
    ); // convert to meters
  }

  static double _lerp(double t, double value) {
    return t * value;
  }
}
