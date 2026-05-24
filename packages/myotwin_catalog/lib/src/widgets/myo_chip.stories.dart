import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_chip.stories.g.dart';

const meta = Meta<ChipWrapper>(name: 'MyoChip');

/// A stateful wrapper to allow interactive testing of [MyoChip]
/// within the Widgetbook.
class ChipWrapper extends StatefulWidget {
  const ChipWrapper({
    super.key,
    required this.label,
    required this.initialSelected,
    required this.style,
  });

  final String label;
  final bool initialSelected;
  final MyoChipStyle style;

  @override
  State<ChipWrapper> createState() => _ChipWrapperState();
}

class _ChipWrapperState extends State<ChipWrapper> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyoChip(
        label: widget.label,
        isSelected: _isSelected,
        style: widget.style,
        onSelected: (val) {
          setState(() {
            _isSelected = val;
          });
        },
      ),
    );
  }
}

final $Default = _Story(
  name: 'Default',
  args: _Args(
    label: StringArg('System Status', name: 'Label'),
    initialSelected: BoolArg(false, name: 'Selected'),
    style: EnumArg(MyoChipStyle.outlined, name: 'Style', values: MyoChipStyle.values),
  ),
);

final $Filled = _Story(
  name: 'Filled',
  args: _Args(
    label: StringArg('Active Node', name: 'Label'),
    initialSelected: BoolArg(true, name: 'Selected'),
    style: Arg.fixed(MyoChipStyle.filled),
  ),
);

final $Outlined = _Story(
  name: 'Outlined',
  args: _Args(
    label: StringArg('Inactive Node', name: 'Label'),
    initialSelected: BoolArg(false, name: 'Selected'),
    style: Arg.fixed(MyoChipStyle.outlined),
  ),
);
