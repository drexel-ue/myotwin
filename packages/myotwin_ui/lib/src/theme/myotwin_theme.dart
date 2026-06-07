import 'package:flutter/material.dart';

/// Context extension providing shortcut access to the [MyoTwinTheme]
/// HUD design tokens stored in the current [ThemeData].
///
/// Usage:
/// ```dart
/// final t = context.myoTheme;
/// print(t.surface);         // 0xFF0A0A0A
/// print(t.terminal.fontFamily); // 'JetBrainsMono'
/// print(t.motionGlitch.inMilliseconds); // 120
/// ```
extension MyoTwinThemeBuildContextX on BuildContext {
  /// Retrieves the [MyoTwinTheme] extension from the nearest ancestor
  /// [ThemeData]. Throws if the theme has not been configured with
  /// [MyoTwinThemeDataFactory.build].
  MyoTwinTheme get myoTheme => Theme.of(this).extension<MyoTwinTheme>()!;
}

/// Type-safe, production-ready Flutter [ThemeExtension] that encapsulates
/// the full MyoTwin design specification.
///
/// **Aesthetic**: black-and-white cyberpunk / sci-fi — HUD layout, glitch
/// effects, terminal-inspired typography, holographic transitions.
///
/// **Inspiration**: Deus Ex HUD, Ghost in the Shell holographic displays,
/// Cyberpunk 2077 navigation, CRT terminal interfaces.
///
/// **Core principle**: everything reads like a military or experimental
/// system interface — clean lines, sharp contrast, monochrome depth with
/// deliberate accent colours only for data visualisation (heatmap,
/// error states, warnings).
///
/// Access from any [BuildContext] via `BuildContext.myoTheme`:
/// ```dart
/// final t = context.myoTheme;
/// ```
@immutable
class MyoTwinTheme extends ThemeExtension<MyoTwinTheme> {
  /// Creates a MyoTwin theme extension with a fully specified design token set.
  ///
  /// Every parameter is required because [ThemeExtension] tokens are
  /// expected to be complete — partial themes are considered invalid.
  ///
  /// Use [MyoTwinTheme.dark] for the factory-instanced default profile,
  /// or [copyWith] to selectively override individual tokens.
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

