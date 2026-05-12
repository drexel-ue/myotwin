/// Ring height presets mapped to anatomical landmarks for leverage calibration.
enum RingHeight {
  /// Overhead: passive/active hangs, spinal decompression.
  overhead,

  /// Sternum: inclined rows, postural correction.
  sternum,

  /// Waist/hip: support holds, structural loading.
  waistHip,

  /// Knee: push-up variations, moderate load.
  knee,

  /// Floor: planks/rollouts, core compression.
  floor,
}

/// Height multiplier for torque calculations (higher ring = more torque for same exercise).
extension RingHeightX on RingHeight {
  /// Moment arm multiplier: higher rings increase leverage torque for the user's bodyweight.
  double get leverMultiplier {
    switch (this) {
      case RingHeight.overhead:
        return 1.0;
      case RingHeight.sternum:
        return 0.75;
      case RingHeight.waistHip:
        return 0.6;
      case RingHeight.knee:
        return 0.4;
      case RingHeight.floor:
        return 0.25;
    }
  }

  /// Anatomical landmark description.
  String get landmarkDescription {
    switch (this) {
      case RingHeight.overhead:
        return 'Overhead ring position — spinal decompression';
      case RingHeight.sternum:
        return 'Sternum height — inclined rows';
      case RingHeight.waistHip:
        return 'Waist/hip height — support holds';
      case RingHeight.knee:
        return 'Knee height — push-up variations';
      case RingHeight.floor:
        return 'Floor height — planks and rollouts';
    }
  }
}
