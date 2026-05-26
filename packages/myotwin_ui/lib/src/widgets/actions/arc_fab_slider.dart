import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

enum ArcSliderMode {
  centered,
  voice,
  text,
}

class ArcFABSlider extends StatefulWidget {
  const ArcFABSlider({
    super.key,
    required this.fabState,
    required this.onFabPressed,
    required this.onModeChanged,
  });

  final HoloState fabState;
  final VoidCallback onFabPressed;
  final ValueChanged<ArcSliderMode> onModeChanged;

  @override
  State<ArcFABSlider> createState() => _ArcFABSliderState();
}

class _ArcFABSliderState extends State<ArcFABSlider> with SingleTickerProviderStateMixin {
  // Physical Constraints
  double maxSlideDistance = 120.0; // How far left/right it moves in pixels
  final double arcDropDistance = 40.0; // How far it dips downward at the edges

  // State: -1.0 (Left), 0.0 (Center), 1.0 (Right)
  final _slideProgress = ValueNotifier<double>(0.0);

  // Physics engine for snapping when the user lets go
  late final AnimationController _snapController;
  late Animation<double> _snapAnimation;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _snapController.addListener(() {
      _slideProgress.value = _snapAnimation.value;
    });
  }

  Future<void> _onPanUpdate(DragUpdateDetails details) async {
    // 1. Cancel any active snap animations
    if (_snapController.isAnimating) _snapController.stop();

    // 2. Convert raw pixel movement into normalized progress
    final deltaProgress = details.delta.dx / maxSlideDistance;
    final newProgress = (_slideProgress.value + deltaProgress).clamp(-1.0, 1.0);

    // 3. Optional: Add a subtle haptic click when crossing the center deadzone
    if ((_slideProgress.value < 0 && newProgress >= 0) || (_slideProgress.value > 0 && newProgress <= 0)) {
      await HapticFeedback.selectionClick();
    }

    _slideProgress.value = newProgress;
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    // 1. Calculate the velocity of the flick
    final velocity = details.velocity.pixelsPerSecond.dx / maxSlideDistance;
    final current = _slideProgress.value;

    // 2. Predict the target based on position AND flick velocity
    var target = 0.0;
    var mode = ArcSliderMode.centered;

    // If they dragged past 30%, OR flicked it hard, commit to the side
    if (current + (velocity * 0.1) < -0.3) {
      target = -1.0;
      mode = .voice; // Voice
    } else if (current + (velocity * 0.1) > 0.3) {
      target = 1.0;
      mode = .text; // Text
    }

    // 3. Setup the spring animation to the target
    _snapAnimation = Tween<double>(begin: current, end: target).animate(
      CurvedAnimation(
        parent: _snapController,
        curve: Curves.easeOutBack, // Gives it that heavy, mechanical "thunk" when locking in
      ),
    );

    await _snapController.forward(from: 0.0);
    if (target != 0.0) await HapticFeedback.heavyImpact(); // Hardware lock-in feel
    widget.onModeChanged(mode);
  }

  @override
  void dispose() {
    _snapController.dispose();
    _slideProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 1. Define your FAB size
        const fabSize = spacing64;
        maxSlideDistance = (constraints.maxWidth - fabSize) / 2.0;

        // 2. The track must be tall enough to hold the FAB + the drop distance
        final trackHeight = fabSize + arcDropDistance;

        return GestureDetector(
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          behavior: HitTestBehavior.translucent,
          child: Container(
            width: constraints.maxWidth,
            height: trackHeight, // Give it physical height
            // 3. Align to the top. The Transform will push the visual down into the empty space.
            alignment: .topCenter,

            child: ValueListenableBuilder(
              valueListenable: _slideProgress,
              builder: (context, progress, _) {
                // --- THE MATH ---
                final xPos = progress * maxSlideDistance;
                final yPos = (progress * progress) * arcDropDistance;
                final scale = 1.0 - (0.5 * progress.abs());

                return Transform.translate(
                  offset: Offset(xPos, yPos),
                  child: Transform.scale(
                    scale: scale,
                    child: AnimatedHoloFAB(
                      state: widget.fabState,
                      onPressed: widget.onFabPressed,
                      icon: emptyWidget,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
