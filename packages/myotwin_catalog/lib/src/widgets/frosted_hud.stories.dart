import 'package:flutter/material.dart';
import 'package:myotwin_catalog/src/custom_args/offset_arg.dart';
import 'package:myotwin_catalog/src/custom_args/widget_arg.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'frosted_hud.stories.g.dart';

const meta = Meta<FrostedHUD>();

final $Default = _Story(
  name: 'Default',
  args: _Args(
    impactPoint: OffsetArg(Offset.zero),
    child: WidgetArg(const SizedBox.shrink()),
  ),
);
