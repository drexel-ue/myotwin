// ignore_for_file: public_member_api_docs theme stuff.

import 'package:flutter/material.dart';

/// Context extension helper for seamless access to the experimental HUD design tokens.
extension MyoTwinThemeBuildContextX on BuildContext {
  MyoTwinTheme get myoTheme => Theme.of(this).extension<MyoTwinTheme>()!;
}

/// A type-safe, production-ready Flutter [ThemeExtension] capturing the
/// full mechatronic, high-contrast, dark-only MyoTwin design specification.
@immutable
class MyoTwinTheme extends ThemeExtension<MyoTwinTheme> {
  const MyoTwinTheme({
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceElevated2,
    required this.surfaceElevated3,
    required this.outline,
    required this.outlineDim,
    required this.inset,
    required this.onSurface,
    required this.onSurfaceMedium,
    required this.onSurfaceDim,
    required this.white,
    required this.black,
    required this.accent,
    required this.accentHot,
    required this.heatLow,
    required this.heatMed,
    required this.heatHigh,
    required this.heatCritical,
    required this.linkFaint,
    required this.linkStrong,
    required this.success,
    required this.error,
    required this.displayLarge,
    required this.displayMedium,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.title,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.caption,
    required this.overline,
    required this.terminal,
    required this.glitch,
    required this.radiusNone,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusFull,
    required this.motionFast,
    required this.motionNormal,
    required this.motionSlow,
    required this.motionSlower,
    required this.motionGlitch,
    required this.motionHolographic,
    required this.motionFeedback,
    required this.curveDecelerate,
    required this.curveEaseOut,
    required this.curveEaseInOut,
    required this.curveStepEnd,
  });

