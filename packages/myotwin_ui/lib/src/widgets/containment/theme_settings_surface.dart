import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A tactical HUD surface for adjusting the application's visual theme.
///
/// Provides controls for accent colors and 3D material properties.
class ThemeSettingsSurface extends StatelessWidget {
  /// Creates [ThemeSettingsSurface].
  const ThemeSettingsSurface({
    super.key,
    required this.accentColor,
    required this.highlightColor,
    required this.roughness,
    required this.onAccentChanged,
    required this.onHighlightChanged,
    required this.onRoughnessChanged,
    required this.onClose,
  });

  /// The current primary accent color.
  final Color accentColor;

  /// The current anatomical highlight color.
  final Color highlightColor;

  /// The current model roughness (0.0 to 1.0).
  final double roughness;

  /// Called when the accent color is updated.
  final ValueChanged<Color> onAccentChanged;

  /// Called when the highlight color is updated.
  final ValueChanged<Color> onHighlightChanged;

  /// Called when the model roughness is updated.
  final ValueChanged<double> onRoughnessChanged;

  /// Called when the surface is dismissed.
  final VoidCallback onClose;

  static const List<Color> _cyberpunkPalette = [
    Color(0xFF00FFFF), // Cyan
    Color(0xFFFF00FF), // Magenta
    Color(0xFF39FF14), // Neon Green
    Color(0xFFFFB000), // Amber
    Color(0xFFFF3131), // Crimson
    Color(0xFFBC13FE), // Electric Purple
    Color(0xFFFFFFFF), // White
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return FrostedHUD(
      impactPoint: Offset.zero,
      title: 'THEME_CALIBRATION',
      onClose: onClose,
      child: Padding(
        padding: allPadding24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Accent Color
            Text('PRIMARY_ACCENT', style: theme.overline.copyWith(color: theme.accentHot)),
            verticalMargin16,
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _cyberpunkPalette.map((color) {
                final isSelected = accentColor.toARGB32() == color.toARGB32();
                return GestureDetector(
                  onTap: () => onAccentChanged(color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 2.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.5),
                                blurRadius: 8.0,
                                spreadRadius: 1.0,
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            verticalMargin32,

            // 2. Highlight Color
            Text('ANATOMY_HIGHLIGHT', style: theme.overline.copyWith(color: theme.accentHot)),
            verticalMargin16,
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _cyberpunkPalette.map((color) {
                final isSelected = highlightColor.toARGB32() == color.toARGB32();
                return GestureDetector(
                  onTap: () => onHighlightChanged(color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 2.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.5),
                                blurRadius: 8.0,
                                spreadRadius: 1.0,
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            verticalMargin32,

            // 3. Roughness Slider
            Text('MATERIAL_ROUGHNESS', style: theme.overline.copyWith(color: theme.accentHot)),
            verticalMargin8,
            Row(
              children: [
                const MyoIcon(intent: 'activity', size: 16),
                horizontalMargin16,
                Expanded(
                  child: MyoSlider(
                    value: roughness,
                    onChanged: onRoughnessChanged,
                  ),
                ),
                horizontalMargin16,
                SizedBox(
                  width: 40,
                  child: Text(
                    roughness.toStringAsFixed(2),
                    style: theme.terminal.copyWith(fontSize: 10, color: theme.accentHot),
                  ),
                ),
              ],
            ),
            verticalMargin8,
            Text(
              roughness < 0.3
                  ? 'MODE: HIGH_POLISHED'
                  : (roughness > 0.7 ? 'MODE: MATTE_CARBON' : 'MODE: TACTICAL_COMPOSITE'),
              style: theme.caption.copyWith(fontSize: 9, color: theme.onSurfaceDim),
            ),
          ],
        ),
      ),
    );
  }
}
