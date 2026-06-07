import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myotwin_app/src/application/common/app_init_cubit.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A HUD-themed loading screen for the application boot sequence.
class BootScreen extends StatefulWidget {
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
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  final ScrollController _terminalScrollController = ScrollController();
  bool _userIsScrolling = false;

  @override
  void dispose() {
    _terminalScrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_terminalScrollController.hasClients && !_userIsScrolling) {
      unawaited(
        _terminalScrollController.animateTo(
          _terminalScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return Scaffold(
      backgroundColor: theme.surface,
      body: InteractiveGrid(
        child: Center(
          child: Container(
            width: 340,
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
                  widget.status,
                  style: theme.caption.copyWith(
                    color: theme.onSurfaceMedium,
                    fontFamily: 'JetBrainsMono',
                  ),
                ),
                verticalMargin8,
                MyoLinearProgressIndicator(
                  progress: widget.progress,
                ),
                verticalMargin16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(widget.progress * 100).toInt()}%',
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

                // TACTICAL BOOT TERMINAL
                verticalMargin24,
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 160),
                  child: Container(
                    width: double.infinity,
                    padding: allPadding8,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      border: Border.all(
                        color: theme.outline,
                        width: 0.5,
                      ),
                    ),
                    child: BlocConsumer<AppInitCubit, AppInitState>(
                      listenWhen: (prev, curr) => prev.logs.length != curr.logs.length,
                      listener: (context, state) => _scrollToBottom(),
                      builder: (context, state) {
                        return NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is UserScrollNotification) {
                              // If user is at the bottom, allow auto-scroll again
                              _userIsScrolling =
                                  _terminalScrollController.position.pixels <
                                  _terminalScrollController.position.maxScrollExtent - 10;
                            }
                            return false;
                          },
                          child: ListView.builder(
                            controller: _terminalScrollController,
                            shrinkWrap: true,
                            itemCount: state.logs.length,
                            itemBuilder: (context, index) {
                              final log = state.logs[index];
                              final isAlert = log.contains('[ALERT]');
                              return Text(
                                log,
                                style: theme.terminal.copyWith(
                                  fontSize: 9,
                                  color: isAlert ? theme.error : theme.onSurfaceMedium,
                                  height: 1.4,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
