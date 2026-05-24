import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A cyberpunk-style checkbox.
///
/// Triggers a glitch effect when the [value] changes.
class MyoCheckbox extends StatefulWidget {
  /// Creates a [MyoCheckbox].
  const MyoCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.borderSide,
  });

  /// The current state of the checkbox.
  final bool value;

  /// Callback when the user interacts with the checkbox.
  final ValueChanged<bool> onChanged;

  /// The color of the checkbox when checked.
  final Color? activeColor;

  /// The color of the checkmark icon.
  final Color? checkColor;

  /// Optional custom border side.
  final BorderSide? borderSide;

  @override
  State<MyoCheckbox> createState() => _MyoCheckboxState();
}

class _MyoCheckboxState extends State<MyoCheckbox>
    with SingleTickerProviderStateMixin, HoloGlitchTickerMixin<MyoCheckbox> {
  @override
  void didUpdateWidget(covariant MyoCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      triggerGlitch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    final activeColor = widget.activeColor ?? theme.accentHot;
    final checkColor = widget.checkColor ?? theme.black;
    final side = widget.borderSide ?? BorderSide(color: theme.outline);

    return HoloGlitch(
      phase: glitchPhase,
      intensity: glitchIntensity,
      severity: 0.3,
      child: GestureDetector(
        onTap: () {
          triggerGlitch();
          widget.onChanged(!widget.value);
        },
        child: AnimatedContainer(
          duration: theme.motionFast,
          curve: theme.curveDecelerate,
          width: spacing20,
          height: spacing20,
          decoration: BoxDecoration(
            color: widget.value ? activeColor : Colors.transparent,
            borderRadius: theme.radiusSm,
            border: Border.all(color: widget.value ? activeColor : side.color),
          ),
          child: widget.value
              ? MyoIcon(
                  intent: 'checkmark',
                  size: spacing16,
                  color: checkColor,
                )
              : null,
        ),
      ),
    );
  }
}