  /// Master factory producing the uncompromised Dark HUD profile.
  ///
  /// Returns a fully populated [MyoTwinTheme] with:
  ///
  /// * **Palette** — dark surface tokens + accent / heat / link colour set
  /// * **Typography** — SpaceMono for UI, JetBrainsMono for terminal / glitch
  /// * **Shape** — five border-radius steps (0 / 4 / 8 / 16 / 999)
  /// * **Motion** — seven duration tiers and four easing curves
  ///
  /// This is the instance injected via [MyoTwinThemeDataFactory.build].
  factory MyoTwinTheme.dark({
    Color accent = const Color(0xFFA0A0A0),
    Color accentHot = const Color(0xFFC8C8C8),
  }) {
    return MyoTwinTheme(
      surface: const Color(0xFF0A0A0A),
      surfaceElevated: const Color(0xFF111111),
      surfaceElevated2: const Color(0xFF1A1A1A),
      surfaceElevated3: const Color(0xFF222222),
      outline: const Color(0xFF2A2A2A),
      outlineDim: const Color(0xFF1F1F1F),
      inset: const Color(0xFF000000),
      onSurface: const Color(0xFFE0E0E0),
      onSurfaceMedium: const Color(0xFF999999),
      onSurfaceDim: const Color(0xFF666666),
      white: const Color(0xFFFFFFFF),
      black: const Color(0xFF000000),
      accent: accent,
      accentHot: accentHot,
      heatLow: const Color(0xFF556060),
      heatMed: const Color(0xFF4A5A4A),
      heatHigh: const Color(0xFF604030),
      heatCritical: const Color(0xFF703030),
      linkFaint: const Color(0xFF3A5A4A),
      linkStrong: const Color(0xFF6A8A7A),
      success: const Color(0xFF607060),
      error: const Color(0xFF803030),

      // Explicit Logical Pixel Letter-Spacing calculation mapping tracking percentages
      displayLarge: const TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 32.0,
        fontWeight: .w700,
        letterSpacing: 32.0 * -0.02,
      ),
      displayMedium: const TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 24.0,
        fontWeight: .w700,
        letterSpacing: 24.0 * -0.01,
      ),
      headlineLarge: const TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 20.0,
        fontWeight: .w600,
        letterSpacing: 20.0 * -0.01,
      ),
      headlineMedium: const TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 16.0,
        fontWeight: .w600,
        letterSpacing: 0.0,
      ),
      title: const TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 14.0,
        fontWeight: .w600,
        letterSpacing: 0.0,
      ),
      bodyLarge: const TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 16.0,
        fontWeight: .w400,
        letterSpacing: 16.0 * -0.01,
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 14.0,
        fontWeight: .w400,
        letterSpacing: 14.0 * -0.01,
      ),
      bodySmall: const TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 12.0,
        fontWeight: .w400,
        letterSpacing: 0.0,
      ),
      caption: const TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 11.0,
        fontWeight: .w400,
        letterSpacing: 0.0,
      ),
      overline: const TextStyle(
        fontFamily: 'SpaceMono',
        fontSize: 10.0,
        fontWeight: .w600,
        letterSpacing: 10.0 * 0.03,
      ),
      terminal: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 14.0,
        fontWeight: .w400,
        letterSpacing: 14.0 * -0.02,
      ),
      glitch: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 14.0,
        fontWeight: .w700,
        letterSpacing: 14.0 * -0.02,
      ),

      radiusNone: .zero,
      radiusSm: const .all(.circular(4.0)),
      radiusMd: const .all(.circular(8.0)),
      radiusLg: const .all(.circular(16.0)),
      radiusFull: const .all(.circular(999.0)),

      motionFast: const Duration(milliseconds: 80),
      motionNormal: const Duration(milliseconds: 250),
      motionSlow: const Duration(milliseconds: 400),
      motionSlower: const Duration(milliseconds: 600),
      motionGlitch: const Duration(milliseconds: 120),
      motionHolographic: const Duration(milliseconds: 500),
      motionFeedback: const Duration(milliseconds: 60),

      curveDecelerate: Curves.decelerate,
      curveEaseOut: Curves.easeOut,
      curveEaseInOut: Curves.easeInOut,
      curveStepEnd: StepsCurve.end,
    );
  }

  // --- Palette & Data Accents ---
  /// Dark background surface (base layer).
  final Color surface;

  /// Dark background surface (elevated one step).
  final Color surfaceElevated;

  /// Dark background surface (elevated two steps).
  final Color surfaceElevated2;

  /// Dark background surface (elevated three steps — highest).
  final Color surfaceElevated3;

  /// Standard border / divider line colour.
  final Color outline;

  /// Dimmed border / divider line colour (subtle separators).
  final Color outlineDim;

  /// Deepest inset shadow colour (pure black).
  final Color inset;

  /// Primary text / icon colour on [surface].
  final Color onSurface;

  /// Secondary text colour on [surface] (medium emphasis).
  final Color onSurfaceMedium;

  /// Tertiary text colour on [surface] (dim / disabled).
  final Color onSurfaceDim;

  /// Pure white alias.
  final Color white;

  /// Pure black alias.
  final Color black;

  /// Default accent / neutral highlight.
  final Color accent;

  /// Brighter accent / hot key for emphasis.
  final Color accentHot;

  /// Low heat indicator (cool tone).
  final Color heatLow;

  /// Medium heat indicator (warm tone).
  final Color heatMed;

  /// High heat indicator (hot orange / amber).
  final Color heatHigh;

  /// Critical heat indicator (danger / error red).
  final Color heatCritical;

  /// Faint hyperlink / reference colour.
  final Color linkFaint;

  /// Strong hyperlink / interactive colour.
  final Color linkStrong;

  /// Success / confirmed state.
  final Color success;

  /// Error / failure state.
  final Color error;

  // --- Typography Tokens ---
  /// Hero numbers — reps, scores, large numerals ([SpaceMono](https://fonts.google.com/specimen/Space+Mono)).
  final TextStyle displayLarge;

  /// Section headers ([SpaceMono](https://fonts.google.com/specimen/Space+Mono)).
  final TextStyle displayMedium;

  /// Dialog titles ([SpaceMono](https://fonts.google.com/specimen/Space+Mono)).
  final TextStyle headlineLarge;

  /// Card titles ([SpaceMono](https://fonts.google.com/specimen/Space+Mono)).
  final TextStyle headlineMedium;

  /// Tab labels ([SpaceMono](https://fonts.google.com/specimen/Space+Mono)).
  final TextStyle title;

  /// Chat messages, long-form text ([SpaceMono](https://fonts.google.com/specimen/Space+Mono)).
  final TextStyle bodyLarge;

  /// Descriptions, secondary body text ([SpaceMono](https://fonts.google.com/specimen/Space+Mono)).
  final TextStyle bodyMedium;

  /// Metadata, timestamps ([SpaceMono](https://fonts.google.com/specimen/Space+Mono)).
  final TextStyle bodySmall;

  /// Labels, tags ([SpaceMono](https://fonts.google.com/specimen/Space+Mono)).
  final TextStyle caption;

  /// Section separators (uppercase) ([SpaceMono](https://fonts.google.com/specimen/Space+Mono)).
  final TextStyle overline;

  /// Agent responses, code blocks ([JetBrains Mono](https://fonts.google.com/specimen/JetBrains+Mono)).
  final TextStyle terminal;

  /// System warnings, boot screens ([JetBrains Mono](https://fonts.google.com/specimen/JetBrains+Mono)).
  final TextStyle glitch;

  // --- Shape & Elevation ---
  /// No rounding — sharp corners. Used for body map segments, HUD panels.
  final BorderRadius radiusNone;

  /// Small radius (4 px). Used for FAB rest state, small buttons.
  final BorderRadius radiusSm;

  /// Medium radius (8 px). Used for elevated cards, bottom sheet grabber.
  final BorderRadius radiusMd;

  /// Large radius (16 px). Used for dialogs, chat bubbles (agent messages).
  final BorderRadius radiusLg;

  /// Fully rounded. Used for FAB active / hot state (caps, pills).
  final BorderRadius radiusFull;

  // --- Motion & Duration Tokens ---
  /// Fast transition (80 ms). Used for checkbox toggles, icon state changes.
  final Duration motionFast;

  /// Normal transition (250 ms). Used for FAB morph on hover.
  final Duration motionNormal;

  /// Slow transition (400 ms). Used for bottom sheet slide up.
  final Duration motionSlow;

  /// Slower transition (600 ms). Used for hot / cold FAB state change.
  final Duration motionSlower;

  /// Glitch transition (120 ms). Used for window open/close, boot screens.
  final Duration motionGlitch;

  /// Holographic transition (500 ms). Used for scene transitions (scan-in effect).
  final Duration motionHolographic;

  /// Feedback pulse (60 ms). Used for haptic response animation.
  final Duration motionFeedback;

  /// Deceleration curve. Used paired with [motionFast] / [motionSlower].
  final Curve curveDecelerate;

  /// Ease-out curve. Used paired with [motionNormal] / [motionHolographic].
  final Curve curveEaseOut;

  /// Ease-in-out curve. Used paired with [motionSlow].
  final Curve curveEaseInOut;

  /// Step (discrete) curve. Used paired with [motionGlitch] for scan-line reveal.
  final Curve curveStepEnd;

  /// Returns a copy of this theme with some tokens replaced.
  ///
  /// Every parameter is nullable — pass `null` to keep the current
  /// value, or pass a new value to override it.
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

  /// Linearly interpolate between two [MyoTwinTheme] instances.
  ///
  /// Colours and [TextStyle] values are interpolated with [.lerp].
  /// Durations and curves use a step function (50 % midpoint) because
  /// easing curves don't interpolate linearly.
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