  /// Master Factory configuration generating the uncompromised Dark HUD profile.
  factory MyoTwinTheme.dark() {
    return const MyoTwinTheme(
      surface: Color(0xFF0A0A0A),
      surfaceElevated: Color(0xFF111111),
      surfaceElevated2: Color(0xFF1A1A1A),
      surfaceElevated3: Color(0xFF222222),
      outline: Color(0xFF2A2A2A),
      outlineDim: Color(0xFF1F1F1F),
      inset: Color(0xFF000000),
      onSurface: Color(0xFFE0E0E0),
      onSurfaceMedium: Color(0xFF999999),
      onSurfaceDim: Color(0xFF666666),
      white: Color(0xFFFFFFFF),
      black: Color(0xFF000000),
      accent: Color(0xFFA0A0A0),
      accentHot: Color(0xFFC8C8C8),
      heatLow: Color(0xFF556060),
      heatMed: Color(0xFF4A5A4A),
      heatHigh: Color(0xFF604030),
      heatCritical: Color(0xFF703030),
      linkFaint: Color(0xFF3A5A4A),
      linkStrong: Color(0xFF6A8A7A),
      success: Color(0xFF607060),
      error: Color(0xFF803030),

      // Explicit Logical Pixel Letter-Spacing calculation mapping tracking percentages
      displayLarge: TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 32.0,
        fontWeight: .w700,
        letterSpacing: 32.0 * -0.02,
      ),
      displayMedium: TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 24.0,
        fontWeight: .w700,
        letterSpacing: 24.0 * -0.01,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 20.0,
        fontWeight: .w600,
        letterSpacing: 20.0 * -0.01,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 16.0,
        fontWeight: .w600,
        letterSpacing: 0.0,
      ),
      title: TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 14.0,
        fontWeight: .w600,
        letterSpacing: 0.0,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 16.0,
        fontWeight: .w400,
        letterSpacing: 16.0 * -0.01,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 14.0,
        fontWeight: .w400,
        letterSpacing: 14.0 * -0.01,
      ),
      bodySmall: TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 12.0,
        fontWeight: .w400,
        letterSpacing: 0.0,
      ),
      caption: TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 11.0,
        fontWeight: .w400,
        letterSpacing: 0.0,
      ),
      overline: TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 10.0,
        fontWeight: .w600,
        letterSpacing: 10.0 * 0.03,
      ),
      terminal: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 14.0,
        fontWeight: .w400,
        letterSpacing: 14.0 * -0.02,
      ),
      glitch: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 14.0,
        fontWeight: .w700,
        letterSpacing: 14.0 * -0.02,
      ),

      radiusNone: .zero,
      radiusSm: .all(.circular(4.0)),
      radiusMd: .all(.circular(8.0)),
      radiusLg: .all(.circular(16.0)),
      radiusFull: .all(.circular(999.0)),

      motionFast: Duration(milliseconds: 80),
      motionNormal: Duration(milliseconds: 250),
      motionSlow: Duration(milliseconds: 400),
      motionSlower: Duration(milliseconds: 600),
      motionGlitch: Duration(milliseconds: 120),
      motionHolographic: Duration(milliseconds: 500),
      motionFeedback: Duration(milliseconds: 60),

      curveDecelerate: Curves.decelerate,
      curveEaseOut: Curves.easeOut,
      curveEaseInOut: Curves.easeInOut,
      curveStepEnd: StepsCurve.end,
    );
  }

  // --- Palette & Data Accents ---
  final Color surface;
  final Color surfaceElevated;
  final Color surfaceElevated2;
  final Color surfaceElevated3;
  final Color outline;
  final Color outlineDim;
  final Color inset;
  final Color onSurface;
  final Color onSurfaceMedium;
  final Color onSurfaceDim;
  final Color white;
  final Color black;
  final Color accent;
  final Color accentHot;
  final Color heatLow;
  final Color heatMed;
  final Color heatHigh;
  final Color heatCritical;
  final Color linkFaint;
  final Color linkStrong;
  final Color success;
  final Color error;

  // --- Typography Tokens ---
  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle title;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle caption;
  final TextStyle overline;
  final TextStyle terminal;
  final TextStyle glitch;

  // --- Shape Radii Tokens ---
  final BorderRadius radiusNone;
  final BorderRadius radiusSm;
  final BorderRadius radiusMd;
  final BorderRadius radiusLg;
  final BorderRadius radiusFull;

  // --- Motion & Duration Tokens ---
  final Duration motionFast;
  final Duration motionNormal;
  final Duration motionSlow;
  final Duration motionSlower;
  final Duration motionGlitch;
  final Duration motionHolographic;
  final Duration motionFeedback;

  final Curve curveDecelerate;
  final Curve curveEaseOut;
  final Curve curveEaseInOut;
  final Curve curveStepEnd;

  @override
  MyoTwinTheme copyWith({
    Color? surface,
    Color? surfaceElevated,
    Color? surfaceElevated2,
    Color? surfaceElevated3,
    Color? outline,
    Color? outlineDim,
    Color? inset,
    Color? onSurface,
    Color? onSurfaceMedium,
    Color? onSurfaceDim,
    Color? white,
    Color? black,
    Color? accent,
    Color? accentHot,
    Color? heatLow,
    Color? heatMed,
    Color? heatHigh,
    Color? heatCritical,
    Color? linkFaint,
    Color? linkStrong,
    Color? success,
    Color? error,
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? title,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? caption,
    TextStyle? overline,
    TextStyle? terminal,
    TextStyle? glitch,
    BorderRadius? radiusNone,
    BorderRadius? radiusSm,
    BorderRadius? radiusMd,
    BorderRadius? radiusLg,
    BorderRadius? radiusFull,
    Duration? motionFast,
    Duration? motionNormal,
    Duration? motionSlow,
    Duration? motionSlower,
    Duration? motionGlitch,
    Duration? motionHolographic,
    Duration? motionFeedback,
    Curve? curveDecelerate,
    Curve? curveEaseOut,
    Curve? curveEaseInOut,
    Curve? curveStepEnd,
  }) {
    return MyoTwinTheme(
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceElevated2: surfaceElevated2 ?? this.surfaceElevated2,
      surfaceElevated3: surfaceElevated3 ?? this.surfaceElevated3,
      outline: outline ?? this.outline,
      outlineDim: outlineDim ?? this.outlineDim,
      inset: inset ?? this.inset,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceMedium: onSurfaceMedium ?? this.onSurfaceMedium,
      onSurfaceDim: onSurfaceDim ?? this.onSurfaceDim,
      white: white ?? this.white,
      black: black ?? this.black,
      accent: accent ?? this.accent,
      accentHot: accentHot ?? this.accentHot,
      heatLow: heatLow ?? this.heatLow,
      heatMed: heatMed ?? this.heatMed,
      heatHigh: heatHigh ?? this.heatHigh,
      heatCritical: heatCritical ?? this.heatCritical,
      linkFaint: linkFaint ?? this.linkFaint,
      linkStrong: linkStrong ?? this.linkStrong,
      success: success ?? this.success,
      error: error ?? this.error,
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      headlineLarge: headlineLarge ?? this.headlineLarge,
      headlineMedium: headlineMedium ?? this.headlineMedium,
      title: title ?? this.title,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      caption: caption ?? this.caption,
      overline: overline ?? this.overline,
      terminal: terminal ?? this.terminal,
      glitch: glitch ?? this.glitch,
      radiusNone: radiusNone ?? this.radiusNone,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusFull: radiusFull ?? this.radiusFull,
      motionFast: motionFast ?? this.motionFast,
      motionNormal: motionNormal ?? this.motionNormal,
      motionSlow: motionSlow ?? this.motionSlow,
      motionSlower: motionSlower ?? this.motionSlower,
      motionGlitch: motionGlitch ?? this.motionGlitch,
      motionHolographic: motionHolographic ?? this.motionHolographic,
      motionFeedback: motionFeedback ?? this.motionFeedback,
      curveDecelerate: curveDecelerate ?? this.curveDecelerate,
      curveEaseOut: curveEaseOut ?? this.curveEaseOut,
      curveEaseInOut: curveEaseInOut ?? this.curveEaseInOut,
      curveStepEnd: curveStepEnd ?? this.curveStepEnd,
    );
  }

  @override
  MyoTwinTheme lerp(ThemeExtension<MyoTwinTheme>? other, double t) {
    if (other is! MyoTwinTheme) return this;
    return MyoTwinTheme(
      surface: .lerp(surface, other.surface, t)!,
      surfaceElevated: .lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceElevated2: .lerp(surfaceElevated2, other.surfaceElevated2, t)!,
      surfaceElevated3: .lerp(surfaceElevated3, other.surfaceElevated3, t)!,
      outline: .lerp(outline, other.outline, t)!,
      outlineDim: .lerp(outlineDim, other.outlineDim, t)!,
      inset: .lerp(inset, other.inset, t)!,
      onSurface: .lerp(onSurface, other.onSurface, t)!,
      onSurfaceMedium: .lerp(onSurfaceMedium, other.onSurfaceMedium, t)!,
      onSurfaceDim: .lerp(onSurfaceDim, other.onSurfaceDim, t)!,
      white: .lerp(white, other.white, t)!,
      black: .lerp(black, other.black, t)!,
      accent: .lerp(accent, other.accent, t)!,
      accentHot: .lerp(accentHot, other.accentHot, t)!,
      heatLow: .lerp(heatLow, other.heatLow, t)!,
      heatMed: .lerp(heatMed, other.heatMed, t)!,
      heatHigh: .lerp(heatHigh, other.heatHigh, t)!,
      heatCritical: .lerp(heatCritical, other.heatCritical, t)!,
      linkFaint: .lerp(linkFaint, other.linkFaint, t)!,
      linkStrong: .lerp(linkStrong, other.linkStrong, t)!,
      success: .lerp(success, other.success, t)!,
      error: .lerp(error, other.error, t)!,
      displayLarge: .lerp(displayLarge, other.displayLarge, t)!,
      displayMedium: .lerp(displayMedium, other.displayMedium, t)!,
      headlineLarge: .lerp(headlineLarge, other.headlineLarge, t)!,
      headlineMedium: .lerp(headlineMedium, other.headlineMedium, t)!,
      title: .lerp(title, other.title, t)!,
      bodyLarge: .lerp(bodyLarge, other.bodyLarge, t)!,
      bodyMedium: .lerp(bodyMedium, other.bodyMedium, t)!,
      bodySmall: .lerp(bodySmall, other.bodySmall, t)!,
      caption: .lerp(caption, other.caption, t)!,
      overline: .lerp(overline, other.overline, t)!,
      terminal: .lerp(terminal, other.terminal, t)!,
      glitch: .lerp(glitch, other.glitch, t)!,
      radiusNone: .lerp(radiusNone, other.radiusNone, t)!,
      radiusSm: .lerp(radiusSm, other.radiusSm, t)!,
      radiusMd: .lerp(radiusMd, other.radiusMd, t)!,
      radiusLg: .lerp(radiusLg, other.radiusLg, t)!,
      radiusFull: .lerp(radiusFull, other.radiusFull, t)!,

      // Step functions for non-linear durations/curves
      motionFast: t < 0.5 ? motionFast : other.motionFast,
      motionNormal: t < 0.5 ? motionNormal : other.motionNormal,
      motionSlow: t < 0.5 ? motionSlow : other.motionSlow,
      motionSlower: t < 0.5 ? motionSlower : other.motionSlower,
      motionGlitch: t < 0.5 ? motionGlitch : other.motionGlitch,
      motionHolographic: t < 0.5 ? motionHolographic : other.motionHolographic,
      motionFeedback: t < 0.5 ? motionFeedback : other.motionFeedback,
      curveDecelerate: t < 0.5 ? curveDecelerate : other.curveDecelerate,
      curveEaseOut: t < 0.5 ? curveEaseOut : other.curveEaseOut,
      curveEaseInOut: t < 0.5 ? curveEaseInOut : other.curveEaseInOut,
      curveStepEnd: t < 0.5 ? curveStepEnd : other.curveStepEnd,
    );
  }
}

/// A specialized parameter curve wrapper providing stepped transitions for glitch animations.
class StepsCurve extends Curve {
  const StepsCurve({this.steps = 1});

  static const Curve end = StepsCurve();

  final int steps;

  @override
  double transformInternal(double t) {
    return (t * steps).floor() / steps;
  }
}

/// Static construction utility injecting tokens smoothly into standard material endpoints.
class MyoTwinThemeDataFactory {
  static ThemeData build() {
    final extensions = MyoTwinTheme.dark();

    return ThemeData(
      brightness: .dark,
      scaffoldBackgroundColor: extensions.surface,
      dividerColor: extensions.outline,
      extensions: [extensions],
      colorScheme: .dark(
        surface: extensions.surface,
        error: extensions.error,
        onSurface: extensions.onSurface,
        primary: extensions.accent,
        secondary: extensions.accentHot,
      ),
    );
  }
}
