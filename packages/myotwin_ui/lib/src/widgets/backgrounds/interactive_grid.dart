import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A pannable/flashable container that hosts a precision grid background
/// and user-supplied child content.
class InteractiveGrid extends StatefulWidget {
  /// Creates a pannable/flashable container that hosts a precision grid background
  /// and user-supplied child content.
  const InteractiveGrid({super.key});

  /// Creates the mutable state for this widget.
  @override
  State<InteractiveGrid> createState() => _InteractiveGridState();
}

class _InteractiveGridState extends State<InteractiveGrid> with SingleTickerProviderStateMixin {
  final _cameraPan = ValueNotifier<Offset>(.zero);
  Offset _velocity = .zero;

  late final Ticker _ticker;
  Duration _lastTimeStamp = .zero;

  // The friction coefficient. Higher = stops faster. Lower = glides like ice.
  // 4.5 gives a heavy, deliberate "blueprint table" feel.
  final double _friction = 4.5;

  @override
  void initState() {
    super.initState();
    // Initialize a high-performance game loop bound to the display refresh rate
    _ticker = createTicker(_onTick);
  }

  void _onTick(Duration elapsed) {
    // Handle the first frame after a flick to prevent time-delta jumps
    if (_lastTimeStamp == .zero) {
      _lastTimeStamp = elapsed;
      return;
    }

    // Calculate dynamic time delta (dt) in seconds so the math works perfectly
    // whether the device is running at 60Hz or 120Hz (ProMotion displays).
    final dt = (elapsed - _lastTimeStamp).inMicroseconds / 1000000.0;
    _lastTimeStamp = elapsed;

    // 1. Move the camera based on current velocity and time passed
    _cameraPan.value += _velocity * dt;

    // 2. Apply friction to bleed off momentum
    _velocity -= _velocity * _friction * dt;

    // 3. Cull the loop when the velocity drops below a perceptible threshold
    if (_velocity.distance < 5.0) {
      _velocity = .zero;
      _ticker.stop();
    }
  }

  void _onPanStart(DragStartDetails details) {
    // If the user grabs the canvas while it's still sliding, kill the momentum instantly
    if (_ticker.isTicking) {
      _ticker.stop();
    }
    _velocity = .zero;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _cameraPan.value += details.delta;
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    // Capture the exact pixels-per-second exit speed of the user's finger/mouse
    _velocity = details.velocity.pixelsPerSecond;

    // Cap the maximum terminal velocity so a wild flick doesn't break the optical illusion
    if (_velocity.distance > 4000) {
      _velocity = (_velocity / _velocity.distance) * 4000;
    }

    // Only initiate the physics engine if the user actually threw it
    if (_velocity.distance > 50) {
      _lastTimeStamp = .zero;
      await _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _cameraPan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: ValueListenableBuilder(
        valueListenable: _cameraPan,
        builder: (context, offset, _) {
          return PrecisionGridBackground(offset: offset);
        },
      ),
    );
  }
}
