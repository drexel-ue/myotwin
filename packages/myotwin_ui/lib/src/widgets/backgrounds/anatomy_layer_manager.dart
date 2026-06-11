import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' as flutter;
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scene/scene.dart';
import 'package:myotwin_ui/src/models/anatomy_schema.dart';
import 'package:myotwin_ui/src/widgets/backgrounds/procedural_animation_engine.dart';
import 'package:shared_core/shared_core.dart';
import 'package:vector_math/vector_math.dart';

/// Orchestrates the loading, visual state, and animations of the 3D anatomy model.
///
/// Uses a declarative reconciliation pattern to ensure consistent visual state
/// across multiple layers and highlighted nodes.
class AnatomyLayerManager extends flutter.ChangeNotifier {
  /// Creates an [AnatomyLayerManager].
  AnatomyLayerManager(this._scene, {required TickerProvider vsync, this.logger}) {
    _pulseController = flutter.AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    )..addListener(_onTick);
    unawaited(_pulseController.repeat(reverse: true));

    _bloodFlowController = flutter.AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3000),
    )..addListener(_onTick);
    unawaited(_bloodFlowController.repeat());

    _initMaterials();
  }

  final Scene _scene;

  /// Optional logger for tracking engine initialization and asset loading.
  final LoggerService? logger;

  // Animation Control
  late final flutter.AnimationController _pulseController;
  late final flutter.AnimationController _bloodFlowController;

  // State
  AnatomyLayer? _isolatedLayer;
  final Set<String> _highlightedNodes = {};
  flutter.Color _highlightColor = flutter.Colors.cyan;
  double _roughness = 0.25;
  bool _isInitialized = false;
  bool _bloodFlowEnabled = true;
  int _stateVersion = 0;
  final bool _isMobile = flutter.defaultTargetPlatform == flutter.TargetPlatform.iOS || 
                         flutter.defaultTargetPlatform == flutter.TargetPlatform.android;

  // The Registry: Map<NodeName, List<Nodes>> for O(1) highlight lookups.
  final Map<String, List<Node>> _nodeRegistry = {};

  // Material Pool: One unique material per layer to allow independent fading.
  final Map<AnatomyLayer, PhysicallyBasedMaterial> _layerMaterials = {};
  final PhysicallyBasedMaterial _highlightMaterial = PhysicallyBasedMaterial();
  
  // Distance-band materials for blood flow (32 bands)
  final List<PhysicallyBasedMaterial> _cardioMaterials = [];
  static const int _numCardioBands = 32;

  // Cache of the default material for each node (for O(1) resets)
  final Map<Node, Material> _defaultMaterials = {};

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

  /// Returns the current state version, incremented on every visual change.
  int get stateVersion => _stateVersion;

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
      Material defaultMat;
      if (layer == AnatomyLayer.cardiovascular && _schema != null) {
        final meshSchema = _schema!.layers['cardiovascular']?.meshes[node.name];
        if (meshSchema != null) {
          final dist = meshSchema.boundingCenter.distanceTo(_schema!.heartCenter);
          // Simple heuristic: body height is approx 2.0
          final normalizedDist = (dist / 2.0).clamp(0.0, 0.99);
          final bandIndex = (normalizedDist * _numCardioBands).floor();
          defaultMat = _cardioMaterials[bandIndex];
        } else {
          defaultMat = _layerMaterials[layer]!;
        }
      } else {
        defaultMat = _layerMaterials[layer]!;
      }
      
      _defaultMaterials[node] = defaultMat;
      _applyMaterialToNode(node, defaultMat);
    }
    for (final child in node.children) {
      _indexNode(child, layer);
    }
  }

  /// Declaratively updates the desired visual state.
  void reconcile() {
    if (!_isInitialized) return;
    _onTick();
  }

  void _onTick() {
    _stateVersion++;
    final pulse = _pulseController.value;
    final bloodFlowPhase = _bloodFlowController.value;

    // 1. Update Layer Material Alphas (Snapped)
    for (final entry in _layerMaterials.entries) {
      final layer = entry.key;
      final material = entry.value;

      final targetAlpha = _calculateTargetAlpha(layer);
      
      material
        ..baseColorFactor = Vector4(0.1, 0.1, 0.1, targetAlpha)
        ..alphaMode = targetAlpha < 0.99 ? AlphaMode.blend : AlphaMode.opaque;

      // Toggle visibility based on alpha threshold to save draw calls
      _layerRoots[layer]?.visible = targetAlpha > 0.01;
    }

    // 2. Update Cardiovascular Distance-Band Materials (Snapped)
    if (_bloodFlowEnabled && _animationEngine != null) {
      final cardioAlpha = _calculateTargetAlpha(AnatomyLayer.cardiovascular);
      
      for (var i = 0; i < _numCardioBands; i++) {
        final material = _cardioMaterials[i];
        
        final bandNormDist = (i / _numCardioBands) + (0.5 / _numCardioBands);
        final arteryIntensity = _calculateWaveIntensity(bandNormDist, bloodFlowPhase, true);
        final veinIntensity = _calculateWaveIntensity(bandNormDist, bloodFlowPhase, false);

        material
          ..baseColorFactor = Vector4(0.1, 0.1, 0.1, cardioAlpha)
          ..alphaMode = cardioAlpha < 0.99 ? AlphaMode.blend : AlphaMode.opaque
          ..emissiveFactor = Vector4(
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
    const waveWidth = 0.2;
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

    // Isolation Mode:
    if (layer == _isolatedLayer) {
      // Muscles are layered; use 60% opacity to see deeper structures.
      // Other layers are fully visible (90%) for clarity.
      return layer == AnatomyLayer.muscular ? 0.6 : 0.9;
    }

    if (_isMobile) {
      // Option 3B: Selective Ghosting for Mobile
      // To prevent GPU HostBuffer overflows from drawing 4,600+ nodes,
      // we only ghost the skeletal layer to provide an anchor/context.
      if (layer == AnatomyLayer.skeletal) {
        return 0.1;
      }
      return 0.0;
    }

    // Original Behavior for Desktop/Web: Full holographic ghosting
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
    reconcile();
  }

  /// Highlights specific nodes by name.
  void setHighlights(List<String> nodes, flutter.Color color) {
    // 1. Reset previously highlighted nodes to their default materials
    for (final nodeName in _highlightedNodes) {
      final nodesList = _nodeRegistry[nodeName];
      if (nodesList != null) {
        for (final node in nodesList) {
          final defaultMat = _defaultMaterials[node];
          if (defaultMat != null) {
            _applyMaterialToNode(node, defaultMat);
          }
        }
      }
    }

    // 2. Update State
    _highlightedNodes
      ..clear()
      ..addAll(nodes);
    _highlightColor = color;

    // 3. Apply highlight material to new highlighted nodes
    for (final nodeName in _highlightedNodes) {
      final nodesList = _nodeRegistry[nodeName];
      if (nodesList != null) {
        for (final node in nodesList) {
          _applyMaterialToNode(node, _highlightMaterial);
        }
      }
    }

    reconcile();
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
    _pulseController.dispose();
    _bloodFlowController.dispose();
    super.dispose();
  }
}
