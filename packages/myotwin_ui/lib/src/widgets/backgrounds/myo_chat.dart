import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

class MyoChat extends StatelessWidget {
  const MyoChat({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .passthrough,
      children: [
        // 1. The Blur (Unmasked)
        // We push the blur down slightly so its hard top edge is hidden
        // behind the darker part of the color gradient below.
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: const SizedBox.expand(),
            ),
          ),
        ),

        // 2. The Color Gradient (The physical darkness sliding up)
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: .topCenter,
                end: .bottomCenter,
                colors: [
                  Colors.transparent,
                  context.myoTheme.surface.withValues(alpha: 0.2),
                  context.myoTheme.surface.withValues(alpha: 0.8), // Dark anchor at the bottom
                ],
                stops: const [0.0, 0.25, 0.5],
              ),
            ),
          ),
        ),

        // 3. child.
        Positioned.fill(child: child),
      ],
    );
  }
}
