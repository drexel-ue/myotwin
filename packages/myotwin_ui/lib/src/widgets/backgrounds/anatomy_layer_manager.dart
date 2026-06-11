import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scene/scene.dart';
import 'package:shared_core/shared_core.dart';
import 'package:vector_math/vector_math.dart';

import '../../models/anatomy_schema.dart';
import 'procedural_animation_engine.dart';

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

    _bloodFlowController = flutter.AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3000),
    );
    unawaited(_bloodFlowController.repeat());

    _initMaterials();
  }

  final Scene _scene;

  /// Optional logger for tracking engine initialization and asset loading.
  final LoggerService? logger;

  // Animation Control
  late final flutter.AnimationController _fadeController;
  late final flutter.AnimationController _pulseController;
  late final flutter.AnimationController _bloodFlowController;

  // State
  AnatomyLayer? _isolatedLayer;
  final Set<String> _highlightedNodes = {};
  flutter.Color _highlightColor = flutter.Colors.cyan;
  double _roughness = 0.25;
  bool _isInitialized = false;
  bool _bloodFlowEnabled = true;

  // The Registry: Map<NodeName, List<Nodes>> for O(1) highlight lookups.
  final Map<String, List<Node>> _nodeRegistry = {};

  // Material Pool: One unique material per layer to allow independent fading.
  final Map<AnatomyLayer, PhysicallyBasedMaterial> _layerMaterials = {};
  final PhysicallyBasedMaterial _highlightMaterial = PhysicallyBasedMaterial();
  
  // Distance-band materials for blood flow (32 bands)
  final List<PhysicallyBasedMaterial> _cardioMaterials = [];
  static const int _numCardioBands = 32;

  // Root nodes for each layer
  final Map<AnatomyLayer, Node> _layerRoots = {};
  
  // Procedural Data
  AnatomySchema? _schema;
  ProceduralAnimationEngine? _animationEngine;

  /// Whether the manager has finished loading all initial assets.
  bool get isInitialized => _isInitialized;

  /// Returns the current isolated layer, if any.
  AnatomyLayer? get isolatedLayer => _isolatedLayer;

  /// Whether blood flow animation is currently active.
  bool get bloodFlowEnabled => _bloodFlowEnabled;

  /// Sets whether the blood flow animation should be enabled.
  set bloodFlowEnabled(bool value) {
    if (_bloodFlowEnabled == value) return;
    _bloodFlowEnabled = value;
    notifyListeners();
  }

  void _initMaterials() {
    for (final layer in AnatomyLayer.values) {
      _layerMaterials[layer] = PhysicallyBasedMaterial()
        ..baseColorFactor = Vector4(0.1, 0.1, 0.1, 1.0)
        ..metallicFactor = 0.9
        ..roughnessFactor = _roughness;
    }

    // Initialize cardiovascular distance-band materials
    for (var i = 0; i < _numCardioBands; i++) {
      _cardioMaterials.add(PhysicallyBasedMaterial()
        ..baseColorFactor = Vector4(0.1, 0.1, 0.1, 0.0)
        ..metallicFactor = 0.9
        ..roughnessFactor = _roughness);
    }

    _highlightMaterial
      ..baseColorFactor = Vector4(
        _highlightColor.r,
        _highlightColor.g,
        _highlightColor.b,
        1.0,
      )
      ..emissiveFactor = Vector4(
        _highlightColor.r,
        _highlightColor.g,
        _highlightColor.b,
        1.0,
      );
  }

  /// Initializes the materials and loads all 3D assets into the scene.
  Future<void> initialize() async {
    final initProgress = logger?.progress('INITIALIZING_ANATOMY_ENGINE');

    // 1. Load Schema
    try {
      final schemaJson = await rootBundle.loadString('assets/models/anatomy_encoding_schema.json');
      _schema = AnatomySchema.fromJson(jsonDecode(schemaJson) as Map<String, dynamic>);
      _animationEngine = ProceduralAnimationEngine(_schema!)..initialize();
    } catch (e) {
      logger?.warn('Failed to load anatomy schema, procedural animations disabled: $e');
    }

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

      // Special material assignment for cardiovascular layer
      if (layer == AnatomyLayer.cardiovascular && _schema != null) {
        final meshSchema = _schema!.layers['cardiovascular']?.meshes[node.name];
        if (meshSchema != null) {
          final dist = meshSchema.boundingCenter.distanceTo(_schema!.heartCenter);
          // Simple heuristic: body height is approx 2.0
          final normalizedDist = (dist / 2.0).clamp(0.0, 0.99);
          final bandIndex = (normalizedDist * _numCardioBands).floor();
          _applyMaterialToNode(node, _cardioMaterials[bandIndex]);
        } else {
          _applyMaterialToNode(node, _layerMaterials[layer]!);
        }
      } else {
        // Apply the layer-specific material instance initially
        _applyMaterialToNode(node, _layerMaterials[layer]!);
      }
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
    final bloodFlowPhase = _bloodFlowController.value;

    // 1. Update Layer Material Alphas
    for (final entry in _layerMaterials.entries) {
      final layer = entry.key;
      final material = entry.value;

      final targetAlpha = _calculateTargetAlpha(layer);
      final currentAlpha = material.baseColorFactor.w;
      final newAlpha = currentAlpha + (targetAlpha - currentAlpha) * t;

      material
        ..baseColorFactor = Vector4(0.1, 0.1, 0.1, newAlpha)
        ..alphaMode = newAlpha < 0.99 ? AlphaMode.blend : AlphaMode.opaque;

      // Toggle visibility based on alpha threshold to save draw calls
      _layerRoots[layer]?.visible = newAlpha > 0.01;
    }

    // 2. Update Cardiovascular Distance-Band Materials
    if (_bloodFlowEnabled && _animationEngine != null) {
      final cardioAlpha = _calculateTargetAlpha(AnatomyLayer.cardiovascular);
      
      // We iterate through bands and use a representative node name/distance
      // to calculate the emissive boost for that whole band.
      for (var i = 0; i < _numCardioBands; i++) {
        final material = _cardioMaterials[i];
        
        // Target alpha transition
        final currentAlpha = material.baseColorFactor.w;
        final newAlpha = currentAlpha + (cardioAlpha - currentAlpha) * t;
        material..baseColorFactor = Vector4(0.1, 0.1, 0.1, newAlpha)
                ..alphaMode = newAlpha < 0.99 ? AlphaMode.blend : AlphaMode.opaque;

        // Calculate procedural emissive boost for this distance band
        // We use a normalized distance for the band
        final bandNormDist = (i / _numCardioBands) + (0.5 / _numCardioBands);
        
        // Artery pulse (outwards)
        final arteryIntensity = _calculateWaveIntensity(bandNormDist, bloodFlowPhase, true);
        // Vein pulse (inwards)
        final veinIntensity = _calculateWaveIntensity(bandNormDist, bloodFlowPhase, false);

        // Mix red and blue based on intensities
        material.emissiveFactor = Vector4(
          1.0 * arteryIntensity,
          0.1 * arteryIntensity + 0.4 * veinIntensity,
          0.1 * arteryIntensity + 1.0 * veinIntensity,
          1.0,
        );
      }
    }

    // 3. Update Highlight Material Pulse
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

  double _calculateWaveIntensity(double normDist, double phase, bool isArtery) {
    final waveWidth = 0.2;
    final wavePos = isArtery ? normDist : (1.0 - normDist);
    final shiftedPhase = (phase * 2.0) % 1.0;
    
    final distFromPeak = (wavePos - shiftedPhase).abs();
    if (distFromPeak > waveWidth) return 0.0;
    
    final intensity = 1.0 - (distFromPeak / waveWidth);
    return math.pow(intensity, 3).toDouble();
  }


  double _calculateTargetAlpha(AnatomyLayer layer) {
    if (_isolatedLayer == null) {
      // Default HUD State: Skeletal Solid, Muscular Ghosted, Others Hidden
      return switch (layer) {
        AnatomyLayer.skeletal => 1.0,
        AnatomyLayer.muscular => 0.4,
        _ => 0.0,
      };
    }

    // Isolation Mode: Selection "Solid", others 10% ghosted
    if (layer == _isolatedLayer) {
      // Muscles are layered; use 60% opacity to see deeper structures.
      // Other layers are slightly transparent (90%) for a holographic feel.
      return layer == AnatomyLayer.muscular ? 0.6 : 0.9;
    }

    return 0.1;
  }

  /// Updates the model roughness property.
  void updateRoughness(double roughness) {
    _roughness = roughness;
    for (final material in _layerMaterials.values) {
      material.roughnessFactor = _roughness;
    }
    _highlightMaterial.roughnessFactor = _roughness;
    notifyListeners();
  }

  /// Updates the highlight color.
  void updateHighlightColor(flutter.Color color) {
    _highlightColor = color;
    reconcile();
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
  void _refreshMaterialAssignments() {
    // 1. Reset all nodes to their default materials (layer or cardio-band)
    for (final entry in _layerRoots.entries) {
      final layer = entry.key;
      final root = entry.value;
      _resetMaterialsRecursive(root, layer);
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

  void _resetMaterialsRecursive(Node node, AnatomyLayer layer) {
    if (node.mesh != null) {
      final material = _getDefaultMaterialForNode(node, layer);
      _applyMaterialToNode(node, material);
    }
    for (final child in node.children) {
      _resetMaterialsRecursive(child, layer);
    }
  }

  Material _getDefaultMaterialForNode(Node node, AnatomyLayer layer) {
    if (layer == AnatomyLayer.cardiovascular && _schema != null) {
      final meshSchema = _schema!.layers['cardiovascular']?.meshes[node.name];
      if (meshSchema != null) {
        final dist = meshSchema.boundingCenter.distanceTo(_schema!.heartCenter);
        // Simple heuristic: body height is approx 2.0
        final normalizedDist = (dist / 2.0).clamp(0.0, 0.99);
        final bandIndex = (normalizedDist * _numCardioBands).floor();
        return _cardioMaterials[bandIndex];
      }
    }
    return _layerMaterials[layer]!;
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
    _bloodFlowController.dispose();
    super.dispose();
  }
}
