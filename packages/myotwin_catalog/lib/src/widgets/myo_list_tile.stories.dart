import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_list_tile.stories.g.dart';

const meta = Meta<ListTileWrapper>(name: 'MyoListTile');

/// A stateful wrapper to allow interactive testing of [MyoListTile]
/// within the Widgetbook.
class ListTileWrapper extends StatefulWidget {
  const ListTileWrapper({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
  });

  final String title;
  final String subtitle;
  final bool isSelected;

  @override
  State<ListTileWrapper> createState() => _ListTileWrapperState();
}

class _ListTileWrapperState extends State<ListTileWrapper> {
  bool _selected = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.isSelected;
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
          isSelected: _selected,
          leading: const Icon(Icons.info_outline, size: 16, color: Colors.white),
          trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.white),
          onTap: () {
            setState(() {
              _selected = !_selected;
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
    title: StringArg('System Status', name: 'Title'),
    subtitle: StringArg('Online', name: 'Subtitle'),
    isSelected: BoolArg(false, name: 'Selected'),
  ),
);

final $Selected = _Story(
  name: 'Selected',
  args: _Args(
    title: StringArg('Active Process', name: 'Title'),
    subtitle: StringArg('Analyzing...', name: 'Subtitle'),
    isSelected: BoolArg(true, name: 'Selected'),
  ),
);
