import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scene/scene.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:vector_math/vector_math.dart' as vm;

/// A high-fidelity 3D anatomy viewport that loads and renders layered GLB models.
class MyoAnatomyCanvas extends StatefulWidget {
  /// Creates a [MyoAnatomyCanvas].
  const MyoAnatomyCanvas({
    super.key,
    this.activeNodes = const [],
    this.resetTrigger,
    this.activeLayer,
    this.onNodesLoaded,
    required this.accentColor,
    required this.highlightColor,
    required this.roughness,
  });

  /// The list of anatomical nodes to highlight in the heatmap.
  final List<String> activeNodes;

  /// An optional notifier to trigger a camera view reset.
  final ValueNotifier<int>? resetTrigger;

  /// The anatomical layer to isolate (make solid while ghosting others).
  final AnatomyLayer? activeLayer;

  /// Called when the 3D models are fully loaded and node names are available.
  final ValueChanged<Map<AnatomyLayer, List<String>>>? onNodesLoaded;

  /// The primary accent color for lighting.
  final Color accentColor;

  /// The color for anatomical highlights.
  final Color highlightColor;

  /// The material roughness.
  final double roughness;

  @override
  State<MyoAnatomyCanvas> createState() => _MyoAnatomyCanvasState();
}

class _MyoAnatomyCanvasState extends State<MyoAnatomyCanvas> with TickerProviderStateMixin {
  final Scene _scene = Scene();
  late final AnatomyLayerManager _manager;

  // Camera State
  double _phi = math.pi / 2; // Latitude
  double _theta = -math.pi / 2; // Longitude (Facing the user)
  double _radius = 2.4; // Zoom distance
  vm.Vector3 _targetPos = vm.Vector3(0.0, 0.85, 0.0); // Focus point (abdomen)

  // Tracking for seamless delta-based gestures
  double _lastScale = 1.0;
  int _lastPointerCount = 0;

  @override
  void initState() {
    super.initState();
    _manager = AnatomyLayerManager(_scene, vsync: this, logger: context.myoLogger);

    // Initial Lighting
    _updateLighting(widget.accentColor);
    _scene.environmentIntensity = 0.6;

    _manager.addListener(_handleManagerUpdate);

    unawaited(
      _manager.initialize().then((_) {
        if (mounted) {
          _manager
            ..updateRoughness(widget.roughness)
            ..isolateLayer(widget.activeLayer)
            ..setHighlights(widget.activeNodes, widget.highlightColor);
          widget.onNodesLoaded?.call(_manager.getAvailableNodesByLayer());
        }
      }),
    );

    widget.resetTrigger?.addListener(_resetView);
  }

