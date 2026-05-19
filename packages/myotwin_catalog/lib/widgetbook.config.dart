import 'package:flutter/material.dart';
import 'package:myotwin_catalog/components.g.dart';
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
    AlignmentAddon(),
  ],
  appBuilder: (context, child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyoTwinThemeDataFactory.build(),
      home: const Material(
        child: InteractiveGridHost(
          child: SizedBox.shrink(),
        ),
      ),
    );
  },
);
