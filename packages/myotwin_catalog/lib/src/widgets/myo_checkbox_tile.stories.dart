import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_checkbox_tile.stories.g.dart';

const meta = Meta<CheckboxTileWrapper>(name: 'MyoCheckboxTile');

/// A stateful wrapper for [MyoListTile] with a [MyoCheckbox] as leading.
/// Demonstrates composition: MyoListTile + MyoCheckbox = checkbox tile.
class CheckboxTileWrapper extends StatefulWidget {
  const CheckboxTileWrapper({
    super.key,
    required this.title,
    required this.subtitle,
    required this.initialValue,
  });

  /// Primary text displayed to the right of the checkbox.
  final String title;

  /// Optional subtitle below the title.
  final String? subtitle;

  /// Whether the checkbox starts checked.
  final bool initialValue;

  @override
  State<CheckboxTileWrapper> createState() => _CheckboxTileWrapperState();
}

class _CheckboxTileWrapperState extends State<CheckboxTileWrapper> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.initialValue;
  }

  void _onChanged(bool newValue) {
    setState(() {
      _checked = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        color: const Color(0xFF0A0A0A),
        child: MyoListTile(
          title: widget.title,
          subtitle: widget.subtitle,
          leading: MyoCheckbox(
            value: _checked,
            onChanged: _onChanged,
          ),
          trailing: const Icon(Icons.chevron_right, size: 16, color: Color(0xFFFFFFFF)),
        ),
      ),
    );
  }
}

final $Off = _Story(
  name: 'Off',
  args: _Args(
    title: StringArg('Enable Telemetry', name: 'Title'),
    subtitle: StringArg('Send diagnostic data', name: 'Subtitle'),
    initialValue: BoolArg(false, name: 'Checked'),
  ),
);

final $On = _Story(
  name: 'On',
  args: _Args(
    title: StringArg('Secure Mode', name: 'Title'),
    subtitle: StringArg('End-to-end encryption active', name: 'Subtitle'),
    initialValue: BoolArg(true, name: 'Checked'),
  ),
);

final $NoSubtitle = _Story(
  name: 'No Subtitle',
  args: _Args(
    title: StringArg('Dark Mode', name: 'Title'),
    initialValue: BoolArg(false, name: 'Checked'),
  ),
);
