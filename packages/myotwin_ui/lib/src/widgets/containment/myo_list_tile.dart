import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A cyberpunk HUD-style list tile.
///
/// Used for displaying grouped information (title/subtitle) or navigation items
/// within HUD panels.
class MyoListTile extends StatefulWidget {
  /// Creates a [MyoListTile].
  const MyoListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.isSelected = false,
    this.onTap,
    this.padding,
  });

  /// The primary text displayed in the tile.
  final String title;

  /// Optional secondary text displayed below the title.
  final String? subtitle;

  /// Optional widget displayed at the start of the tile.
  final Widget? leading;

  /// Optional widget displayed at the end of the tile.
  final Widget? trailing;

  /// Whether the tile is in a selected/active state.
  /// When true, a vertical accent bar is shown at the start.
  final bool isSelected;

  /// Callback when the tile is tapped. Triggers a glitch effect.
  final VoidCallback? onTap;

  /// Optional padding for the internal content.
  final EdgeInsetsGeometry? padding;

  @override
  State<MyoListTile> createState() => _MyoListTileState();
}

class _MyoListTileState extends State<MyoListTile>
    with SingleTickerProviderStateMixin, HoloGlitchTickerMixin<MyoListTile> {
  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return HoloGlitch(
      phase: glitchPhase,
      intensity: glitchIntensity,
      severity: 0.2,
      child: InkWell(
        onTap: () {
          triggerGlitch();
          widget.onTap?.call();
        },
        splashColor: theme.outline.withValues(alpha: 0.2),
        highlightColor: theme.outline.withValues(alpha: 0.1),
        child: Container(
          padding: widget.padding ?? horizontalPadding12 + verticalPadding8,
          decoration: BoxDecoration(
            border: widget.isSelected ? Border(left: BorderSide(color: theme.accentHot, width: 2)) : null,
          ),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                horizontalMargin12,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: .stretch,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      widget.title,
                      style: theme.bodyMedium.copyWith(
                        color: widget.isSelected ? theme.white : theme.onSurfaceMedium,
                        fontWeight: widget.isSelected ? .w600 : .normal,
                      ),
                    ),
                    if (widget.subtitle case final String subtitle) ...[
                      verticalMargin4,
                      Text(
                        subtitle,
                        style: theme.bodySmall.copyWith(
                          color: theme.onSurface,
                          fontWeight: .w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.trailing != null) ...[
                horizontalMargin12,
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
