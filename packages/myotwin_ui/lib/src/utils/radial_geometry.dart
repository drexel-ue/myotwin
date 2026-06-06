import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A utility class for radial geometry calculations used in HUD menus.
class RadialGeometry {
  /// Calculates the angle of a point relative to a center point.
  /// Returns values in radians [0, 2*pi].
  static double getAngle(Offset point, Offset center) {
    final dx = point.dx - center.dx;
    final dy = point.dy - center.dy;
    var angle = math.atan2(dy, dx);
    if (angle < 0) angle += 2 * math.pi;
    return angle;
  }

  /// Calculates the Euclidean distance between two points.
  static double getDistance(Offset p1, Offset p2) {
    final dx = p1.dx - p2.dx;
    final dy = p1.dy - p2.dy;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Normalizes an angle into the [0, 2*pi] range.
  static double normalizeAngle(double angle) {
    var normalized = angle % (2 * math.pi);
    if (normalized < 0) normalized += 2 * math.pi;
    return normalized;
  }

  /// Calculates the shortest angular distance between two angles.
  static double angularDistance(double a1, double a2) {
    var diff = (a1 - a2).abs();
    if (diff > math.pi) {
      diff = 2 * math.pi - diff;
    }
    return diff;
  }
}
