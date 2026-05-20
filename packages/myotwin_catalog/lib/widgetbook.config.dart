import 'package:myotwin_catalog/components.g.dart';
import 'package:myotwin_catalog/src/addons/interactive_grid_host_addon.dart';
import 'package:myotwin_catalog/src/addons/nullable_alignment_addon.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

final config = Config(
  components: components,
  addons: [
    ViewportAddon([
      Viewports.none,
      IosViewports.iPhone13,
    ]),
    MaterialThemeAddon({
      'Light': MyoTwinThemeDataFactory.build(),
      'Dark': MyoTwinThemeDataFactory.build(),
    }),
    InteractiveGridHostAddon(),
    NullableAlignmentAddon(),
  ],
);
