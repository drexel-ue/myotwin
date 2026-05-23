import 'package:flutter/material.dart';
import 'package:myotwin_catalog/src/custom_args/void_callback_arg.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_icon_button.stories.g.dart';

const meta = Meta<MyoIconButton>();

final $Default = _Story(
  name: 'Default',
  args: _Args(
    intent: StringArg('biometric scan', name: 'Intent'),
    fallbackIntent: StringArg('fingerprint', name: 'Fallback Intent'),
    onPressed: VoidCallbackArg(
      () => debugPrint('MyoIconButton pressed'),
    ),
    enabled: BoolArg(true, name: 'Enabled'),
    size: DoubleArg(48.0, name: 'Size'),
    color: ColorArg(Colors.white, name: 'Color'),
  ),
);

final $Disabled = _Story(
  name: 'Disabled',
  args: _Args(
    intent: StringArg('biometric scan', name: 'Intent'),
    fallbackIntent: StringArg('fingerprint', name: 'Fallback Intent'),
    onPressed: VoidCallbackArg(
      () => debugPrint('MyoIconButton pressed'),
    ),
    enabled: BoolArg(false, name: 'Enabled'),
    size: DoubleArg(48.0, name: 'Size'),
    color: ColorArg(Colors.white, name: 'Color'),
  ),
);

final $Corrupted = _Story(
  name: 'Corrupted',
  args: _Args(
    intent: StringArg('', name: 'Intent'),
    fallbackIntent: StringArg('', name: 'Fallback Intent'),
    onPressed: VoidCallbackArg(
      () => debugPrint('MyoIconButton pressed'),
    ),
    enabled: BoolArg(true, name: 'Enabled'),
    size: DoubleArg(48.0, name: 'Size'),
    color: ColorArg(Colors.red, name: 'Color'),
  ),
);
