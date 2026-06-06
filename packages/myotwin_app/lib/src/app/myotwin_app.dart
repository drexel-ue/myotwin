import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myotwin_app/src/app/boot_screen.dart';
import 'package:myotwin_app/src/application/chat/chat_cubit.dart';
import 'package:myotwin_app/src/application/common/app_init_cubit.dart';
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
                logger: context.read<domain.LoggerService>(),
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
    required this.fabState,
  });

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

    // Start the cinematic boot "scan"
    unawaited(_perceivedController.forward());
  }

  @override
  void dispose() {
    _perceivedController.dispose();
    _anatomyResetTrigger.dispose();
    super.dispose();
  }

  void _checkHandoff() {
    if (_readyToTransition) return;

    final initReady = context.read<AppInitCubit>().state.isReady;

    // We only transition when:
    // 1. The actual services are initialized via AppInitCubit.
    // 2. The perceived cinematic "scan" animation is finished.
    if (initReady && _perceivedController.value >= 1.0) {
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

    return BlocListener<AppInitCubit, AppInitState>(
      listenWhen: (prev, curr) => prev.isReady != curr.isReady,
      listener: (context, state) {
        if (state.isReady) _checkHandoff();
      },
      child: BlocListener<ChatCubit, ChatState>(
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
                ? BlocBuilder<AppInitCubit, AppInitState>(
                    builder: (context, state) {
                      final scanProgress = _perceivedController.value;
                      
                      // Blend the real init progress with the cinematic scan progress
                      final progress = state.isReady 
                        ? scanProgress 
                        : (scanProgress * 0.9).clamp(0.0, 1.0);

                      return BootScreen(
                        progress: progress,
                        status: state.status,
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
                                triggerGlitch();
                                unawaited(HapticFeedback.heavyImpact());

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
                              selectedNodes: _manualActiveNodes,
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
      ),
    );
  }
}
