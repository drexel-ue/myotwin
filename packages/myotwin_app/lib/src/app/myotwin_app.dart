import 'dart:async';
import 'dart:math' as math;

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
  State<_MyoStartupOrchestrator> createState() =>
      _MyoStartupOrchestratorState();
}

class _MyoStartupOrchestratorState extends State<_MyoStartupOrchestrator>
    with TickerProviderStateMixin, HoloGlitchTickerMixin<_MyoStartupOrchestrator> {
  late final AnimationController _perceivedController;
  bool _readyToTransition = false;
  String _status = 'INITIALIZING_MOTUS_CORE...';

  @override
  void initState() {
    super.initState();
    _perceivedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _perceivedController.addListener(_checkHandoff);
    widget.agent.addListener(_checkHandoff);

    // Start the cinematic boot "scan"
    unawaited(_perceivedController.forward());
  }

  @override
  void dispose() {
    _perceivedController.dispose();
    widget.agent.removeListener(_checkHandoff);
    super.dispose();
  }

  void _checkHandoff() {
    if (_readyToTransition) return;

    // We only transition when:
    // 1. The actual model is loaded.
    // 2. The perceived cinematic "scan" animation is finished.
    if (widget.agent.isInitialized && _perceivedController.isCompleted) {
      setState(() {
        _status = 'SYSTEM_READY_FOR_INPUT';
      });

      // Brief cinematic hold at "100%" before ignition
      Timer(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        setState(() {
          _readyToTransition = true;
        });
        triggerGlitch();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return HoloGlitch(
      phase: glitchPhase,
      intensity: glitchIntensity,
      severity: 0.2,
      child: AnimatedSwitcher(
        duration: theme.motionHolographic,
        switchInCurve: theme.curveEaseOut,
        switchOutCurve: theme.curveDecelerate,
        child: !_readyToTransition
            ? AnimatedBuilder(
                key: const ValueKey('boot_screen'),
                animation: Listenable.merge([
                  _perceivedController,
                  widget.agent.loadingProgress,
                ]),
                builder: (context, _) {
                  // The UI shows whichever is higher: the real download or the cinematic scan.
                  // This masks instant loads while still respecting slow downloads.
                  final progress = math.max(
                    _perceivedController.value,
                    widget.agent.loadingProgress.value,
                  );

                  return BootScreen(
                    progress: progress,
                    status: _status,
                  );
                },
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
