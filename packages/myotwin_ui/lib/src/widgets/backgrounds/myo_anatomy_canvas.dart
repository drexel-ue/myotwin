import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scene/scene.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:myotwin_ui/src/widgets/backgrounds/anatomy_layer_manager.dart';
import 'package:vector_math/vector_math.dart' as vm;

/// A high-fidelity 3D anatomy viewport that loads and renders layered GLB models.
class MyoAnatomyCanvas extends StatefulWidget {
  /// Creates a [MyoAnatomyCanvas].
  const MyoAnatomyCanvas({
    super.key,
    this.activeNodes = const [],
  });

  /// The list of anatomical nodes to highlight in the heatmap.
  final List<String> activeNodes;

  @override
  State<MyoAnatomyCanvas> createState() => _MyoAnatomyCanvasState();
}

class _MyoAnatomyCanvasState extends State<MyoAnatomyCanvas> {
  final Scene _scene = Scene();
  late final AnatomyLayerManager _manager;
  bool _isInitialized = false;

  // Camera State
  double _phi = math.pi / 2; // Latitude
  double _theta = -math.pi / 2; // Longitude (Facing the user)
  double _radius = 2.4; // Zoom distance
  vm.Vector3 _targetPos = vm.Vector3(0.0, 0.85, 0.0); // Focus point (abdomen)

  @override
  void initState() {
    super.initState();
    _manager = AnatomyLayerManager(_scene);

    // Setup Lighting
    _scene.directionalLight = DirectionalLight()
      ..color = vm.Vector3(1.0, 1.0, 1.0)
      ..direction = vm.Vector3(1.0, -1.0, 1.0).normalized()
      ..intensity = 2.0;

    _scene.environmentIntensity = 0.5;

    unawaited(_manager.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _applyHighlights();
        });
      }
    }));
  }

  @override
  void didUpdateWidget(covariant MyoAnatomyCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isInitialized && widget.activeNodes != oldWidget.activeNodes) {
      _applyHighlights();
    }
  }

  void _applyHighlights() {
    _manager.clearHighlights();
    final theme = context.myoTheme;
    for (final node in widget.activeNodes) {
      _manager.highlightNode(node, theme.accentHot);
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      final isPanning =
          details.pointerCount >= 2 ||
          HardwareKeyboard.instance.logicalKeysPressed
              .contains(LogicalKeyboardKey.shiftLeft) ||
          HardwareKeyboard.instance.logicalKeysPressed
              .contains(LogicalKeyboardKey.shiftRight);

      if (isPanning) {
        // --- Omni-Directional Pan Math ---
        // Calculate camera vectors based on current rotation
        final camX = _radius * math.sin(_phi) * math.cos(_theta);
        final camY = _radius * math.cos(_phi);
        final camZ = _radius * math.sin(_phi) * math.sin(_theta);

        final forward = -vm.Vector3(camX, camY, camZ).normalized();
        final right = vm.Vector3(0.0, 1.0, 0.0).cross(forward).normalized();
        final up = forward.cross(right).normalized();

        // Translate the target position relative to camera view
        // Drag right (dx > 0) -> Move target LEFT (-right) -> Model appears to move RIGHT
        // Drag down (dy > 0) -> Move target UP (+up) -> Model appears to move DOWN
        _targetPos -= right * (details.focalPointDelta.dx * 0.005);
        _targetPos += up * (details.focalPointDelta.dy * 0.005);
      } else {
        // Handle Orbit (Drag on Desktop/Mobile)
        _theta -= details.focalPointDelta.dx * 0.01;
        _phi =
            (_phi - details.focalPointDelta.dy * 0.01).clamp(0.1, math.pi - 0.1);
      }

      // Handle Zoom (2-Finger Pinch on Mobile)
      if (details.scale != 1.0) {
        _radius = (_radius / details.scale).clamp(1.0, 10.0);
      }
    });
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      setState(() {
        // Handle Mouse Wheel Zoom
        _radius = (_radius + event.scrollDelta.dy * 0.005).clamp(1.0, 10.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate camera position based on spherical coordinates relative to target
    final x = _radius * math.sin(_phi) * math.cos(_theta);
    final y = _radius * math.cos(_phi);
    final z = _radius * math.sin(_phi) * math.sin(_theta);

    final camera = PerspectiveCamera(
      position: _targetPos + vm.Vector3(x, y, z),
      target: _targetPos,
      up: vm.Vector3(0.0, 1.0, 0.0),
    );

    return Listener(
      onPointerSignal: _handlePointerSignal,
      child: GestureDetector(
        onScaleUpdate: _handleScaleUpdate,
        child: CustomPaint(
          painter: _ScenePainter(
            scene: _scene,
            camera: camera,
          ),
        ),
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter({required this.scene, required this.camera});

  final Scene scene;
  final Camera camera;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    scene.render(camera, canvas, viewport: Offset.zero & size);
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) {
    return true; // We repaint every frame to handle animations/interpolations
  }
}
