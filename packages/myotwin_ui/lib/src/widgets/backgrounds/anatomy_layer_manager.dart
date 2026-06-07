import 'dart:async';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/scheduler.dart';
import 'package:flutter_scene/scene.dart';
import 'package:shared_core/shared_core.dart';
import 'package:vector_math/vector_math.dart';

/// Orchestrates the loading, visual state, and animations of the 3D anatomy model.
///
/// Uses a declarative reconciliation pattern to ensure consistent visual state
/// across multiple layers and highlighted nodes.
class AnatomyLayerManager extends flutter.ChangeNotifier {
  /// Creates an [AnatomyLayerManager].
  AnatomyLayerManager(this._scene, {required TickerProvider vsync, this.logger}) {
    _fadeController = flutter.AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 600),
    )..addListener(_onTick);

    _pulseController = flutter.AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );
    unawaited(_pulseController.repeat(reverse: true));

    _initMaterials();
  }

  final Scene _scene;

  /// Optional logger for tracking engine initialization and asset loading.
  final LoggerService? logger;

  // Animation Control
  late final flutter.AnimationController _fadeController;
  late final flutter.AnimationController _pulseController;

  // State
  AnatomyLayer? _isolatedLayer;
  final Set<String> _highlightedNodes = {};
  flutter.Color _highlightColor = flutter.Colors.cyan;
  bool _isInitialized = false;

  // The Registry: Map<NodeName, List<Nodes>> for O(1) highlight lookups.
  final Map<String, List<Node>> _nodeRegistry = {};

  // Material Pool: One unique material per layer to allow independent fading.
  final Map<AnatomyLayer, PhysicallyBasedMaterial> _layerMaterials = {};
  final PhysicallyBasedMaterial _highlightMaterial = PhysicallyBasedMaterial();

  // Root nodes for each layer
  final Map<AnatomyLayer, Node> _layerRoots = {};

  /// Whether the manager has finished loading all initial assets.
  bool get isInitialized => _isInitialized;

  /// Returns the current isolated layer, if any.
  AnatomyLayer? get isolatedLayer => _isolatedLayer;

  void _initMaterials() {
    for (final layer in AnatomyLayer.values) {
      _layerMaterials[layer] = PhysicallyBasedMaterial()
        ..baseColorFactor = Vector4(0.1, 0.1, 0.1, 1.0)
        ..metallicFactor = 0.9
        ..roughnessFactor = 0.5;
    }

    _highlightMaterial
      ..baseColorFactor =
          Vector4(0.0, 1.0, 1.0, 1.0) // Default Cyan
      ..emissiveFactor = Vector4(0.0, 1.0, 1.0, 1.0);
  }

  /// Initializes the materials and loads all 3D assets into the scene.
  Future<void> initialize() async {
    final initProgress = logger?.progress('INITIALIZING_ANATOMY_ENGINE');

    // 2. Load all layers asynchronously
    try {
      await Future.wait(AnatomyLayer.values.map(_loadLayer));
      _isInitialized = true;
      reconcile();
      initProgress?.complete('ANATOMY_ENGINE_READY');
      notifyListeners();
    } catch (e) {
      initProgress?.fail('ANATOMY_ENGINE_LOAD_FAILED');
      rethrow;
    }
  }

  Future<void> _loadLayer(AnatomyLayer layer) async {
    final assetName = 'myotwin_${layer.name}';
    final layerProgress = logger?.progress('LOADING_LAYER_${layer.name.toUpperCase()}');

    try {
      final node = await Node.fromGlbAsset('assets/models/$assetName.glb');
      node.name = 'LAYER_${layer.name.toUpperCase()}';
      _layerRoots[layer] = node;
      _scene.add(node);

      // Index all mesh-bearing nodes for fast lookup
      _indexNode(node, layer);

      layerProgress?.complete();
    } catch (e) {
      layerProgress?.fail();
      logger?.error('Failed to load Anatomy Layer (${layer.name})', error: e);
    }
  }

  void _indexNode(Node node, AnatomyLayer layer) {
    if (node.mesh != null && node.name.isNotEmpty) {
      _nodeRegistry.putIfAbsent(node.name, () => []).add(node);

      // Apply the layer-specific material instance initially
      _applyMaterialToNode(node, _layerMaterials[layer]!);
    }
    for (final child in node.children) {
      _indexNode(child, layer);
    }
  }

  /// Declaratively updates the desired visual state.
  void reconcile() {
    if (!_isInitialized) return;

    // Reset fade timer to start new transition
    unawaited(_fadeController.forward(from: 0.0));
  }

  void _onTick() {
    final t = flutter.Curves.easeOut.transform(_fadeController.value);
    final pulse = _pulseController.value;

    // 1. Update Layer Material Alphas
    for (final entry in _layerMaterials.entries) {
      final layer = entry.key;
      final material = entry.value;

      final targetAlpha = _calculateTargetAlpha(layer);
      // Interpolate from current alpha (effectively)
      // Note: for simplicity in this MVP, we lerp toward the goal.
      // A more robust system would track 'startAlpha'.
      final currentAlpha = material.baseColorFactor.w;
      final newAlpha = currentAlpha + (targetAlpha - currentAlpha) * t;

      material
        ..baseColorFactor = Vector4(0.1, 0.1, 0.1, newAlpha)
        ..alphaMode = newAlpha < 0.99 ? AlphaMode.blend : AlphaMode.opaque;

      // Toggle visibility based on alpha threshold to save draw calls
      _layerRoots[layer]?.visible = newAlpha > 0.01;
    }

    // 2. Update Highlight Material Pulse
    final colorVec = Vector4(
      _highlightColor.r,
      _highlightColor.g,
      _highlightColor.b,
      1.0,
    );
    _highlightMaterial
      ..baseColorFactor = colorVec
      ..emissiveFactor = colorVec * (0.5 + pulse * 1.5)
      ..alphaMode = AlphaMode.opaque;

    notifyListeners();
  }

  double _calculateTargetAlpha(AnatomyLayer layer) {
    if (_isolatedLayer == null) {
      // Default HUD State: Skeletal Solid, Muscular Ghosted, Others Hidden
      return switch (layer) {
        AnatomyLayer.skeletal => 1.0,
        AnatomyLayer.muscular => 0.6,
        _ => 0.0,
      };
    }

    // Isolation Mode: Selection "Solid", others 10% ghosted
    if (layer == _isolatedLayer) {
      // Muscles are layered; use 60% opacity to see deeper structures.
      // Other layers are slightly transparent (90%) for a holographic feel.
      return layer == AnatomyLayer.muscular ? 0.6 : 0.9;
    }

    return 0.2;
  }

  /// Isolates a specific layer.
  void isolateLayer(AnatomyLayer? layer) {
    if (_isolatedLayer == layer) return;
    _isolatedLayer = layer;

    // We need to re-assign materials when highlights change
    _refreshMaterialAssignments();
    reconcile();
  }

  /// Highlights specific nodes by name.
  void setHighlights(List<String> nodes, flutter.Color color) {
    _highlightedNodes
      ..clear()
      ..addAll(nodes);
    _highlightColor = color;

    _refreshMaterialAssignments();
    reconcile();
  }

  /// Re-traverses the registry once to assign either Layer-Material or Highlight-Material.
  /// This is called only when the *membership* of the highlight set changes.
  void _refreshMaterialAssignments() {
    // 1. Reset all nodes to their layer materials
    for (final entry in _layerRoots.entries) {
      final layer = entry.key;
      final root = entry.value;
      _applyMaterialRecursive(root, _layerMaterials[layer]!);
    }

    // 2. Override highlighted nodes with the pulsing highlight material
    for (final nodeName in _highlightedNodes) {
      final nodes = _nodeRegistry[nodeName];
      if (nodes != null) {
        for (final node in nodes) {
          _applyMaterialToNode(node, _highlightMaterial);
        }
      }
    }
  }

  void _applyMaterialRecursive(Node root, Material material) {
    if (root.mesh != null) {
      _applyMaterialToNode(root, material);
    }
    for (final child in root.children) {
      _applyMaterialRecursive(child, material);
    }
  }

  void _applyMaterialToNode(Node node, Material material) {
    if (node.mesh case final mesh?) {
      node.mesh = Mesh.primitives(
        primitives: mesh.primitives.map((p) {
          return MeshPrimitive(p.geometry, material);
        }).toList(),
      );
    }
  }

  /// Extracts all mesh-bearing node names from the loaded layers.
  Map<AnatomyLayer, List<String>> getAvailableNodesByLayer() {
    final result = <AnatomyLayer, List<String>>{};
    for (final entry in _layerRoots.entries) {
      final layer = entry.key;
      final root = entry.value;
      final names = <String>[];
      _collectNodeNames(root, names);
      if (names.isNotEmpty) {
        result[layer] = names..sort();
      }
    }
    return result;
  }

  void _collectNodeNames(Node node, List<String> names) {
    if (node.mesh != null && node.name.isNotEmpty) {
      names.add(node.name);
    }
    for (final child in node.children) {
      _collectNodeNames(child, names);
    }
  }

  /// Projects a 3D node's world position to 2D screen coordinates.
  flutter.Offset? projectNodeToScreen(
    String nodeName,
    Camera camera,
    flutter.Size viewportSize,
  ) {
    final nodes = _nodeRegistry[nodeName];
    if (nodes == null || nodes.isEmpty) return null;

    final target = nodes.first;
    final worldPos = target.globalTransform.getTranslation();
    final viewProj = camera.getViewTransform(viewportSize);
    final clipPos = viewProj.transform(Vector4(worldPos.x, worldPos.y, worldPos.z, 1.0));

    if (clipPos.w <= 0) return null;
    final ndc = Vector3(clipPos.x / clipPos.w, clipPos.y / clipPos.w, clipPos.z / clipPos.w);

    return flutter.Offset(
      (ndc.x + 1.0) / 2.0 * viewportSize.width,
      (1.0 - ndc.y) / 2.0 * viewportSize.height,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}
