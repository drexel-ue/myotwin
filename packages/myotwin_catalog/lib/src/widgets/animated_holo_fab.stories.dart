import 'package:flutter/material.dart';
import 'package:myotwin_catalog/src/custom_args/void_callback_arg.dart';
import 'package:myotwin_catalog/src/custom_args/widget_arg.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'animated_holo_fab.stories.g.dart';

const meta = Meta<AnimatedHoloFAB>();

final $Default = _Story(
  name: 'Default',
  args: _Args(
    onPressed: VoidCallbackArg(
      () => print('pressed'),
    ),
    icon: WidgetArg(emptyWidget),
  ),
);
