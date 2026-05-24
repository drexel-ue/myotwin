import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_checkbox.stories.g.dart';

const meta = Meta<CheckboxWrapper>(name: 'MyoCheckbox');

/// A stateful wrapper to allow interactive testing of [MyoCheckbox]
/// within the Widgetbook.
class CheckboxWrapper extends StatefulWidget {
  const CheckboxWrapper({
    super.key,
    required this.initialValue,
  });

  final bool initialValue;

  @override
  State<CheckboxWrapper> createState() => _CheckboxWrapperState();
}

class _CheckboxWrapperState extends State<CheckboxWrapper> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyoCheckbox(
        value: _value,
        onChanged: (newValue) {
          setState(() {
            _value = newValue;
          });
        },
      ),
    );
  }
}

final $Default = _Story(
  name: 'Default',
  args: _Args(
    initialValue: BoolArg(false, name: 'Value'),
  ),
);

final $Checked = _Story(
  name: 'Checked',
  args: _Args(
    initialValue: BoolArg(true, name: 'Value'),
  ),
);
