import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// Core glitch state logic.
/// Use this when you need the glitch variables but are managing your own ticker.
mixin HoloGlitchLogicMixin<T extends StatefulWidget> on State<T> {
  double _glitchPhase = 0.0;
  double _glitchIntensity = 0.0;

  /// Current noise seed phase used by [HoloGlitch].
  double get glitchPhase => _glitchPhase;

  /// Current glitch magnitude (0.0 to 1.0).
  double get glitchIntensity => _glitchIntensity;

  /// Triggers a glitch spike to 1.0.
  void triggerGlitch() {
    setState(() {
      _glitchIntensity = 1.0;
    });
  }

  /// The logic to update glitch state. Should be called by a Ticker.
  void updateGlitchState(double dt) {
    // Decay glitch intensity
    if (_glitchIntensity > 0.0) {
      _glitchIntensity = math.max(0.0, _glitchIntensity - (dt * 3.0));
    }

    // Update phase
    _glitchPhase += dt * 0.5;
    _glitchPhase %= 1.0;
  }
}

/// Lifecycle-managed glitch logic.
///
/// This mixin automates the Ticker setup and cleanup.
/// It REQUIRES the state class to also use [SingleTickerProviderStateMixin]
/// or [TickerProviderStateMixin].
mixin HoloGlitchTickerMixin<T extends StatefulWidget> on State<T> {
  Ticker? _glitchTicker;
  Duration _lastGlitchTime = .zero;

  // We duplicate the state and methods here to ensure HoloGlitchTickerMixin
  // is a complete, self-contained package for the most common use case.
  double _glitchPhase = 0.0;
  double _glitchIntensity = 0.0;

  /// Current noise seed phase used by [HoloGlitch].
  double get glitchPhase => _glitchPhase;

  /// Current glitch magnitude (0.0 to 1.0).
  double get glitchIntensity => _glitchIntensity;

  /// Triggers a glitch spike to 1.0.
  void triggerGlitch() {
    setState(() {
      _glitchIntensity = 1.0;
    });
  }

  /// The logic to update glitch state. Should be called by a Ticker.
  void updateGlitchState(double dt) {
    if (_glitchIntensity > 0.0) {
      _glitchIntensity = math.max(0.0, _glitchIntensity - (dt * 3.0));
    }
    _glitchPhase += dt * 0.5;
    _glitchPhase %= 1.0;
  }

  @override
  void initState() {
    super.initState();
    _setupGlitchTicker();
  }

  void _setupGlitchTicker() {
    try {
      final provider = this as TickerProvider;
      _glitchTicker = provider.createTicker(_onGlitchTick)..start().ignore();
    } catch (e) {
      debugPrint(
        'HoloGlitchTickerMixin: State class must use SingleTickerProviderStateMixin or TickerProviderStateMixin',
      );
    }
  }

  void _onGlitchTick(Duration elapsed) {
    if (_lastGlitchTime == .zero) {
      _lastGlitchTime = elapsed;
      return;
    }

    final dt = (elapsed - _lastGlitchTime).inMicroseconds / 1000000.0;
    _lastGlitchTime = elapsed;

    updateGlitchState(dt);
    setState(() {});
  }

  @override
  void dispose() {
    _glitchTicker?.dispose();
    super.dispose();
  }
}
