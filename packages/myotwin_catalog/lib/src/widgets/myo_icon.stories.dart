import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_icon.stories.g.dart';

const meta = Meta<MyoIcon>();

final $Default = _Story(
  name: 'Default',
  args: _Args(
    intent: StringArg('biometric scan', name: 'Intent'),
    fallbackIntent: StringArg('fingerprint', name: 'Fallback Intent'),
    color: ColorArg(Colors.white, name: 'Color'),
    size: DoubleArg(24.0, name: 'Size'),
    minimumConfidence: IntArg(0, name: 'Min Confidence'),
  ),
);

final $Resolved = _Story(
  name: 'Resolved',
  args: _Args(
    intent: StringArg('biometric scan', name: 'Intent'),
    fallbackIntent: StringArg('fingerprint', name: 'Fallback Intent'),
    color: ColorArg(Colors.cyanAccent, name: 'Color'),
    size: DoubleArg(48.0, name: 'Size'),
    minimumConfidence: IntArg(0, name: 'Min Confidence'),
  ),
);

final $Corrupted = _Story(
  name: 'Corrupted',
  args: _Args(
    intent: StringArg('', name: 'Intent'),
    fallbackIntent: StringArg('', name: 'Fallback Intent'),
    color: ColorArg(Colors.red, name: 'Color'),
    size: DoubleArg(32.0, name: 'Size'),
    minimumConfidence: IntArg(10, name: 'Min Confidence'),
  ),
);
