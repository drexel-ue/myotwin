import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_date_picker.stories.g.dart';

const meta = Meta<DatePickerWrapper>(name: 'MyoDatePicker');

/// A stateful wrapper to allow interactive testing of [MyoDatePicker]
/// within the Widgetbook.
class DatePickerWrapper extends StatefulWidget {
  const DatePickerWrapper({
    super.key,
    required this.label,
    required this.initialValue,
  });

  final String label;
  final DateTime initialValue;

  @override
  State<DatePickerWrapper> createState() => _DatePickerWrapperState();
}

class _DatePickerWrapperState extends State<DatePickerWrapper> {
  late DateTime? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        color: const Color(0xFF0A0A0A),
        padding: const EdgeInsets.all(16),
        child: MyoDatePicker(
          label: widget.label,
          value: _value,
          onChanged: (val) {
            setState(() {
              _value = val;
            });
          },
        ),
      ),
    );
  }
}

final $Default = _Story(
  name: 'Default',
  args: _Args(
    label: StringArg('MISSION START', name: 'Label'),
    initialValue: Arg.fixed(DateTime.now()),
  ),
);
