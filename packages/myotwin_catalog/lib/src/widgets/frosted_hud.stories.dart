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
    impactPoint: OffsetArg(.zero),
    child: WidgetArg(
      const SizedBox(
        width: 300.0, // Forces the HUD to be exactly 300px wide
        height: 150.0, // Forces the HUD to be exactly 150px tall
        child: HolographicDecryptText(
          'TISSUE INTEGRITY: NOMINAL\nTORQUE LIMITS: EXCEEDED',
        ),
      ),
    ),
  ),
);
