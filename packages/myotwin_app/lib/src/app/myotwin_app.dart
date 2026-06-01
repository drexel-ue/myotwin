import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myotwin_app/src/app/boot_screen.dart';
import 'package:myotwin_app/src/application/chat/chat_cubit.dart';
import 'package:myotwin_app/src/infrastructure/ai/local_motus_agent.dart';
import 'package:myotwin_app/src/infrastructure/chat/chat_repository.dart';
import 'package:myotwin_app/src/infrastructure/persistence/myotwin_database.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:shared_core/shared_core.dart';

/// Top-level MyoTwin application widget.
class MyotwinApp extends StatefulWidget {
  /// Creates a MyoTwin mobile application widget.
  const MyotwinApp({super.key});

  @override
  State<MyotwinApp> createState() => _MyotwinAppState();
}

class _MyotwinAppState extends State<MyotwinApp> {
  final _fabStateNotifier = ValueNotifier<HoloState>(HoloState.idle);

  @override
  void dispose() {
    _fabStateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final agent = context.watch<LocalMotusAgent>();

    return MaterialApp(
      title: 'MyoTwin',
      debugShowCheckedModeBanner: false,
      theme: MyoTwinThemeDataFactory.build(),
      home: Material(
        child: BlocProvider(
          create: (context) {
            final cubit = ChatCubit(
              repository: ChatRepository(
                database: context.read<MyoTwinDatabase>(),
                agent: context.read<MotusAgent>(),
              ),
            );
            unawaited(cubit.initialize());
            return cubit;
          },
          child: BlocListener<ChatCubit, ChatState>(
            listener: (context, state) {
              if (state.isThinking) {
                _fabStateNotifier.value = HoloState.thinking;
              } else if (state.isResponding) {
                _fabStateNotifier.value = HoloState.active;
              } else {
                // Return to listening if chat is presumed open
                _fabStateNotifier.value = HoloState.listening;
              }
            },
            child: _MyoStartupOrchestrator(
              agent: agent,
              fabState: _fabStateNotifier,
            ),
          ),
        ),
      ),
    );
  }
}

/// Orchestrates the visual transition between the boot sequence and the HUD.
class _MyoStartupOrchestrator extends StatefulWidget {
  const _MyoStartupOrchestrator({
    required this.agent,
    required this.fabState,
  });

  final LocalMotusAgent agent;
  final ValueNotifier<HoloState> fabState;

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
            : MyoCanvas(
                key: const ValueKey('myo_canvas'),
                fabState: widget.fabState,
                backgroundChild: const InteractiveGrid(
                  child: emptyWidget,
                ),
                chatChild: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    return MyoChatList(messages: state.messages);
                  },
                ),
                onMessageSubmitted: (value) async {
                  return context.read<ChatCubit>().submit(value);
                },
                onShowChatChanged: (visible) {
                  widget.fabState.value =
                      visible ? HoloState.listening : HoloState.idle;
                },
              ),
      ),
    );
  }
}
