import 'dart:math' as math;
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart';
import '../../models/anatomy_schema.dart';

/// Drives the procedural animations (blood flow, nerve signals) for the anatomy model.
class ProceduralAnimationEngine {
  /// Creates a [ProceduralAnimationEngine] with the given [schema].
  ProceduralAnimationEngine(this.schema);

  /// The anatomical schema providing node data.
  final AnatomySchema schema;

  // Cardiovascular cache: NodeName -> Distance from heart
  final Map<String, double> _cardioDistances = {};
  
  // Max distance for normalization
  double _maxCardioDist = 1.0;

  /// Initializes the engine by pre-calculating distances for relevant layers.
  void initialize() {
    final cardioLayer = schema.layers['cardiovascular'];
    if (cardioLayer != null) {
      for (final entry in cardioLayer.meshes.entries) {
        final dist = entry.value.boundingCenter.distanceTo(schema.heartCenter);
        _cardioDistances[entry.key] = dist;
        if (dist > _maxCardioDist) _maxCardioDist = dist;
      }
    }
  }

  /// Calculates the emissive factor for a cardiovascular node based on current pulse phase.
  Vector4 getBloodFlowEmissive(String nodeName, double pulsePhase) {
    final dist = _cardioDistances[nodeName];
    if (dist == null) return Vector4.zero();

    final meshSchema = schema.layers['cardiovascular']?.meshes[nodeName];
    if (meshSchema == null) return Vector4.zero();

    final type = meshSchema.proceduralType;
    final isArtery = type.contains('artery') || type.contains('aorta');
    final isVein = type.contains('vein') || type.contains('vena');

    if (!isArtery && !isVein) return Vector4.zero();

    // Pulse Wave Logic:
    // Normalize distance 0.0 to 1.0
    final normDist = dist / _maxCardioDist;
    
    // Wave travels:
    // Arteries: 0.0 -> 1.0 (outwards)
    // Veins: 1.0 -> 0.0 (inwards)
    final wavePos = isArtery ? normDist : (1.0 - normDist);
    
    // Calculate intensity based on pulse phase and wave position
    // We want a sharp peak that travels along the vessels
    const waveWidth = 0.15;
    final shiftedPhase = (pulsePhase * 1.5) % 1.0; // Speed up and loop
    
    // Distance from the wave peak
    final distFromPeak = (wavePos - shiftedPhase).abs();
    final intensity = math.max(0.0, 1.0 - (distFromPeak / waveWidth));
    
    // Apply easing for smoother pulse
    final curveIntensity = math.pow(intensity, 3).toDouble();

    if (isArtery) {
      // Bright red for arteries
      return Vector4(1.0 * curveIntensity, 0.1 * curveIntensity, 0.1 * curveIntensity, 1.0);
    } else {
      // Bright blue for veins
      return Vector4(0.1 * curveIntensity, 0.4 * curveIntensity, 1.0 * curveIntensity, 1.0);
    }
  }
}
