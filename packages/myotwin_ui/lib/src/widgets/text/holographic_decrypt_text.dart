import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myotwin_ui/src/theme/myotwin_theme.dart';

/// A mechatronic text widget that reveals its [text] left-to-right by rapidly
/// cycling through a pool of scrambled characters.
class HolographicDecryptText extends StatefulWidget {
  /// A mechatronic text widget that decrypts [text] left-to-right by
  /// rapidly cycling through a pool of scrambled characters.
  ///
  /// The [duration] controls how long the full decryption animation takes.
  /// The [playheadColor] draws an animated cursor at the reveal boundary.
  const HolographicDecryptText(
    this.text, {
    super.key,
    this.style,
    this.duration = const Duration(milliseconds: 1200),
    this.playheadColor,
    this.encryptedOpacity = 0.4,
    // A mix of technical symbols, numbers, and hard angles for a raw hardware feel
    this.obfuscationPool = r'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!<>-_\/[]{}—=+*^?#',
  });

  /// The final, decrypted string.
  final String text;

  /// The base text style for the resolved characters.
  final TextStyle? style;

  /// How long the total decryption sequence should take.
  final Duration duration;

  /// The color of the single character currently being "cracked" at the leading edge.
  final Color? playheadColor;

  /// How dim the unresolved, encrypted tail should be.
  final double encryptedOpacity;

  /// The pool of characters the engine will randomly pull from.
  final String obfuscationPool;

  @override
  State<HolographicDecryptText> createState() => _HolographicDecryptTextState();
}

class _HolographicDecryptTextState extends State<HolographicDecryptText> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _lastScrambleTime = Duration.zero;

  double _progress = 0.0;
  String _currentScramble = '';
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _currentScramble = _generateScrambleString(widget.text.length);
    _ticker = createTicker(_onTick)..start().ignore();
  }

  @override
  void didUpdateWidget(covariant HolographicDecryptText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent passes down a new string, restart the decryption sequence automatically
    if (oldWidget.text != widget.text) {
      _progress = 0.0;
      _currentScramble = _generateScrambleString(widget.text.length);
      _ticker.start().ignore();
    }
  }

  void _onTick(Duration elapsed) {
    // 1. Calculate how far along the overall timeline we are
    _progress = elapsed.inMilliseconds / widget.duration.inMilliseconds;

    // Stop the engine when fully resolved to save GPU/CPU cycles
    if (_progress >= 1.0) {
      _progress = 1.0;
      _ticker.stop();
      setState(() {});
      return;
    }

    // 2. Throttle the scramble framerate.
    // If we scramble at 120fps, it looks like a gray blur.
    // Updating the random characters every 40ms (~25fps) gives it a chunky, tactile feel.
    if (elapsed - _lastScrambleTime > const Duration(milliseconds: 40)) {
      _currentScramble = _generateScrambleString(widget.text.length);
      _lastScrambleTime = elapsed;
    }

    setState(() {});
  }

  /// Generates a random string of characters matching the target length,
  /// preserving spaces so the shape of the words is readable immediately.
  String _generateScrambleString(int length) {
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      if (widget.text[i] == ' ') {
        buffer.write(' ');
      } else {
        final randomChar = widget.obfuscationPool[_random.nextInt(widget.obfuscationPool.length)];
        buffer.write(randomChar);
      }
    }
    return buffer.toString();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine how many characters are mathematically "locked in" based on progress
    final lockIndex = (_progress * widget.text.length).floor();

    // Split the rendering into three distinct visual phases
    final resolvedText = widget.text.substring(0, lockIndex);

    // The playhead is the exact character currently being evaluated
    final playheadChar = lockIndex < widget.text.length ? _currentScramble[lockIndex] : '';

    // The tail is the remaining encrypted string
    final unresolvedText = lockIndex + 1 < widget.text.length ? _currentScramble.substring(lockIndex + 1) : '';

    return RichText(
      text: TextSpan(
        style: widget.style,
        children: [
          // Phase 1: Solid, resolved data
          TextSpan(text: resolvedText),

          // Phase 2: The cracking playhead (bright/accented)
          TextSpan(
            text: playheadChar,
            style: context.myoTheme.terminal.copyWith(
              color: widget.playheadColor,
              // Optional: Add a slight glow to the playhead for extra pop
              shadows: [
                Shadow(
                  color: (widget.playheadColor ?? context.myoTheme.white).withValues(alpha: 0.8),
                  blurRadius: 8.0,
                ),
              ],
            ),
          ),

          // Phase 3: The encrypted data stream (dimmed)
          TextSpan(
            text: unresolvedText,
            style: context.myoTheme.terminal.copyWith(
              color: context.myoTheme.terminal.color?.withValues(alpha: widget.encryptedOpacity),
            ),
          ),
        ],
      ),
    );
  }
}
