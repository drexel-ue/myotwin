import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:myotwin_ui/src/theme/icon_registry.dart';

/// An AI-native icon widget that dynamically resolves a semantic [intent] into
/// an SVG asset at runtime.
///
/// If the intent cannot be resolved, it falls back to a
/// "Corrupted Sector" hardware glitch.
class MyoIcon extends StatefulWidget {
  /// Creates a [MyoIcon] that resolves an [intent] to a visual asset.
  const MyoIcon({
    super.key,
    required this.intent,
    this.fallbackIntent,
    this.color,
    this.size = spacing24,
  });

  /// The primary semantic concept requested by the AI (e.g., 'biometric scan').
  final String intent;

  /// A safer, more generic backup concept (e.g., 'fingerprint').
  final String? fallbackIntent;

  /// The color to tint the SVG. Defaults to the theme's white.
  final Color? color;

  /// The square dimensions of the icon.
  final double size;

  @override
  State<MyoIcon> createState() => _MyoIconState();
}

class _MyoIconState extends State<MyoIcon> with SingleTickerProviderStateMixin, HoloGlitchLogicMixin {
  Ticker? _ticker;
  String? _resolvedPath;
  Duration _lastElapsed = .zero;

  @override
  void initState() {
    super.initState();
    _resolveIcon();
  }

  @override
  void didUpdateWidget(covariant MyoIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.intent != widget.intent || oldWidget.fallbackIntent != widget.fallbackIntent) {
      _resolveIcon();
    }
  }

  void _resolveIcon() {
    _resolvedPath =
        IconRegistry.findBestMatch(widget.intent) ??
        (widget.fallbackIntent != null ? IconRegistry.findBestMatch(widget.fallbackIntent!) : null);

    if (_resolvedPath == null) {
      _startTicker();
    } else {
      _stopTicker();
    }
  }

  void _startTicker() {
    if (_ticker != null && _ticker!.isActive) return;
    _ticker = createTicker(_onTick)..start().ignore();
  }

  void _stopTicker() {
    _ticker?.stop();
    _ticker = null;
    _lastElapsed = .zero;
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;

    updateGlitchState(dt);
    setState(() {});
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;
    final iconColor = widget.color ?? theme.white;

    if (_resolvedPath != null) {
      // THE HAPPY PATH: Successfully resolved intent to an SVG
      return SvgPicture.asset(
        _resolvedPath!,
        package: 'myotwin_ui',
        width: widget.size,
        height: widget.size,
        colorFilter: .mode(iconColor, .srcIn),
      );
    }

    // THE CORRUPTED PATH: Missing Data Hardware Glitch
    return HoloGlitch(
      phase: glitchPhase,
      intensity: 0.6, // Constant, moderate glitch
      severity: 0.4, // Low severity (micro-tears, no massive horizontal shifts)
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: theme.error.withValues(alpha: 0.1),
          border: .all(
            color: theme.error.withValues(alpha: 0.8),
            width: 1.0,
          ),
          borderRadius: theme.radiusSm,
        ),
        child: Center(
          child: Text(
            'Ø', // The null/empty set symbol
            style: TextStyle(
              color: theme.error,
              fontSize: widget.size * 0.6,
              fontWeight: .w900,
              fontFamily: 'monospace',
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
