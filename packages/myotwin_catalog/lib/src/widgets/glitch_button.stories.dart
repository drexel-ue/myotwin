import 'package:flutter/material.dart';
import 'package:myotwin_catalog/src/custom_args/void_callback_arg.dart';
import 'package:myotwin_catalog/src/custom_args/widget_arg.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'glitch_button.stories.g.dart';

const meta = Meta<GlitchButton>();

final $Default = _Story(
  name: 'Default',
  args: _Args(
    enabled: BoolArg(true, name: 'Enabled'),
    onPressed: VoidCallbackArg(
      () => debugPrint('GlitchButton pressed'),
    ),
    child: WidgetArg(
      const Text('SYSTEM_INIT'),
    ),
  ),
);

final $Disabled = _Story(
  name: 'Disabled',
  args: _Args(
    enabled: BoolArg(false, name: 'Disabled'),
    onPressed: VoidCallbackArg(
      () => debugPrint('GlitchButton pressed'),
    ),
    child: WidgetArg(
      const Text('SYSTEM_OFFLINE'),
    ),
  ),
);
