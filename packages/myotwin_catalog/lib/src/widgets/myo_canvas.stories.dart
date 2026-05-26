import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:widgetbook/widgetbook.dart';

part 'myo_canvas.stories.g.dart';

const meta = Meta<MyoCanvasWrapper>(name: 'MyoCanvas');

class MyoCanvasWrapper extends StatefulWidget {
  const MyoCanvasWrapper({super.key});

  @override
  State<MyoCanvasWrapper> createState() => _MyoCanvasWrapperState();
}

class _MyoCanvasWrapperState extends State<MyoCanvasWrapper> {
  @override
  Widget build(BuildContext context) {
    return const MyoCanvas();
  }
}

final $Default = _Story(
  name: 'Default',
);
