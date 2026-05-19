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
      'Light': ThemeData.light(),
      'Dark': ThemeData.dark(),
    }),
    AlignmentAddon(),
  ],
  appBuilder: (context, child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        child: Stack(
          fit: .passthrough,
          children: [
            const GraphPaperBackground(),
            child,
          ],
        ),
      ),
    );
  },
);
