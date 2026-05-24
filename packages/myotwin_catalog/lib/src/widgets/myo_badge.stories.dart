import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_badge.stories.g.dart';

const meta = Meta<BadgeWrapper>(name: 'MyoBadge');

/// A stateful wrapper to allow interactive testing of [MyoBadge]
/// within the Widgetbook.
class BadgeWrapper extends StatefulWidget {
  const BadgeWrapper({
    super.key,
    required this.initialCount,
    required this.style,
  });

  final String initialCount;
  final MyoBadgeStyle style;

  @override
  State<BadgeWrapper> createState() => _BadgeWrapperState();
}

class _BadgeWrapperState extends State<BadgeWrapper> {
  late String _currentCount;

  @override
  void initState() {
    super.initState();
    _currentCount = widget.initialCount;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyoBadge(
            count: _currentCount,
            style: widget.style,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    final val = int.tryParse(_currentCount) ?? 0;
                    _currentCount = (val - 1).toString();
                  });
                },
                icon: const Icon(Icons.remove, size: 16),
                label: const Text('Decrement'),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    final val = int.tryParse(_currentCount) ?? 0;
                    _currentCount = (val + 1).toString();
                  });
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Increment'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final $Default = _Story(
  name: 'Default',
  args: _Args(
    initialCount: StringArg('0', name: 'Count'),
    style: EnumArg(MyoBadgeStyle.filledWhite, name: 'Style', values: MyoBadgeStyle.values),
  ),
);

final $ErrorFilled = _Story(
  name: 'Error Filled',
  args: _Args(
    initialCount: StringArg('99+', name: 'Count'),
    style: Arg.fixed(MyoBadgeStyle.filledError),
  ),
);

final $ErrorOutlined = _Story(
  name: 'Error Outlined',
  args: _Args(
    initialCount: StringArg('!', name: 'Count'),
    style: Arg.fixed(MyoBadgeStyle.outlinedError),
  ),
);

final $WhiteOutlined = _Story(
  name: 'White Outlined',
  args: _Args(
    initialCount: StringArg('12', name: 'Count'),
    style: Arg.fixed(MyoBadgeStyle.outlinedWhite),
  ),
);
