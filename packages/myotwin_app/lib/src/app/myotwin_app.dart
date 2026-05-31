import 'package:flutter/material.dart';
import 'package:myotwin_app/src/app/boot_screen.dart';
import 'package:myotwin_app/src/infrastructure/ai/local_motus_agent.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:provider/provider.dart';

/// Top-level MyoTwin application widget.
class MyotwinApp extends StatefulWidget {
  /// Creates a MyoTwin mobile application widget.
  const MyotwinApp({super.key});

  @override
  State<MyotwinApp> createState() => _MyotwinAppState();
}

class _MyotwinAppState extends State<MyotwinApp> {
  @override
  Widget build(BuildContext context) {
    final agent = context.watch<LocalMotusAgent>();

    return MaterialApp(
      title: 'MyoTwin',
      debugShowCheckedModeBanner: false,
      theme: MyoTwinThemeDataFactory.build(),
      home: Material(
        child: _MyoStartupOrchestrator(agent: agent),
      ),
    );
  }
}

/// Orchestrates the visual transition between the boot sequence and the HUD.
class _MyoStartupOrchestrator extends StatefulWidget {
  const _MyoStartupOrchestrator({required this.agent});

  final LocalMotusAgent agent;

  @override
  State<_MyoStartupOrchestrator> createState() => _MyoStartupOrchestratorState();
}

class _MyoStartupOrchestratorState extends State<_MyoStartupOrchestrator>
    with SingleTickerProviderStateMixin, HoloGlitchTickerMixin<_MyoStartupOrchestrator> {
  bool _wasInitialized = false;

  @override
  void initState() {
    super.initState();
    _wasInitialized = widget.agent.isInitialized;
  }

  void _checkInitialization() {
    if (widget.agent.isInitialized && !_wasInitialized) {
      _wasInitialized = true;
      triggerGlitch();
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkInitialization();
    final theme = context.myoTheme;

    return HoloGlitch(
      phase: glitchPhase,
      intensity: glitchIntensity,
      severity: 0.2, // Stronger glitch for boot-up success
      child: AnimatedSwitcher(
        duration: theme.motionHolographic,
        switchInCurve: theme.curveEaseOut,
        switchOutCurve: theme.curveDecelerate,
        child: !widget.agent.isInitialized
            ? ListenableBuilder(
                key: const ValueKey('boot_screen'),
                listenable: widget.agent.loadingProgress,
                builder: (context, _) => BootScreen(
                  progress: widget.agent.loadingProgress.value,
                ),
              )
            : const MyoCanvas(
                key: ValueKey('myo_canvas'),
                backgroundChild: InteractiveGrid(
                  child: emptyWidget,
                ),
                chatChild: MyoChatList(),
                onShowChatChanged: _handleShowChatChanged,
              ),
      ),
    );
  }

  static void _handleShowChatChanged(bool visible) {
    // Top-level global visibility tracking if needed.
  }
}
