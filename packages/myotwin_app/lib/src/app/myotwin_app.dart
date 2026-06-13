import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myotwin_app/src/app/boot_screen.dart';
import 'package:myotwin_app/src/application/anatomy/anatomy_cubit.dart';
import 'package:myotwin_app/src/application/chat/chat_cubit.dart';
import 'package:myotwin_app/src/application/common/app_init_cubit.dart';
import 'package:myotwin_app/src/application/theme/theme_cubit.dart';
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
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'MyoTwin',
          debugShowCheckedModeBanner: false,
          theme: MyoTwinThemeDataFactory.build(
            accentHot: themeState.settings.accentColor,
          ),
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
                  }
                  // We don't reset to idle here because the chat panel (MyoCanvas)
                  // manages the idle vs listening state transition based on visibility.
                },
                child: _MyoStartupOrchestrator(
                  fabState: _fabStateNotifier,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Identifiers for the different HUD overlay windows.
enum _OverlayWindow {
  goalExplorer,
  anatomyTargeter,
  themeSettings,
  settingsHud,
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
    with TickerProviderStateMixin, HoloGlitchTickerMixin<_MyoStartupOrchestrator> {
  late final AnimationController _perceivedController;
  bool _readyToTransition = false;

  /// Ordered list of active windows. The last item is at the front of the stack.
  final List<_OverlayWindow> _activeWindows = [];

  final _anatomyResetTrigger = ValueNotifier<int>(0);
  bool _showChat = false;

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

    if (initReady && _perceivedController.value >= 1.0) {
      Timer(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        setState(() {
          _readyToTransition = true;
        });
        triggerGlitch();
      });
    }
  }

  void _bringToFront(_OverlayWindow window) {
    setState(() {
      _activeWindows
        ..remove(window)
        ..add(window);
    });
  }

  void _closeWindow(_OverlayWindow window) {
    setState(() {
      _activeWindows.remove(window);
    });
  }

  Future<void> _handleToolCall(ChatToolCallEvent tool) async {
    if (tool.toolName == 'set_anatomy_layer') {
      final layerName = tool.arguments['layer'] as String?;
      if (layerName != null) {
        context.read<domain.LoggerService>().info('HUD_ORCHESTRATOR: EXECUTING_ANATOMY_CHANGE: $layerName');
        final layer = layerName == 'default'
            ? null
            : domain.AnatomyLayer.values.firstWhere(
                (e) => e.name == layerName,
                orElse: () => domain.AnatomyLayer.muscular,
              );

        // 1. Clear the tool call immediately so we don't trigger again
        if (mounted) {
          context.read<ChatCubit>().clearToolCall();
        }

        // 2. Hide chat first for a clean visual handoff
        if (_showChat) {
          setState(() => _showChat = false);
          // Wait for the animation to complete (matching MyoCanvas 400ms duration)
          await Future<void>.delayed(const Duration(milliseconds: 450));
        }

        // 3. Update AnatomyCubit
        if (mounted) {
          context.read<AnatomyCubit>().setLayer(layer);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppInitCubit, AppInitState>(
      listenWhen: (prev, curr) => prev.isReady != curr.isReady,
      listener: (context, state) {
        if (state.isReady) _checkHandoff();
      },
      child: BlocListener<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state.isTransitioning) {
            triggerGlitch();
          }

          final tool = state.pendingToolCall;
          if (tool != null) {
            context.read<domain.LoggerService>().detail('HUD_ORCHESTRATOR: PENDING_TOOL_CALL: ${tool.toolName}');
            unawaited(_handleToolCall(tool));
          }
        },
        child: HoloGlitch(
          phase: glitchPhase,
          intensity: glitchIntensity,
          severity: 0.2,
          child: Stack(
            children: [
              // THE MAIN HUD
              BlocBuilder<AnatomyCubit, AnatomyState>(
                builder: (context, anatomyState) {
                  return BlocBuilder<ChatCubit, ChatState>(
                    builder: (context, chatState) {
                      return BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, themeState) {
                          return MyoCanvas(
                            key: const ValueKey('myo_canvas'),
                            fabState: widget.fabState,
                            showChat: _showChat,
                            backgroundChild: InteractiveGrid(
                              onLongPress: () {
                                triggerGlitch();
                                unawaited(HapticFeedback.heavyImpact());

                                Timer(const Duration(milliseconds: 150), () {
                                  if (mounted) {
                                    context.read<AnatomyCubit>().setLayer(null);
                                    context.read<AnatomyCubit>().clearHighlights();
                                    _anatomyResetTrigger.value++;
                                  }
                                });
                              },
                              child: MyoAnatomyCanvas(
                                isRenderingEnabled: context.select<AppInitCubit, bool>((c) => c.state.isReady),
                                accentColor: themeState.settings.accentColor,
                                highlightColor: themeState.settings.highlightColor,
                                roughness: themeState.settings.modelRoughness,
                                activeNodes: [
                                  ...chatState.activeGoal?.metadata.targetAnatomyNodes ?? [],
                                  ...anatomyState.activeNodes,
                                ],
                                activeLayer: anatomyState.activeLayer,
                                resetTrigger: _anatomyResetTrigger,
                                onNodesLoaded: (nodes) {
                                  if (anatomyState.availableNodes.isEmpty) {
                                    context.read<AnatomyCubit>().setAvailableNodes(nodes);
                                    context.read<AppInitCubit>().indexAnatomy(nodes).ignore();
                                  }
                                },
                              ),
                            ),
                            chatChild: MyoChatList(messages: chatState.messages),
                            onMessageSubmitted: (value) async {
                              return context.read<ChatCubit>().submit(value);
                            },
                            onShowChatChanged: (visible) {
                              setState(() => _showChat = visible);
                              widget.fabState.value = visible ? HoloState.listening : HoloState.idle;
                            },

                            onCommandSelected: (command) {
                              switch (command) {
                                case domain.QuickCommand.goalExplorer:
                                  _bringToFront(_OverlayWindow.goalExplorer);
                                case domain.QuickCommand.anatomyTargeter:
                                  _bringToFront(_OverlayWindow.anatomyTargeter);
                                case domain.QuickCommand.themeSettings:
                                  _bringToFront(_OverlayWindow.themeSettings);
                                case domain.QuickCommand.settingsHud:
                                  _bringToFront(_OverlayWindow.settingsHud);
                                case QuickCommand.logSymptom:
                                case QuickCommand.revertLadder:
                                case QuickCommand.xrayOverlay:
                                case QuickCommand.bodyHeatmap:
                                case QuickCommand.calibrate:
                                case QuickCommand.unknown:
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),

              // DYNAMIC OVERLAYS
              Positioned.fill(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 120), // Avoid system tray / FAB area
                    child: Stack(
                      children: _activeWindows.map((window) {
                        switch (window) {
                          case _OverlayWindow.goalExplorer:
                            return Positioned.fill(
                              key: const ValueKey('goal_explorer'),
                              child: Listener(
                                behavior: HitTestBehavior.translucent,
                                onPointerDown: (_) => _bringToFront(_OverlayWindow.goalExplorer),
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
                                              _closeWindow(_OverlayWindow.goalExplorer);
                                            },
                                            onClose: () => _closeWindow(_OverlayWindow.goalExplorer),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          case _OverlayWindow.anatomyTargeter:
                            return Positioned(
                              key: const ValueKey('anatomy_targeter'),
                              right: 32,
                              top: 32,
                              bottom: 32,
                              child: Listener(
                                behavior: HitTestBehavior.translucent,
                                onPointerDown: (_) => _bringToFront(_OverlayWindow.anatomyTargeter),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 340),
                                  child: BlocBuilder<AnatomyCubit, AnatomyState>(
                                    builder: (context, state) {
                                      return AnatomyTargetingSurface(
                                        nodesByLayer: state.availableNodes,
                                        activeLayer: state.activeLayer,
                                        selectedNodes: state.activeNodes,
                                        onLayerChanged: (layer) {
                                          context.read<AnatomyCubit>().setLayer(layer);
                                        },
                                        onNodeSelected: (node) {
                                          context.read<AnatomyCubit>().toggleNode(node);
                                        },
                                        onClearSelections: () {
                                          context.read<AnatomyCubit>().clearHighlights();
                                        },
                                        onClose: () => _closeWindow(_OverlayWindow.anatomyTargeter),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          case _OverlayWindow.themeSettings:
                            return Positioned(
                              key: const ValueKey('theme_settings'),
                              right: 32,
                              top: 32,
                              child: Listener(
                                behavior: HitTestBehavior.translucent,
                                onPointerDown: (_) => _bringToFront(_OverlayWindow.themeSettings),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 340),
                                  child: BlocBuilder<ThemeCubit, ThemeState>(
                                    builder: (context, state) {
                                      return ThemeSettingsSurface(
                                        accentColor: state.settings.accentColor,
                                        highlightColor: state.settings.highlightColor,
                                        roughness: state.settings.modelRoughness,
                                        onAccentChanged: (color) => context.read<ThemeCubit>().updateAccentColor(color),
                                        onHighlightChanged: (color) =>
                                            context.read<ThemeCubit>().updateHighlightColor(color),
                                        onRoughnessChanged: (val) => context.read<ThemeCubit>().updateRoughness(val),
                                        onClose: () => _closeWindow(_OverlayWindow.themeSettings),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          case _OverlayWindow.settingsHud:
                            return Positioned.fill(
                              key: const ValueKey('settings_hud'),
                              child: Listener(
                                behavior: HitTestBehavior.translucent,
                                onPointerDown: (_) => _bringToFront(_OverlayWindow.settingsHud),
                                child: Align(
                                  child: SettingsHudSurface(
                                    onCommandSelected: (command) {
                                      _closeWindow(_OverlayWindow.settingsHud);
                                      // Dispatch the selected command back into the app orchestrator
                                      // Most commands just open other windows
                                      switch (command) {
                                        case QuickCommand.goalExplorer:
                                          _bringToFront(_OverlayWindow.goalExplorer);
                                        case QuickCommand.anatomyTargeter:
                                          _bringToFront(_OverlayWindow.anatomyTargeter);
                                        case QuickCommand.themeSettings:
                                          _bringToFront(_OverlayWindow.themeSettings);
                                        case QuickCommand.logSymptom:
                                        case QuickCommand.revertLadder:
                                        case QuickCommand.xrayOverlay:
                                        case QuickCommand.bodyHeatmap:
                                        case QuickCommand.calibrate:
                                        case QuickCommand.settingsHud:
                                        case QuickCommand.unknown:
                                          break;
                                      }
                                    },
                                    onClose: () => _closeWindow(_OverlayWindow.settingsHud),
                                  ),
                                ),
                              ),
                            );
                        }
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // THE BOOT SCREEN
              if (!_readyToTransition)
                Positioned.fill(
                  child: BlocBuilder<AppInitCubit, AppInitState>(
                    builder: (context, state) {
                      final scanProgress = _perceivedController.value;
                      final progress = state.isReady ? scanProgress : (scanProgress * 0.9).clamp(0.0, 1.0);

                      return BootScreen(
                        progress: progress,
                        status: state.status,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
