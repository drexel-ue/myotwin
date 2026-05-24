import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// Visual styles for [MyoDatePicker].
enum MyoDatePickerStyle {
  /// Solid background with high contrast text.
  filled,

  /// Transparent background with outlined border.
  outlined,
}

/// A cyberpunk HUD-style date picker.
///
/// Glitches visually when tapped or when the selected date changes.
class MyoDatePicker extends StatefulWidget {
  /// Creates a [MyoDatePicker].
  const MyoDatePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.style = .outlined,
    this.hint,
  });

  /// The label displayed above the input field.
  final String label;

  /// The currently selected date.
  final DateTime? value;

  /// Callback triggered when a date is selected.
  final ValueChanged<DateTime?> onChanged;

  /// The visual style of the picker.
  final MyoDatePickerStyle style;

  /// Optional hint text when no date is selected.
  final String? hint;

  @override
  State<MyoDatePicker> createState() => _MyoDatePickerState();
}

class _MyoDatePickerState extends State<MyoDatePicker>
    with SingleTickerProviderStateMixin, HoloGlitchTickerMixin<MyoDatePicker> {
  @override
  void didUpdateWidget(covariant MyoDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      triggerGlitch();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final initialDate = widget.value ?? DateTime.timestamp();
    final firstDate = DateTime(initialDate.year - 5, initialDate.month, initialDate.day);
    final lastDate = DateTime(initialDate.year + 5, initialDate.month, initialDate.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: MyoTwinThemeDataFactory.build(), // Apply MyoTwin theme to the dialog
          child: child!,
        );
      },
    );

    if (picked != null && picked != widget.value) {
      widget.onChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    // Cyberpunk format: YYYY-MM-DD
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Text(
          widget.label,
          style: theme.caption.copyWith(
            color: theme.onSurfaceMedium,
            letterSpacing: 0.03, // overline spacing
          ),
        ),
        verticalMargin8,
        HoloGlitch(
          phase: glitchPhase,
          intensity: glitchIntensity,
          severity: 0.2,
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: widget.style == .filled,
                fillColor: widget.style == .filled ? theme.surfaceElevated2 : Colors.transparent,
                enabledBorder: widget.style == .outlined
                    ? OutlineInputBorder(
                        borderSide: BorderSide(color: theme.outline),
                        borderRadius: theme.radiusSm,
                      )
                    : null,
              ),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.value != null ? _formatDate(widget.value!) : (widget.hint ?? 'NO DATA'),
                      style: theme.bodyMedium.copyWith(
                        color: widget.value != null ? theme.onSurface : theme.onSurfaceDim,
                        fontWeight: widget.value != null ? .w600 : .normal,
                      ),
                    ),
                  ),
                  verticalMargin8,
                  MyoIcon(
                    intent: 'calendar',
                    size: 20,
                    color: widget.value != null ? theme.accentHot : theme.onSurfaceDim,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