/// A parameterised step curve producing n discrete levels over [0, 1].
///
/// Useful for glitch or quantised animations where a smooth curve
/// would look out of place.
///
/// Example — a 3-step curve divides [0, 1] into three flat plateaux:
/// `[0, 1/3)` → 0, mid → 1/3, `[2/3, 1]` → 2/3.
class StepsCurve extends Curve {
  /// Creates a step curve with [steps] discrete levels (default `1`).
  const StepsCurve({this.steps = 1});

  /// A pre-configured single-step instance (identical to [Curves.linear]).
  static const Curve end = StepsCurve();

  /// Number of discrete steps the curve divides `t ∈ [0, 1]` into.
  final int steps;

  @override
  double transformInternal(double t) {
    return (t * steps).floor() / steps;
  }
}

/// Produces a [ThemeData] pre-wired with MyoTwin design tokens.
///
/// Calls [MyoTwinTheme.dark] to get the token set and injects it as a
/// [ThemeExtension] alongside standard Material dark properties:
///
/// * [ThemeData.brightness] → `.dark`
/// * [ThemeData.scaffoldBackgroundColor] → [MyoTwinTheme.surface]
/// * [ThemeData.dividerColor] → [MyoTwinTheme.outline]
/// * [ThemeData.extensions] → the [MyoTwinTheme] extension
class MyoTwinThemeDataFactory {
  /// Builds a [ThemeData] ready to use in [MaterialApp.theme].
  static ThemeData build({Color? accent, Color? accentHot}) {
    final extensions = MyoTwinTheme.dark(
      accent: accent ?? const Color(0xFFA0A0A0),
      accentHot: accentHot ?? const Color(0xFFC8C8C8),
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: extensions.surface,
      dividerColor: extensions.outline,
      extensions: [extensions],
      colorScheme: ColorScheme.dark(
        surface: extensions.surface,
        error: extensions.error,
        onSurface: extensions.onSurface,
        primary: extensions.accent,
        secondary: extensions.accentHot,
      ),
    );
  }
}
