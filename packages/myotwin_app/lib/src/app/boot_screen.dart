import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A HUD-themed loading screen for the application boot sequence.
class BootScreen extends StatelessWidget {
  /// Creates a [BootScreen].
  const BootScreen({
    super.key,
    required this.progress,
    this.status = 'INITIALIZING_MOTUS_CORE...',
  });

  /// The current initialization progress (0.0 to 1.0).
  final double progress;

  /// A status message to display.
  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return Scaffold(
      backgroundColor: theme.surface,
      body: InteractiveGrid(
        child: Center(
          child: Container(
            width: 300,
            padding: allPadding24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SYSTEM_BOOT',
                  style: theme.displayMedium.copyWith(
                    color: theme.accentHot,
                    letterSpacing: 2.0,
                  ),
                ),
                verticalMargin16,
                Text(
                  status,
                  style: theme.caption.copyWith(
                    color: theme.onSurfaceMedium,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
                verticalMargin8,
                MyoLinearProgressIndicator(
                  progress: progress,
                ),
                verticalMargin16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: theme.bodySmall.copyWith(
                        color: theme.accentHot,
                        fontFamily: 'JetBrainsMono',
                      ),
                    ),
                    Text(
                      'LOCAL_INFERENCE_ACTIVE',
                      style: theme.bodySmall.copyWith(
                        color: theme.onSurfaceDim,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
