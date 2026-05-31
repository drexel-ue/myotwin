import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A cyberpunk HUD-style text field with terminal-inspired typography.
///
/// {@template myo_text_field.label}
/// An optional label displayed above the input area.
/// {@endtemplate}
///
/// {@template myo_text_field.hint}
/// Optional hint text shown when the input is empty.
/// {@endtemplate}
class MyoTextField extends StatefulWidget {
  /// Creates a [MyoTextField].
  const MyoTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly = false,
    this.glitchKey,
  });

  /// The controller for the text being edited.
  final TextEditingController? controller;

  /// {@macro myo_text_field.label}
  final String? label;

  /// {@macro myo_text_field.hint}
  final String? hint;

  /// Whether to obscure the text (e.g., for passwords).
  final bool obscureText;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user indicates they are done editing.
  final ValueChanged<String>? onSubmitted;

  /// Optional icon to display before the text.
  final Widget? prefixIcon;

  /// Optional icon to display after the text.
  final Widget? suffixIcon;

  /// Optional focus node to manage focus.
  final FocusNode? focusNode;

  /// The type of keyboard to use.
  final TextInputType? keyboardType;

  /// The text input action to use.
  final TextInputAction? textInputAction;

  /// The maximum number of lines to display.
  final int? maxLines;

  /// Whether the text field is enabled.
  final bool enabled;

  /// Whether the text field should focus itself on build.
  final bool autofocus;

  /// Whether the text field is read-only.
  final bool readOnly;

  /// An optional key that, when changed, triggers a glitch effect.
  final Object? glitchKey;

  @override
  State<MyoTextField> createState() => _MyoTextFieldState();
}

class _MyoTextFieldState extends State<MyoTextField>
    with SingleTickerProviderStateMixin, HoloGlitchTickerMixin<MyoTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant MyoTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.glitchKey != oldWidget.glitchKey && widget.glitchKey != null) {
      triggerGlitch();
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus != _isFocused) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_isFocused) {
        triggerGlitch();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.caption.copyWith(
              color: widget.enabled
                  ? (_isFocused ? theme.accentHot : theme.onSurfaceMedium)
                  : theme.onSurfaceDim,
              letterSpacing: 0.03,
            ),
          ),
          verticalMargin8,
        ],
        BleedMargin(
          margin: const .symmetric(horizontal: spacing24),
          child: HoloGlitch(
            phase: glitchPhase,
            intensity: glitchIntensity,
            severity: 0.1,
            child: Padding(
              padding: horizontalPadding24,
              child: AnimatedContainer(
                duration: theme.motionFast,
                curve: theme.curveEaseOut,
                decoration: BoxDecoration(
                  color: widget.enabled ? theme.surfaceElevated : theme.surface,
                  borderRadius: theme.radiusSm,
                  border: .all(
                    color: widget.enabled
                        ? (_isFocused ? theme.accentHot : theme.outline)
                        : theme.outlineDim,
                    width: _isFocused ? 1.5 : 1.0,
                  ),
                  boxShadow: _isFocused
                      ? [
                          BoxShadow(
                            color: theme.accentHot.withValues(alpha: 0.1),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  maxLines: widget.maxLines,
                  autofocus: widget.autofocus,
                  readOnly: widget.readOnly,
                  style: theme.bodyMedium.copyWith(
                    color: widget.enabled ? theme.onSurface : theme.onSurfaceDim,
                    fontFamily: 'JetBrainsMono',
                  ),
                  cursorColor: theme.accentHot,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: theme.bodyMedium.copyWith(
                      color: theme.onSurfaceDim,
                      fontFamily: 'JetBrainsMono',
                    ),
                    contentPadding: horizontalPadding12 + verticalPadding12,
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: widget.prefixIcon != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                            child: IconTheme(
                              data: IconThemeData(
                                color: widget.enabled
                                    ? (_isFocused ? theme.accentHot : theme.onSurfaceMedium)
                                    : theme.onSurfaceDim,
                                size: 20,
                              ),
                              child: widget.prefixIcon!,
                            ),
                          )
                        : null,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    suffixIcon: widget.suffixIcon != null
                        ? Padding(
                            padding: const .only(left: 4.0, right: 8.0),
                            child: IconTheme(
                              data: IconThemeData(
                                color: widget.enabled
                                    ? (_isFocused ? theme.accentHot : theme.onSurfaceMedium)
                                    : theme.onSurfaceDim,
                                size: 20,
                              ),
                              child: widget.suffixIcon!,
                            ),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
