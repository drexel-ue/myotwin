import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_switch.stories.g.dart';

const meta = Meta<SwitchWrapper>(name: 'MyoSwitch');

/// A stateful wrapper to allow interactive testing of [MyoSwitch]
/// within the Widgetbook.
class SwitchWrapper extends StatefulWidget {
  const SwitchWrapper({
    super.key,
    this.initialValue = false,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
  });

  /// Initial value of the switch.
  final bool initialValue;

  /// Color of the track when active.
  final Color? activeColor;

  /// Color of the track when inactive.
  final Color? inactiveColor;

  /// Color of the pill thumb.
  final Color? thumbColor;

  @override
  State<SwitchWrapper> createState() => _SwitchWrapperState();
}

class _SwitchWrapperState extends State<SwitchWrapper> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _onChanged(bool newValue) {
    setState(() {
      _value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyoSwitch(
        value: _value,
        onChanged: _onChanged,
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        thumbColor: widget.thumbColor,
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

final $Toggled = _Story(
  name: 'Toggled',
  args: _Args(
    initialValue: BoolArg(true, name: 'Value'),
  ),
);

final $RedSwitch = _Story(
  name: 'Red (Error)',
  args: _Args(
    initialValue: BoolArg(true, name: 'Value'),
    activeColor: ColorArg(const Color(0xFFEF4444), name: 'Active Color'),
  ),
);