  @override
  void didUpdateWidget(covariant MyoAnatomyCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_manager.isInitialized) {
      if (widget.activeLayer != oldWidget.activeLayer) {
        _manager.isolateLayer(widget.activeLayer);
      }
      if (widget.activeNodes != oldWidget.activeNodes || widget.highlightColor != oldWidget.highlightColor) {
        _manager.setHighlights(widget.activeNodes, widget.highlightColor);
      }
      if (widget.roughness != oldWidget.roughness) {
        _manager.updateRoughness(widget.roughness);
      }
      if (widget.accentColor != oldWidget.accentColor) {
        _updateLighting(widget.accentColor);
      }
    }
    if (widget.resetTrigger != oldWidget.resetTrigger) {
      oldWidget.resetTrigger?.removeListener(_resetView);
      widget.resetTrigger?.addListener(_resetView);
    }
  }

  void _updateLighting(Color color) {
    _scene.directionalLight = DirectionalLight()
      ..color = vm.Vector3(color.r, color.g, color.b)
      ..direction = vm.Vector3(1.0, -1.0, 1.0).normalized()
      ..intensity = 2.0;
  }

  @override
  void dispose() {
    _manager
      ..removeListener(_handleManagerUpdate)
      ..dispose();
    widget.resetTrigger?.removeListener(_resetView);
    super.dispose();
  }

  void _handleManagerUpdate() {
    if (mounted) setState(() {});
  }

  void _resetView() {
    setState(() {
      _phi = math.pi / 2;
      _theta = -math.pi / 2;
      _radius = 2.4;
      _targetPos = vm.Vector3(0.0, 0.85, 0.0);
    });
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _lastScale = 1.0;
    _lastPointerCount = details.pointerCount;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // 1. Handle Pointer Count Changes (Seamless Handoff)
      if (details.pointerCount != _lastPointerCount) {
        _lastScale = details.scale;
        _lastPointerCount = details.pointerCount;
      }

      // 2. Resolve Interaction Mode
      final isPanning =
          details.pointerCount >= 2 ||
          HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
          HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.shiftRight);

      // 3. Apply Transformations
      if (isPanning) {
        // --- Omni-Directional Pan Math ---
        final camX = _radius * math.sin(_phi) * math.cos(_theta);
        final camY = _radius * math.cos(_phi);
        final camZ = _radius * math.sin(_phi) * math.sin(_theta);

        final forward = -vm.Vector3(camX, camY, camZ).normalized();
        final right = vm.Vector3(0.0, 1.0, 0.0).cross(forward).normalized();
        final up = forward.cross(right).normalized();

        // Translate the target position relative to camera view
        _targetPos -= right * (details.focalPointDelta.dx * 0.005);
        _targetPos += up * (details.focalPointDelta.dy * 0.005);
      } else {
        // Handle Orbit (Drag on Desktop/Mobile)
        _theta -= details.focalPointDelta.dx * 0.01;
        _phi = (_phi - details.focalPointDelta.dy * 0.01).clamp(0.1, math.pi - 0.1);
      }

      // 4. Handle Zoom (Delta-based to avoid exponential jumps)
      final scaleDelta = details.scale / _lastScale;
      _radius = (_radius / scaleDelta).clamp(0.1, 50.0);
      _lastScale = details.scale;
    });
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      setState(() {
        // Handle Mouse Wheel Zoom with higher sensitivity
        _radius = (_radius + event.scrollDelta.dy * 0.08).clamp(0.1, 50.0);
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

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate screen-space offsets for all active highlights
        final projectedTooltips = <String, Offset>{};
        if (_manager.isInitialized) {
          for (final node in widget.activeNodes) {
            final screenPos = _manager.projectNodeToScreen(
              node,
              camera,
              constraints.biggest,
            );
            if (screenPos != null) {
              projectedTooltips[node] = screenPos;
            }
          }
        }

        return Listener(
          onPointerSignal: _handlePointerSignal,
          child: GestureDetector(
            // Use deferToChild so we only block background hits if our silhouette hitTest passes
            behavior: HitTestBehavior.deferToChild,
            onScaleStart: _handleScaleStart,
            onScaleUpdate: _handleScaleUpdate,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ScenePainter(
                      scene: _scene,
                      camera: camera,
                      viewportSize: constraints.biggest,
                    ),
                  ),
                ),
                // Render 3D-Anchored Tooltips
                ...projectedTooltips.entries.map((entry) {
                  return Positioned(
                    left: entry.value.dx,
                    top: entry.value.dy,
                    child: FractionalTranslation(
                      translation: const Offset(-0.5, -1.2),
                      child: _AnatomyTooltip(label: entry.key),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnatomyTooltip extends StatelessWidget {
  const _AnatomyTooltip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;
    return FrostedHUD(
      impactPoint: Offset.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label.toUpperCase(),
          style: theme.caption.copyWith(
            color: theme.accentHot,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter({
    required this.scene,
    required this.camera,
    required this.viewportSize,
  });

  final Scene scene;
  final Camera camera;
  final Size viewportSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    scene.render(camera, canvas, viewport: Offset.zero & size);
  }

  @override
  bool hitTest(Offset position) {
    // SILHOUETTE HIT-TESTING HEURISTIC
    final centerX = viewportSize.width / 2;
    final hitWidth = viewportSize.width * 0.25; // 50% total width

    // If the touch is within the horizontal central silhouette, claim the hit.
    return (position.dx - centerX).abs() < hitWidth;
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) {
    return true; // We repaint every frame to handle animations/interpolations
  }
}
