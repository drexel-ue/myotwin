import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    with
        TickerProviderStateMixin,
        HoloGlitchTickerMixin<_MyoStartupOrchestrator> {
  late final AnimationController _perceivedController;
  bool _readyToTransition = false;
  bool _showGoalExplorer = false;
  bool _showAnatomyTargeter = false;
  String _status = 'INITIALIZING_MOTUS_CORE...';

  final _anatomyResetTrigger = ValueNotifier<int>(0);
  final List<String> _manualActiveNodes = [];
  AnatomyLayer? _activeLayer;
  Map<AnatomyLayer, List<String>> _availableNodes = {};

  @override
  void initState() {
    super.initState();
    _perceivedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _perceivedController.addListener(_checkHandoff);
    widget.agent.addListener(_checkHandoff);
    widget.agent.loadingProgress.addListener(_checkHandoff);

    // Start the cinematic boot "scan"
    unawaited(_perceivedController.forward());
  }

  @override
  void dispose() {
    _perceivedController.dispose();
    _anatomyResetTrigger.dispose();
    widget.agent.removeListener(_checkHandoff);
    widget.agent.loadingProgress.removeListener(_checkHandoff);
    super.dispose();
  }

  void _checkHandoff() {
    if (_readyToTransition) return;

    // We only transition when:
    // 1. The actual model is loaded.
    // 2. The perceived cinematic "scan" animation is finished.
    if (widget.agent.isInitialized && _perceivedController.value >= 1.0) {
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
                    widget.agent, // Listen for isInitialized changes
                  ]),
                  builder: (context, _) {
                    final realProgress = widget.agent.loadingProgress.value;
                    final scanProgress = _perceivedController.value;
                    final initError = widget.agent.initializationError;

                    var progress = 0.0;
                    var status = _status;

                    if (initError != null) {
                      progress = realProgress;
                      status = 'FATAL_CORE_ERROR: ${initError.toUpperCase()}';
                    } else if (widget.agent.isInitialized) {
                      // Model is ready, follow the cinematic scan to completion.
                      progress = scanProgress;
                    } else {
                      // Model is still loading.
                      // We show scan progress but CAP it at 90% visually
                      // unless the real progress has overtaken it.
                      progress =
                          math.max(math.min(scanProgress, 0.9), realProgress);

                      if (scanProgress > 0.8) {
                        status =
                            'DOWNLOADING_MODEL_RESOURCES... (${(realProgress * 100).toInt()}%)';
                      }
                    }

                    return BootScreen(
                      progress: progress,
                      status: status,
                    );
                  },
                )
              : Stack(
                  key: const ValueKey('hud_main'),
                  children: [
                    BlocBuilder<ChatCubit, ChatState>(
                      builder: (context, state) {
                        return MyoCanvas(
                          key: const ValueKey('myo_canvas'),
                          fabState: widget.fabState,
                          backgroundChild: InteractiveGrid(
                            onLongPress: () {
                              // --- CINEMATIC RESET PROTOCOL ---
                              // 1. Ignite the visual noise and haptics
                              triggerGlitch();
                              unawaited(HapticFeedback.heavyImpact());

                              // 2. Wait for the peak of the glitch to mask the jump
                              Timer(const Duration(milliseconds: 150), () {
                                if (mounted) {
                                  setState(() {
                                    _manualActiveNodes.clear();
                                    _activeLayer = null;
                                    _anatomyResetTrigger.value++;
                                  });
                                }
                              });
                            },
                            child: MyoAnatomyCanvas(
                              activeNodes: [
                                ...state.activeGoal?.metadata
                                        .targetAnatomyNodes ??
                                    [],
                                ..._manualActiveNodes,
                              ],
                              activeLayer: _activeLayer,
                              resetTrigger: _anatomyResetTrigger,
                              onNodesLoaded: (nodes) {
                                setState(() => _availableNodes = nodes);
                              },
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
                            if (node == '4') {
                              setState(() => _showGoalExplorer = true);
                            } else if (node == '3') {
                              setState(() => _showAnatomyTargeter = true);
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
                                      await context
                                          .read<ChatCubit>()
                                          .switchGoal(goal.id);
                                      setState(() => _showGoalExplorer = false);
                                    },
                                    onClose: () =>
                                        setState(() => _showGoalExplorer = false),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_showAnatomyTargeter)
                      Positioned(
                        right: 32,
                        top: 32,
                        bottom: 32,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 340),
                          child: AnatomyTargetingSurface(
                            nodesByLayer: _availableNodes,
                            activeLayer: _activeLayer,
                            onLayerChanged: (layer) {
                              setState(() => _activeLayer = layer);
                            },
                            onNodeSelected: (node) {
                              setState(() {
                                if (_manualActiveNodes.contains(node)) {
                                  _manualActiveNodes.remove(node);
                                } else {
                                  _manualActiveNodes.add(node);
                                }
                              });
                            },
                            onClose: () =>
                                setState(() => _showAnatomyTargeter = false),
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
