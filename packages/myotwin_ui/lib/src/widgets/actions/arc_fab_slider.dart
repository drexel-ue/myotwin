import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// Input mode for the [ArcFABSlider].
///
/// {@template arc_fab_slider.mode}
/// - `centered`: Default neutral position, used when the slider returns
///   to the middle.
/// - `voice`: Left snapped position, indicating voice input mode.
/// - `text`: Right snapped position, indicating text input mode.
/// {@endtemplate}
enum ArcSliderMode {
  /// Neutral / default state.
  centered,

  /// Voice input mode.
  voice,

  /// Text input mode.
  text,
}

/// A callback that receives the current [ArcSliderMode] snapped to by
/// the slider after a drag or flick gesture.
typedef ArcSliderModeCallback = void Function(ArcSliderMode mode);

/// A horizontal arc-track gesture widget where the FAB slides along a
/// parabolic arc path and snaps between interaction modes with velocity-
/// based flick prediction and haptic feedback.
///
/// The FAB drops downward as it moves left or right (arc shape), scales
/// down proportionally, and snaps back to one of three modes — `centered`,
/// `voice`, or `text` — using a spring animation with an ease-out-back
/// curve for a mechanical "thunk" feel.
class ArcFABSlider extends StatefulWidget {
  /// Creates a horizontal arc-track gesture slider.
  ///
  /// {@template arc_fab_slider.constructor}
  /// The slider responds to drag and flick gestures. A flick past 30 % of
  /// the track distance, or a sustained drag past that threshold, commits
  /// the user to the nearest side mode ([ArcSliderMode.voice] or
  /// [ArcSliderMode.text]). Snapping back to [ArcSliderMode.centered] only
  /// happens when the slider is released near the middle.
  /// {@endtemplate}
  const ArcFABSlider({
    super.key,
    required this.fabState,
    required this.onFabPressed,
    required this.onModeChanged,
  });

  /// Vertical drop in pixels from the track baseline to the arc's
  /// lowest point (when the FAB is at either extreme).
  static const double arcDropDistance = 40.0;

  /// Total height of the track, computed from the base spacing plus the
  /// arc drop. Matches the container height so touch targets are consistent.
  static const double trackHeight = spacing72 + arcDropDistance;

  /// The current animation state (idle, listening, active) controlling the
  /// internal holographic FAB's speed and glow intensity.
  final HoloState fabState;

  /// Callback invoked when the FAB is pressed within a particular mode.
  /// Passes the current [ArcSliderMode] so callers can act on the
  /// selected input mode.
  final ArcSliderModeCallback onFabPressed;

  /// Callback invoked whenever the slider snaps to a new mode.
  /// Receives the new [ArcSliderMode] value.
  final ValueChanged<ArcSliderMode> onModeChanged;

  @override
  State<ArcFABSlider> createState() => _ArcFABSliderState();
}

class _ArcFABSliderState extends State<ArcFABSlider> with SingleTickerProviderStateMixin {
  // Physical Constraints
  double maxSlideDistance = 120.0; // How far left/right it moves in pixelss

  // State: -1.0 (Left), 0.0 (Center), 1.0 (Right)
  final _slideProgress = ValueNotifier<double>(0.0);

  // Physics engine for snapping when the user lets go
  late final AnimationController _snapController;
  late Animation<double> _snapAnimation;

  // Slider mode.
  ArcSliderMode _mode = .centered;

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
    _mode = .centered;

    // If they dragged past 30%, OR flicked it hard, commit to the side
    if (current + (velocity * 0.1) < -0.3) {
      target = -1.0;
      _mode = .voice; // Voice
    } else if (current + (velocity * 0.1) > 0.3) {
      target = 1.0;
      _mode = .text; // Text
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
    widget.onModeChanged(_mode);
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
        const fabSize = spacing64;
        maxSlideDistance = (constraints.maxWidth - fabSize) / 2.0;

        return GestureDetector(
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          behavior: HitTestBehavior.translucent,
          child: Container(
            width: constraints.maxWidth,
            height: ArcFABSlider.trackHeight,
            alignment: .topCenter,

            child: ValueListenableBuilder(
              valueListenable: _slideProgress,
              builder: (context, progress, _) {
                // --- THE MATH ---
                final xPos = progress * maxSlideDistance;
                final yPos = (progress * progress) * ArcFABSlider.arcDropDistance;
                final scale = 1.0 - (0.25 * progress.abs());

                return Transform.translate(
                  offset: Offset(xPos, yPos),
                  child: Transform.scale(
                    scale: scale,
                    child: AnimatedHoloFAB(
                      state: widget.fabState,
                      onPressed: () => widget.onFabPressed(_mode),
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
