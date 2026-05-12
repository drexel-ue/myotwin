import 'package:flutter/material.dart';

/// A centralized theme implementation for MyoTwin, following the Cyberpunk/HUD design system.
class MyoTwinTheme {
  // Private constructor to prevent instantiation
  MyoTwinTheme._();

  // --- Palette ---

  /// Primary background color for the application.
  static const Color surface = Color(0xFF0A0A0A);

  /// Background color for cards and bottom sheets.
  static const Color surfaceElevated = Color(0xFF111111);

  /// Background color for secondary elevated surfaces.
  static const Color surfaceElevated2 = Color(0xFF1A1A1A);

  /// Background color for tertiary elevated surfaces.
  static const Color surfaceElevated3 = Color(0xFF222222);

  /// Primary color for borders, dividers, and inactive strokes.
  static const Color outline = Color(0xFF2A2A2A);

  /// Dimmed color for disabled borders and subtle separators.
  static const Color outlineDim = Color(0xFF1F1F1F);

  /// Color for inner shadows and pressed states.
  static const Color inset = Color(0xFF000000);

  /// Primary text and icon color on surfaces.
  static const Color onSurface = Color(0xFFE0E0E0);

  /// Secondary text and disabled element color.
  static const Color onSurfaceMedium = Color(0xFF999999);

  /// Tertiary text and placeholder color.
  static const Color onSurfaceDim = Color(0xFF666666);

  /// Pure white accent for HUD highlights.
  static const Color white = Color(0xFFFFFFFF);

  /// Pure black for clipping and glitch effects.
  static const Color black = Color(0xFF000000);

  // --- Data Accents ---

  /// Primary action fill and FAB active state.
  static const Color accent = Color(0xFFA0A0A0);

  /// FAB hot state and focus ring.
  static const Color accentHot = Color(0xFFC8C8C8);

  /// Low intensity heatmap color (teal-gray).
  static const Color heatLow = Color(0xFF556060);

  /// Medium intensity heatmap color.
  static const Color heatMed = Color(0xFF4A5A4A);

  /// High intensity heatmap color.
  static const Color heatHigh = Color(0xFF604030);

  /// Critical/Error intensity heatmap color.
  static const Color heatCritical = Color(0xFF703030);

  /// Color for uncertain kinetic chains.
  static const Color linkFaint = Color(0xFF3A5A4A);

  /// Color for proven kinetic chains.
  static const Color linkStrong = Color(0xFF6A8A7A);

  /// Color for positive feedback and success states.
  static const Color success = Color(0xFF607060);

  /// Color for error states and critical warnings.
  static const Color error = Color(0xFF803030);

  // --- Shape ---

  /// No border radius (sharp edges).
  static const double radiusNone = 0.0;

  /// Small border radius for buttons and FABs.
  static const double radiusSm = 4.0;

  /// Medium border radius for cards and sheets.
  static const double radiusMd = 8.0;

  /// Large border radius for dialogs and chat bubbles.
  static const double radiusLg = 16.0;

  /// Infinite border radius for circular elements.
  static const double radiusFull = 999.0;

  /// Creates a [ThemeData] instance based on the MyoTwin Design System.
  /// 
  /// This theme is dark-only and optimized for the Cyberpunk/HUD aesthetic.
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: surface,
      cardColor: surfaceElevated,
      dividerColor: outline,
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: onSurface, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: onSurface, fontSize: 16),
        bodyMedium: TextStyle(color: onSurfaceMedium, fontSize: 14),
        labelSmall: TextStyle(color: onSurfaceDim, fontSize: 11),
      ),
      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: surfaceElevated,
          foregroundColor: onSurface,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radiusSm)),
          ),
        ),
      ),
    );
  }
}
