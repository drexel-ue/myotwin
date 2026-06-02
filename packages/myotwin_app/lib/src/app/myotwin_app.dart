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
import 'package:shared_core/shared_core.dart' as domain;

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
                agent: context.read<domain.MotusAgent>(),
              ),
            );
            unawaited(cubit.initialize());
            return cubit;
          },
          child: BlocListener<ChatCubit, ChatState>(
            listenWhen: (prev, curr) =>
                prev.isThinking != curr.isThinking ||
                prev.isResponding != curr.isResponding ||
                prev.isTransitioning != curr.isTransitioning,
            listener: (context, state) {
              if (state.isThinking) {
                _fabStateNotifier.value = HoloState.thinking;
              } else if (state.isResponding) {
                _fabStateNotifier.value = HoloState.active;
              } else {
                _fabStateNotifier.value = HoloState.idle;
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
  State<_MyoStartupOrchestrator> createState() => _MyoStartupOrchestratorState();
}

class _MyoStartupOrchestratorState extends State<_MyoStartupOrchestrator>
    with TickerProviderStateMixin, HoloGlitchTickerMixin<_MyoStartupOrchestrator> {
  late final AnimationController _perceivedController;
  bool _readyToTransition = false;
  bool _showGoalExplorer = false;
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

    return BlocListener<ChatCubit, ChatState>(
      listenWhen: (prev, curr) => prev.isTransitioning != curr.isTransitioning,
      listener: (context, state) {
        if (state.isTransitioning) {
          triggerGlitch();
        }
      },
      child: HoloGlitch(
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
                    : Stack(
                    children: [
                    BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    return MyoCanvas(
                      key: const ValueKey('myo_canvas'),
                      fabState: widget.fabState,
                      backgroundChild: InteractiveGrid(
                        child: MyoAnatomyCanvas(
                          activeNodes: state.activeGoal?.metadata.targetAnatomyNodes ?? [],
                        ),
                      ),
                      chatChild: MyoChatList(messages: state.messages),
                      onMessageSubmitted: (value) async {
                        return context.read<ChatCubit>().submit(value);
                      },
                      onShowChatChanged: (visible) {
                        widget.fabState.value =
                            visible ? HoloState.listening : HoloState.idle;
                      },
                      onCommandNodeSelected: (node) {
                        // Node 4 is the mock Goal Explorer
                        if (node == '4') {
                          setState(() => _showGoalExplorer = true);
                        }
                      },
                    );
                  },
                ),
                if (_showGoalExplorer)
                      Positioned.fill(
                        child: Padding(
                          padding: allPadding32,
                          child: Align(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 600,
                                maxHeight: 800,
                              ),
                              child: FutureBuilder<List<domain.Goal>>(
                                future: context.read<ChatCubit>().fetchGoals(),
                                builder: (context, snapshot) {
                                  return GoalExplorerSurface(
                                    goals: snapshot.data ?? [],
                                    onGoalSelected: (goal) async {
                                      await context.read<ChatCubit>().switchGoal(goal.id);
                                      setState(() => _showGoalExplorer = false);
                                    },
                                    onClose: () => setState(() => _showGoalExplorer = false),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
