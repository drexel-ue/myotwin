import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A cyberpunk rectangular toggle switch with a snapping thumb.
///
/// The switch renders as a thumb on a slim track with matching rounded
/// corners. On toggle it glitches then snaps instantly to the opposite end
/// — no smooth slider animation.
class MyoSwitch extends StatefulWidget {
  /// Creates a [MyoSwitch].
  const MyoSwitch({
    super.key,
    this.value = false,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
  });

  // --- constants

  /// Track width of the switch.
  static const switchWidth = 48.0;

  /// Track height of the switch.
  static const switchHeight = 20.0;

  /// Thumb width.
  static const thumbWidth = 16.0;

  /// Thumb height.
  static const thumbHeight = 12.0;

  /// Horizontal padding for the thumb within the track.
  static const EdgeInsetsDirectional _switchThumbPadding = horizontalPadding2;

  /// Whether the switch is on or off.
  final bool value;

  /// Called when the switch is toggled.
  final ValueChanged<bool> onChanged;

  /// Color of the track and thumb glow when active.
  final Color? activeColor;

  /// Color of the track when inactive.
  final Color? inactiveColor;

  /// Color of the thumb.
  final Color? thumbColor;

  @override
  State<MyoSwitch> createState() => _MyoSwitchState();
}

class _MyoSwitchState extends State<MyoSwitch> with SingleTickerProviderStateMixin, HoloGlitchTickerMixin<MyoSwitch> {
  bool _animating = false;
  Timer? _glitchTimer;

  @override
  void dispose() {
    _glitchTimer?.cancel();
    super.dispose();
  }

  void _onTap() {
    if (_animating) return;

    triggerGlitch();
    setState(() {
      _animating = true;
    });

    // Hold glitch state, then snap thumb to other side
    _glitchTimer = Timer(const Duration(milliseconds: 80), () {
      setState(() {
        widget.onChanged(!widget.value);
        _animating = false;
      });
    });
  }

  @override
  void didUpdateWidget(covariant MyoSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      triggerGlitch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;
    final activeColor = widget.value
        ? (widget.activeColor ?? theme.accentHot)
        : (widget.inactiveColor ?? theme.outline);
    final thumbColor = widget.thumbColor ?? theme.white;

    return HoloGlitch(
      phase: glitchPhase,
      intensity: glitchIntensity,
      severity: 0.5,
      child: GestureDetector(
        onTap: _onTap,
        child: SizedBox(
          width: MyoSwitch.switchWidth,
          height: MyoSwitch.switchHeight,
          child: Stack(
            children: [
              // Track
              AnimatedContainer(
                duration: theme.motionNormal,
                curve: theme.curveDecelerate,
                width: MyoSwitch.switchWidth,
                height: MyoSwitch.switchHeight,
                decoration: BoxDecoration(
                  color: widget.value ? activeColor.withValues(alpha: 0.08) : Colors.transparent,
                  borderRadius: theme.radiusSm,
                  border: .all(color: activeColor, width: 1.5),
                ),
              ),
              // Thumb snaps left or right
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 50),
                child: _SwitchThumb(
                  key: ValueKey<bool>(widget.value),
                  isOn: widget.value,
                  color: thumbColor,
                  glowColor: activeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thumb rendered at the left or right end of the track.
class _SwitchThumb extends StatelessWidget {
  const _SwitchThumb({
    super.key,
    required this.isOn,
    required this.color,
    required this.glowColor,
  });

  /// Whether the switch is in the on (right) state.
  final bool isOn;

  /// Fill color of the thumb.
  final Color color;

  /// Glow color emitted when active.
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return Align(
      alignment: isOn ? .centerRight : .centerLeft,
      child: Padding(
        padding: MyoSwitch._switchThumbPadding,
        child: Container(
          width: MyoSwitch.thumbWidth,
          height: MyoSwitch.thumbHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: theme.radiusSm,
            boxShadow: [
              if (isOn)
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.35),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
