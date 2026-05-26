import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_list_tile.stories.g.dart';

const meta = Meta<ListTileWrapper>(name: 'MyoListTile');

/// A stateful wrapper to allow interactive testing of [MyoListTile].
class ListTileWrapper extends StatefulWidget {
  const ListTileWrapper({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
  });

  /// Primary text for the tile.
  final String title;

  /// Secondary text for the tile.
  final String? subtitle;

  /// Whether the tile starts in selected state.
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
          leading: const Icon(Icons.info_outline, size: 16, color: Color(0xFFFFFFFF)),
          trailing: const Icon(Icons.chevron_right, size: 16, color: Color(0xFFFFFFFF)),
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

final $IconLeading = _Story(
  name: 'Icon Leading',
  args: _Args(
    title: StringArg('Network Connection', name: 'Title'),
    subtitle: StringArg('Ethernet active', name: 'Subtitle'),
    isSelected: BoolArg(false, name: 'Selected'),
  ),
);
