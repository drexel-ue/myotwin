import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_linear_progress_indicator.stories.g.dart';

const meta = Meta<ProgressIndicatorWrapper>(name: 'MyoLinearProgressIndicator');

/// A stateful wrapper to allow interactive testing of [MyoLinearProgressIndicator]
/// within the Widgetbook.
class ProgressIndicatorWrapper extends StatefulWidget {
  const ProgressIndicatorWrapper({
    super.key,
    required this.initialProgress,
    required this.style,
    required this.isInfinite,
  });

  final double? initialProgress;
  final MyoLinearProgressStyle style;
  final bool isInfinite;

  @override
  State<ProgressIndicatorWrapper> createState() => _ProgressIndicatorWrapperState();
}

class _ProgressIndicatorWrapperState extends State<ProgressIndicatorWrapper> {
  late double? _currentProgress;

  @override
  void initState() {
    super.initState();
    _currentProgress = widget.initialProgress;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300,
            child: MyoLinearProgressIndicator(
              progress: widget.isInfinite ? null : _currentProgress,
              style: widget.style,
            ),
          ),
          const SizedBox(height: 24),
          if (!widget.isInfinite)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentProgress = (_currentProgress ?? 0.0) - 0.1;
                      if (_currentProgress! < 0) _currentProgress = 0.0;
                    });
                  },
                  icon: const Icon(Icons.remove, size: 16),
                  label: const Text('Decrement'),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentProgress = (_currentProgress ?? 0.0) + 0.1;
                      if (_currentProgress! > 1.0) _currentProgress = 1.0;
                    });
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Increment'),
                ),
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentProgress = 1.0;
                    });
                  },
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Complete'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

final $InfiniteWhite = _Story(
  name: 'Infinite White',
  args: _Args(
    initialProgress: DoubleArg(0.0, name: 'Progress'),
    style: EnumArg(MyoLinearProgressStyle.white, name: 'Style', values: MyoLinearProgressStyle.values),
    isInfinite: BoolArg(true, name: 'Infinite'),
  ),
);

final $InfiniteError = _Story(
  name: 'Infinite Error',
  args: _Args(
    initialProgress: DoubleArg(0.0, name: 'Progress'),
    style: EnumArg(MyoLinearProgressStyle.error, name: 'Style', values: MyoLinearProgressStyle.values),
    isInfinite: BoolArg(true, name: 'Infinite'),
  ),
);

final $FixedWhite = _Story(
  name: 'Fixed White',
  args: _Args(
    initialProgress: DoubleArg(0.5, name: 'Progress'),
    style: EnumArg(MyoLinearProgressStyle.white, name: 'Style', values: MyoLinearProgressStyle.values),
    isInfinite: BoolArg(false, name: 'Infinite'),
  ),
);

final $FixedError = _Story(
  name: 'Fixed Error',
  args: _Args(
    initialProgress: DoubleArg(0.5, name: 'Progress'),
    style: EnumArg(MyoLinearProgressStyle.error, name: 'Style', values: MyoLinearProgressStyle.values),
    isInfinite: BoolArg(false, name: 'Infinite'),
  ),
);
