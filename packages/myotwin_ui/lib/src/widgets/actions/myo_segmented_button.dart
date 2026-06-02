import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A segment definition for [MyoSegmentedButton].
class MyoSegment<T> {
  /// Creates a [MyoSegment].
  const MyoSegment({
    required this.value,
    required this.label,
    this.icon,
  });

  /// The value associated with this segment.
  final T value;

  /// The label text displayed in the segment.
  final String label;

  /// Optional icon to display alongside the label.
  final Widget? icon;
}

/// A segmented control used to select a single value from a set of options.
///
/// Features a holographic glitch effect when the selection changes.
class MyoSegmentedButton<T> extends StatefulWidget {
  /// Creates a [MyoSegmentedButton].
  const MyoSegmentedButton({
    super.key,
    required this.value,
    required this.onSelectionChanged,
    required this.segments,
    this.size,
  });

  /// The currently selected value.
  final T value;

  /// Callback invoked when a segment is selected.
  final ValueChanged<T> onSelectionChanged;

  /// The list of available segments.
  final List<MyoSegment<T>> segments;

  /// The height of the segmented button. Defaults to [spacing48].
  final double? size;

  @override
  State<MyoSegmentedButton<T>> createState() => _MyoSegmentedButtonState<T>();
}

class _MyoSegmentedButtonState<T> extends State<MyoSegmentedButton<T>>
    with SingleTickerProviderStateMixin, HoloGlitchTickerMixin {
  late T _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant MyoSegmentedButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      triggerGlitch();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return Container(
      height: widget.size ?? spacing48,
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: theme.radiusSm,
        border: .all(color: theme.outline),
      ),
      child: ClipRRect(
        borderRadius: theme.radiusSm,
        child: Row(
          mainAxisSize: .min,
          children: widget.segments.map((segment) {
            final isSelected = segment.value == widget.value;
            final isPreviouslySelected = segment.value == _previousValue;
            final shouldGlitch = isSelected || isPreviouslySelected;

            return GestureDetector(
              onTap: () {
                if (!isSelected) {
                  _previousValue = widget.value;
                  triggerGlitch();
                  widget.onSelectionChanged(segment.value);
                }
              },
              child: HoloGlitch(
                phase: glitchPhase,
                intensity: shouldGlitch ? glitchIntensity : 0,
                severity: 0.15,
                child: Container(
                  padding: horizontalPadding16,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? theme.surfaceElevated : Colors.transparent,
                    border: Border(
                      right: BorderSide(
                        color: theme.outline,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: .min,
                      mainAxisAlignment: .center,
                      children: [
                        if (segment.icon != null) ...[
                          segment.icon!,
                          if (segment.label.isNotEmpty) horizontalMargin8,
                        ],
                        if (segment.label.isNotEmpty)
                          Text(
                            segment.label,
                            style: theme.glitch.copyWith(
                              color: isSelected
                                  ? theme.onSurface
                                  : theme.onSurfaceDim,
                              fontSize: 12,
                              fontWeight: isSelected ? .bold : .normal,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
