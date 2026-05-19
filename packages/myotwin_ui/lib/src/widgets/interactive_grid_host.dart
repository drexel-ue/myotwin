import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

class InteractiveGridHost extends StatefulWidget {
  const InteractiveGridHost({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<InteractiveGridHost> createState() => _InteractiveGridHostState();
}

class _InteractiveGridHostState extends State<InteractiveGridHost> {
  final _cameraPan = ValueNotifier<Offset>(.zero);

  @override
  void dispose() {
    _cameraPan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Track the user dragging their mouse or finger
      onPanUpdate: (details) {
        // Add the drag distance to the current offset tracking matrix
        _cameraPan.value += details.delta;
      },
      child: Stack(
        children: [
          // Feed the live coordinates into the GPU painter
          ValueListenableBuilder(
            valueListenable: _cameraPan,
            builder: (context, offset, _) {
              return PrecisionGridBackground(offset: offset);
            },
          ),

          // Your 3D Model or UI components would go here in the foreground
          widget.child,
        ],
      ),
    );
  }
}
