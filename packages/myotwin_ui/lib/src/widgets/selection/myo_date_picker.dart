import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A cyberpunk HUD-style date picker with full custom calendar rendering.
class MyoDatePicker extends StatefulWidget {
  /// Creates a [MyoDatePicker].
  const MyoDatePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
  });

  /// The label displayed above the date input.
  final String label;

  /// The currently selected date.
  final DateTime? value;

  /// Called when the user selects a date.
  final ValueChanged<DateTime> onChanged;

  /// Optional hint text shown when no date is selected.
  final String? hint;

  @override
  State<MyoDatePicker> createState() => _MyoDatePickerState();
}

class _MyoDatePickerState extends State<MyoDatePicker>
    with SingleTickerProviderStateMixin, HoloGlitchTickerMixin<MyoDatePicker> {
  late DateTime _visibleMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.value ?? DateTime.now();
    _visibleMonth = _selectedDate;
  }

  @override
  void didUpdateWidget(covariant MyoDatePicker previousWidget) {
    super.didUpdateWidget(previousWidget);
    if (previousWidget.value != widget.value && widget.value != null) {
      _selectedDate = widget.value!;
      triggerGlitch();
    }
  }

  Future<void> _openPicker(BuildContext buildContext) async {
    triggerGlitch();
    await showGeneralDialog<DateTime>(
      context: buildContext,
      barrierDismissible: true,
      barrierLabel: 'Select date',
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: buildContext.myoTheme.motionGlitch,
      transitionBuilder: (datePickerContext, animation, secondaryAnimation, child) {
        return Theme(
          data: MyoTwinThemeDataFactory.build(),
          child: HoloGlitch(
            phase: animation.value * 10 * _random.nextDouble(),
            intensity: animation.isCompleted ? 0.0 : animation.value * 0.6,
            severity: 0.5,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );
      },
      pageBuilder: (overlayContext, _, dialogAttributes) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: MediaQuery(
              data: MediaQuery.of(overlayContext).copyWith(textScaler: .noScaling),
              child: SafeArea(
                child: _MyoCalendarOverlay(
                  selectedDate: _selectedDate,
                  currentDate: DateTime.now(),
                  visibleMonth: _visibleMonth,
                  onDateSelected: (selectedDate) {
                    _selectedDate = selectedDate;
                    _visibleMonth = DateTime(selectedDate.year, selectedDate.month);
                    Navigator.of(overlayContext).pop(selectedDate);
                    widget.onChanged(selectedDate);
                  },
                  onMonthChange: (newMonth) {
                    triggerGlitch();
                    _visibleMonth = newMonth;
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
    // Ignore picked for now since we handle it inline
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext buildContext) {
    final theme = buildContext.myoTheme;
    final hasValue = widget.value != null;

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: theme.caption.copyWith(
            color: theme.onSurfaceMedium,
            letterSpacing: 0.03,
          ),
        ),
        verticalMargin8,
        HoloGlitch(
          phase: glitchPhase,
          intensity: glitchIntensity,
          severity: 0.2,
          child: GestureDetector(
            onTap: () => _openPicker(buildContext),
            child: Container(
              height: 48,
              padding: horizontalPadding12,
              decoration: BoxDecoration(
                border: Border.all(color: theme.outline),
                borderRadius: theme.radiusSm,
              ),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      hasValue ? _formatDate(widget.value!) : (widget.hint ?? 'NO DATA'),
                      style: theme.bodyMedium.copyWith(
                        color: hasValue ? theme.onSurface : theme.onSurfaceDim,
                        fontWeight: hasValue ? .w600 : .normal,
                      ),
                    ),
                  ),
                  MyoIcon(
                    intent: 'calendar',
                    size: 18,
                    color: hasValue ? theme.accentHot : theme.onSurfaceDim,
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

// --- helpers

final _random = math.Random();

// ---------------------------------------------------------------------------
//  Calendar overlay
// ---------------------------------------------------------------------------

class _MyoCalendarOverlay extends StatefulWidget {
  const _MyoCalendarOverlay({
    required this.selectedDate,
    required this.currentDate,
    required this.visibleMonth,
    required this.onDateSelected,
    required this.onMonthChange,
  });

  final DateTime selectedDate;
  final DateTime currentDate;
  final DateTime visibleMonth;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTime> onMonthChange;

  @override
  State<_MyoCalendarOverlay> createState() => _MyoCalendarOverlayState();
}

class _MyoCalendarOverlayState extends State<_MyoCalendarOverlay> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _displayedMonth = widget.visibleMonth;
  }

  @override
  void didUpdateWidget(covariant _MyoCalendarOverlay previousOverlay) {
    super.didUpdateWidget(previousOverlay);
    if (previousOverlay.visibleMonth != widget.visibleMonth) {
      _displayedMonth = widget.visibleMonth;
    }
  }

  void _previousMonth() {
    var result = _displayedMonth.subtract(const Duration(days: 32));
    result = DateTime(result.year, result.month);
    _displayedMonth = result;
    widget.onMonthChange(result);
    setState(() {});
  }

  void _nextMonth() {
    var result = _displayedMonth.add(const Duration(days: 32));
    result = DateTime(result.year, result.month);
    _displayedMonth = result;
    widget.onMonthChange(result);
    setState(() {});
  }

  static const _weekdayNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const _monthNames = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  @override
  Widget build(BuildContext buildContext) {
    final theme = buildContext.myoTheme;
    final currentMonth = _displayedMonth.month;
    final currentYear = _displayedMonth.year;
    final daysInCurrentMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    final firstDayOfWeekIndex = DateTime(currentYear, currentMonth).weekday % 7;

    final calendarCells = <Widget>[];
    for (var rowIndex = 0; rowIndex < 7; rowIndex++) {
      for (var colIndex = 0; colIndex < 7; colIndex++) {
        final cellDayNumber = rowIndex * 7 + colIndex - firstDayOfWeekIndex + 1;
        final isCurrentMonthCell = cellDayNumber >= 1 && cellDayNumber <= daysInCurrentMonth;
        calendarCells.add(
          isCurrentMonthCell
              ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.surfaceElevated2),
                  ),
                  child: _MyoCalendarDay(
                    day: cellDayNumber,
                    isToday:
                        cellDayNumber == widget.currentDate.day &&
                        currentMonth == widget.currentDate.month &&
                        currentYear == widget.currentDate.year,
                    isSelected:
                        cellDayNumber == widget.selectedDate.day &&
                        currentMonth == widget.selectedDate.month &&
                        currentYear == widget.selectedDate.year,
                    onTap: () => widget.onDateSelected(DateTime(currentYear, currentMonth, cellDayNumber)),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.outlineDim),
                  ),
                  child: const SizedBox.shrink(),
                ),
        );
      }
    }

    return Material(
      color: theme.surface,
      borderRadius: theme.radiusSm,
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          border: Border.all(color: theme.outline),
          borderRadius: theme.radiusSm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: horizontalPadding12 + verticalPadding8,
              color: theme.surfaceElevated2,
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  _NavButton(
                    icon: Icons.chevron_left,
                    onPressed: _previousMonth,
                    color: theme.accentHot,
                  ),
                  Column(
                    children: [
                      Text(
                        _monthNames[currentMonth - 1],
                        style: theme.headlineMedium.copyWith(
                          color: theme.accentHot,
                          letterSpacing: 0.06,
                        ),
                      ),
                      Text(
                        '$currentYear',
                        style: theme.caption.copyWith(color: theme.onSurfaceMedium),
                      ),
                    ],
                  ),
                  _NavButton(
                    icon: Icons.chevron_right,
                    onPressed: _nextMonth,
                    color: theme.accentHot,
                  ),
                ],
              ),
            ),
            // Weekday row
            Row(
              children: List.generate(
                7,
                (labelIndex) => _WeekdayLabel(
                  label: _weekdayNames[labelIndex],
                  color: theme.onSurfaceMedium,
                ),
              ),
            ),
            // Separator
            Divider(height: 1, color: theme.outline),
            // Grid
            Flexible(
              child: Padding(
                padding: EdgeInsets.zero,
                child: GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.1,
                  children: calendarCells,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Navigation button
// ---------------------------------------------------------------------------

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext buildContext) {
    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius4,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: borderRadius4,
          border: Border.all(color: color),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Weekday label chip
// ---------------------------------------------------------------------------

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext buildContext) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: buildContext.myoTheme.caption.copyWith(
            color: color,
            letterSpacing: 0.02,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Day cell
// ---------------------------------------------------------------------------

class _MyoCalendarDay extends StatelessWidget {
  const _MyoCalendarDay({
    super.key,
    required this.day,
    required this.isToday,
    required this.isSelected,
    this.onTap,
  });

  final int day;
  final bool isToday;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext buildContext) {
    final theme = buildContext.myoTheme;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? theme.accentHot
            : isToday
            ? theme.surfaceElevated3
            : null,
        border: isToday && !isSelected ? Border.all(color: theme.accentHot) : null,
        borderRadius: borderRadius2,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius2,
        child: Center(
          child: Text(
            '$day',
            style: theme.bodySmall.copyWith(
              color: isSelected ? theme.black : theme.onSurfaceMedium,
              fontWeight: isSelected ? .w700 : .normal,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
