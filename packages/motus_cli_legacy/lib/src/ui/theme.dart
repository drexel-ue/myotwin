import 'package:dartatui/dartatui.dart';

final motusTheme = ThemeData(
  textColor: Color.rgb,
  surfaceColor: Color.rgb,
  textStyle: Style(
    fg: Color.rgb,
    fgRgb: RgbColor(224, 224, 224), // 0xFFE0E0E0 onSurface
    bg: Color.rgb,
    bgRgb: RgbColor(10, 10, 10),    // 0xFF0A0A0A surface
  ),
  borderStyle: Style(
    fg: Color.rgb,
    fgRgb: RgbColor(42, 42, 42),    // 0xFF2A2A2A outline
    bg: Color.rgb,
    bgRgb: RgbColor(10, 10, 10),
  ),
  focusedBorderStyle: Style(
    fg: Color.rgb,
    fgRgb: RgbColor(200, 200, 200), // 0xFFC8C8C8 accentHot
    bg: Color.rgb,
    bgRgb: RgbColor(17, 17, 17),    // 0xFF111111 surfaceElevated
    addModifier: Modifier.bold,
  ),
  headingStyle: Style(
    fg: Color.rgb,
    fgRgb: RgbColor(255, 255, 255),
    addModifier: Modifier.bold,
  ),
);
