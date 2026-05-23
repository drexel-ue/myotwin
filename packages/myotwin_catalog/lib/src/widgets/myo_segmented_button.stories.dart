import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_segmented_button.stories.g.dart';

const meta = Meta<SegmentedButtonWrapper>(name: 'MyoSegmentedButton');

/// A stateful wrapper to allow interactive testing of [MyoSegmentedButton]
/// within the Widgetbook.
class SegmentedButtonWrapper extends StatefulWidget {
  const SegmentedButtonWrapper({
    super.key,
    required this.initialValue,
    required this.segments,
  });

  final String initialValue;
  final List<MyoSegment<String>> segments;

  @override
  State<SegmentedButtonWrapper> createState() => _SegmentedButtonWrapperState();
}

class _SegmentedButtonWrapperState extends State<SegmentedButtonWrapper> {
  late String _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return MyoSegmentedButton<String>(
      value: _currentValue,
      segments: widget.segments,
      onSelectionChanged: (newValue) {
        setState(() {
          _currentValue = newValue;
        });
      },
    );
  }
}

final $Default = _Story(
  name: 'Default',
  args: _Args(
    initialValue: StringArg('option1', name: 'Value'),
    segments: Arg.fixed([
      const MyoSegment(value: 'option1', label: 'Option 1'),
      const MyoSegment(value: 'option2', label: 'Option 2'),
      const MyoSegment(value: 'option3', label: 'Option 3'),
    ]),
  ),
);

final $WithIcons = _Story(
  name: 'With Icons',
  args: _Args(
    initialValue: StringArg('info', name: 'Value'),
    segments: Arg.fixed([
      const MyoSegment(
        value: 'info',
        label: 'Info',
        icon: MyoIcon(intent: 'info', size: 16, color: Colors.white),
      ),
      const MyoSegment(
        value: 'settings',
        label: 'Settings',
        icon: MyoIcon(intent: 'settings', size: 16, color: Colors.white),
      ),
    ]),
  ),
);
