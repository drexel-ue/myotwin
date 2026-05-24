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
  void didUpdateWidget(covariant MyoDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != null) {
      _selectedDate = widget.value!;
      triggerGlitch();
    }
  }

  Future<void> _openPicker(BuildContext context) async {
    triggerGlitch();
    await showGeneralDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Select date',
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: context.myoTheme.motionGlitch,
      transitionBuilder: (ctx, anim, secAnim, child) {
        return Theme(
          data: MyoTwinThemeDataFactory.build(),
          child: HoloGlitch(
            phase: anim.value * 10 * math.Random().nextDouble(),
            intensity: anim.isCompleted ? 0.0 : anim.value * 0.6,
            severity: 0.5,
            child: FadeTransition(
              opacity: anim,
              child: child,
            ),
          ),
        );
      },
      pageBuilder: (ctx, _, _) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: MediaQuery(
              data: MediaQuery.of(ctx).copyWith(textScaler: TextScaler.noScaling),
              child: SafeArea(
                child: _MyoCalendarOverlay(
                  selectedDate: _selectedDate,
                  currentDate: DateTime.now(),
                  visibleMonth: _visibleMonth,
                  onDateSelected: (date) {
                    _selectedDate = date;
                    _visibleMonth = DateTime(date.year, date.month);
                    Navigator.of(ctx).pop(date);
                    widget.onChanged(date);
                  },
                  onMonthChange: (month) {
                    triggerGlitch();
                    _visibleMonth = month;
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
  Widget build(BuildContext context) {
    final t = context.myoTheme;
    final hasValue = widget.value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: t.caption.copyWith(
            color: t.onSurfaceMedium,
            letterSpacing: 0.03,
          ),
        ),
        verticalMargin8,
        HoloGlitch(
          phase: glitchPhase,
          intensity: glitchIntensity,
          severity: 0.2,
          child: GestureDetector(
            onTap: () => _openPicker(context),
            child: Container(
              height: 48,
              padding: horizontalPadding12,
              decoration: BoxDecoration(
                border: Border.all(color: t.outline),
                borderRadius: t.radiusSm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      hasValue ? _formatDate(widget.value!) : (widget.hint ?? 'NO DATA'),
                      style: t.bodyMedium.copyWith(
                        color: hasValue ? t.onSurface : t.onSurfaceDim,
                        fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  MyoIcon(
                    intent: 'calendar',
                    size: 18,
                    color: hasValue ? t.accentHot : t.onSurfaceDim,
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
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    _month = widget.visibleMonth;
  }

  @override
  void didUpdateWidget(covariant _MyoCalendarOverlay old) {
    super.didUpdateWidget(old);
    if (old.visibleMonth != widget.visibleMonth) {
      _month = widget.visibleMonth;
    }
  }

  void _prev() {
    var m = _month.subtract(const Duration(days: 32));
    m = DateTime(m.year, m.month);
    _month = m;
    widget.onMonthChange(m);
    setState(() {});
  }

  void _next() {
    var m = _month.add(const Duration(days: 32));
    m = DateTime(m.year, m.month);
    _month = m;
    widget.onMonthChange(m);
    setState(() {});
  }

  static const _wdNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const _moNames = [
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
  Widget build(BuildContext context) {
    final t = context.myoTheme;
    final mo = _month.month;
    final yr = _month.year;
    final dim = DateTime(yr, mo + 1, 0).day;
    final fdow = DateTime(yr, mo).weekday % 7;

    final cells = <Widget>[];
    for (var r = 0; r < 7; r++) {
      for (var c = 0; c < 7; c++) {
        final d = r * 7 + c - fdow + 1;
        final act = d >= 1 && d <= dim;
        cells.add(
          act
              ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: t.surfaceElevated2),
                  ),
                  child: _MyoCalendarDay(
                    day: d,
                    isToday:
                        d == widget.currentDate.day && mo == widget.currentDate.month && yr == widget.currentDate.year,
                    isSelected:
                        d == widget.selectedDate.day &&
                        mo == widget.selectedDate.month &&
                        yr == widget.selectedDate.year,
                    onTap: () => widget.onDateSelected(DateTime(yr, mo, d)),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: t.outlineDim),
                  ),
                  child: const SizedBox.shrink(),
                ),
        );
      }
    }

    return Material(
      color: t.surface,
      borderRadius: t.radiusSm,
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          border: Border.all(color: t.outline),
          borderRadius: t.radiusSm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: horizontalPadding12 + verticalPadding8,
              color: t.surfaceElevated2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _navBtn(Icons.chevron_left, _prev, t.accentHot),
                  Column(
                    children: [
                      Text(
                        _moNames[mo - 1],
                        style: t.headlineMedium.copyWith(
                          color: t.accentHot,
                          letterSpacing: 0.06,
                        ),
                      ),
                      Text(
                        '$yr',
                        style: t.caption.copyWith(color: t.onSurfaceMedium),
                      ),
                    ],
                  ),
                  _navBtn(Icons.chevron_right, _next, t.accentHot),
                ],
              ),
            ),
            // Weekday row
            Row(
              children: List.generate(7, (i) => _wdChip(_wdNames[i], t)),
            ),
            // Separator
            Divider(height: 1, color: t.outline),
            // Grid
            Flexible(
              child: Padding(
                padding: EdgeInsets.zero,
                child: GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.1,
                  children: cells,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback cb, Color clr) {
    return InkWell(
      onTap: cb,
      borderRadius: borderRadius4,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: borderRadius4,
          border: Border.all(color: clr),
        ),
        child: Icon(icon, size: 14, color: clr),
      ),
    );
  }

  Widget _wdChip(String label, MyoTwinTheme t) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: t.caption.copyWith(
            color: t.onSurfaceMedium,
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
  Widget build(BuildContext context) {
    final t = context.myoTheme;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? t.accentHot
            : isToday
            ? t.surfaceElevated3
            : null,
        border: isToday && !isSelected ? Border.all(color: t.accentHot) : null,
        borderRadius: borderRadius2,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius2,
        child: Center(
          child: Text(
            '$day',
            style: t.bodySmall.copyWith(
              color: isSelected ? t.black : t.onSurfaceMedium,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
