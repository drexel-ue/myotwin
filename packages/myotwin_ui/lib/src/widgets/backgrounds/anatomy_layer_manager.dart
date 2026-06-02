import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter_scene/scene.dart';
import 'package:vector_math/vector_math.dart';

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

/// Orchestrates the loading and visual state of the 3D anatomy model.
class AnatomyLayerManager {
  /// Creates an [AnatomyLayerManager] for a specific [Scene].
  AnatomyLayerManager(this._scene);

  final Scene _scene;

  // Root nodes for each layer
  final Map<AnatomyLayer, Node> _layerRoots = {};

  /// The default tactical material for all anatomical meshes.
  late final PhysicallyBasedMaterial _baseMaterial;

  /// The semi-transparent material used for the X-Ray "ghosting" effect.
  late final PhysicallyBasedMaterial _ghostMaterial;

  /// Initializes the materials and loads all 3D assets into the scene.
  Future<void> initialize() async {
    // 1. Setup Tactical PBR Materials
    _baseMaterial = PhysicallyBasedMaterial()
      ..baseColorFactor = Vector4(0.1, 0.1, 0.1, 1.0) // Dark Grey
      ..metallicFactor = 0.9
      ..roughnessFactor = 0.5;

    _ghostMaterial = PhysicallyBasedMaterial()
      ..baseColorFactor = Vector4(1.0, 1.0, 1.0, 0.2) // 20% white
      ..metallicFactor = 1.0
      ..roughnessFactor = 0.3
      ..alphaMode = AlphaMode.blend;

    // 2. Load all layers asynchronously
    await Future.wait(AnatomyLayer.values.map(_loadLayer));

    // 3. Apply Initial Shader Logic
    if (_layerRoots[AnatomyLayer.skeletal] case final node?) {
      _applyMaterial(node, _baseMaterial);
    }
    if (_layerRoots[AnatomyLayer.muscular] case final node?) {
      _applyMaterial(node, _ghostMaterial);
    }
    
    // Hide other systems for now
    _layerRoots[AnatomyLayer.nervous]?.visible = false;
    _layerRoots[AnatomyLayer.cardiovascular]?.visible = false;
    _layerRoots[AnatomyLayer.joints]?.visible = false;
    _layerRoots[AnatomyLayer.insertions]?.visible = false;
  }

  Future<void> _loadLayer(AnatomyLayer layer) async {
    final assetName = 'myotwin_${layer.name}';
    try {
      final node = await Node.fromGlbAsset('assets/models/$assetName.glb');
      node.name = 'LAYER_${layer.name.toUpperCase()}';
      _layerRoots[layer] = node;
      _scene.add(node);
      debugPrint('Loaded Anatomy Layer: ${layer.name}');
    } catch (e) {
      debugPrint('Failed to load Anatomy Layer (${layer.name}): $e');
    }
  }

  /// Recursively applies a [Material] to all meshes in a [Node] tree.
  void _applyMaterial(Node root, Material material) {
    if (root.mesh != null) {
      // Re-link the primitives with the new material
      final primitives = root.mesh!.primitives.map((p) {
        return MeshPrimitive(p.geometry, material);
      }).toList();
      root.mesh = Mesh.primitives(primitives: primitives);
    }
    for (final child in root.children) {
      _applyMaterial(child, material);
    }
  }

  /// Toggles the visibility of an entire anatomical system.
  void setLayerVisibility(AnatomyLayer layer, {required bool isVisible}) {
    _layerRoots[layer]?.visible = isVisible;
  }

  /// Applies a heatmap highlight to a specific mesh by name.
  void highlightNode(String nodeName, flutter.Color color) {
    final colorVec = Vector4(
      color.r,
      color.g,
      color.b,
      color.a,
    );

    // Traverse all layers to find the node
    for (final root in _layerRoots.values) {
      final target = root.getChildByName(nodeName);
      if (target != null) {
        final highlightMat = PhysicallyBasedMaterial()
          ..baseColorFactor = colorVec
          ..emissiveFactor = colorVec;
        _applyMaterial(target, highlightMat);
      }
    }
  }
}
