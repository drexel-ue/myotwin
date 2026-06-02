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

  /// Extracts all mesh-bearing node names from the loaded layers, grouped by system.
  Map<AnatomyLayer, List<String>> getAvailableNodesByLayer() {
    final Map<AnatomyLayer, List<String>> result = {};
    for (final entry in _layerRoots.entries) {
      final names = <String>[];
      _collectNodeNames(entry.value, names);
      if (names.isNotEmpty) {
        result[entry.key] = names..sort();
      }
    }
    return result;
  }

  void _collectNodeNames(Node node, List<String> names) {
    // Only collect nodes that actually have a mesh (are visible parts)
    if (node.mesh != null && node.name.isNotEmpty) {
      names.add(node.name);
    }
    for (final child in node.children) {
      _collectNodeNames(child, names);
    }
  }

  /// Isolates a specific layer by making it solid and ghosting all others.
  /// If [activeLayer] is null, restores the default HUD state.
  void isolateLayer(AnatomyLayer? activeLayer) {
    if (activeLayer == null) {
      // Restore Default HUD State
      for (final entry in _layerRoots.entries) {
        final layer = entry.key;
        final node = entry.value;

        if (layer == AnatomyLayer.skeletal) {
          node.visible = true;
          _applyMaterial(node, _baseMaterial);
        } else if (layer == AnatomyLayer.muscular) {
          node.visible = true;
          _applyMaterial(node, _ghostMaterial);
        } else {
          node.visible = false;
        }
      }
      return;
    }

    // Isolate the requested layer
    for (final entry in _layerRoots.entries) {
      final layer = entry.key;
      final node = entry.value;

      node.visible = true;
      if (layer == activeLayer) {
        _applyMaterial(node, _baseMaterial);
      } else {
        _applyMaterial(node, _ghostMaterial);
      }
    }
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

  /// Resets all layers to their default base or ghost materials, clearing highlights.
  void clearHighlights() {
    if (_layerRoots[AnatomyLayer.skeletal] case final node?) {
      _applyMaterial(node, _baseMaterial);
    }
    if (_layerRoots[AnatomyLayer.muscular] case final node?) {
      _applyMaterial(node, _ghostMaterial);
    }
    // Other layers are hidden by default, but we should reset their materials too if we ever show them.
    for (final layer in AnatomyLayer.values) {
      if (layer == AnatomyLayer.skeletal || layer == AnatomyLayer.muscular) continue;
      if (_layerRoots[layer] case final node?) {
        _applyMaterial(node, _baseMaterial);
      }
    }
  }

  /// Projects a 3D node's world position to 2D screen coordinates.
  flutter.Offset? projectNodeToScreen(
    String nodeName,
    Camera camera,
    flutter.Size viewportSize,
  ) {
    for (final root in _layerRoots.values) {
      final target = root.getChildByName(nodeName);
      if (target != null) {
        // 1. Get world position (origin of the node)
        final worldPos = target.globalTransform.getTranslation();

        // 2. Get combined View-Projection matrix
        final viewProj = camera.getViewTransform(viewportSize);

        // 3. Project to Clip Space (NDC)
        final clipPos = viewProj.transform(
          Vector4(worldPos.x, worldPos.y, worldPos.z, 1.0),
        );

        // Perspective divide
        if (clipPos.w <= 0) return null; // Node is behind the camera
        final ndc = Vector3(
          clipPos.x / clipPos.w,
          clipPos.y / clipPos.w,
          clipPos.z / clipPos.w,
        );

        // 4. Map NDC (-1 to 1) to Screen Pixels
        // Flutter: (0,0) top-left.
        // NDC: (-1,-1) bottom-left, (1,1) top-right.
        final x = (ndc.x + 1.0) / 2.0 * viewportSize.width;
        final y = (1.0 - ndc.y) / 2.0 * viewportSize.height;

        return flutter.Offset(x, y);
      }
    }
    return null;
  }
}
