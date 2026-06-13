import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A searchable HUD overlay providing access to all high-level system commands.
class SettingsHudSurface extends StatefulWidget {
  /// Creates a [SettingsHudSurface].
  const SettingsHudSurface({
    super.key,
    required this.onCommandSelected,
    required this.onClose,
  });

  /// Called when a command tile is selected.
  final ValueChanged<QuickCommand> onCommandSelected;

  /// Called when the HUD should be dismissed.
  final VoidCallback onClose;

  @override
  State<SettingsHudSurface> createState() => _SettingsHudSurfaceState();
}

class _SettingsHudSurfaceState extends State<SettingsHudSurface> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_CommandMetadata> get _filteredCommands {
    const all = [
      _CommandMetadata(
        command: QuickCommand.goalExplorer,
        label: 'Goal Explorer',
        description: 'Track and analyze active biological objectives.',
        icon: 'crosshair',
      ),
      _CommandMetadata(
        command: QuickCommand.anatomyTargeter,
        label: 'Anatomy Targeter',
        description: 'Isolate and highlight specific anatomical systems.',
        icon: 'target',
      ),
      _CommandMetadata(
        command: QuickCommand.themeSettings,
        label: 'Theme Settings',
        description: 'Calibrate HUD aesthetics and model materials.',
        icon: 'gear',
      ),
      _CommandMetadata(
        command: QuickCommand.logSymptom,
        label: 'Log Symptom',
        description: 'Report acute pain or biomechanical flare-ups.',
        icon: 'activity',
      ),
      _CommandMetadata(
        command: QuickCommand.bodyHeatmap,
        label: 'Body Heatmap',
        description: 'Toggle the volumetric performance heatmap.',
        icon: 'flame',
      ),
      _CommandMetadata(
        command: QuickCommand.xrayOverlay,
        label: 'X-Ray View',
        description: 'Toggle translucent material transparency.',
        icon: 'layers',
      ),
      _CommandMetadata(
        command: QuickCommand.calibrate,
        label: 'Calibrate Sensors',
        description: 'Re-zero biomechanical sensors and model orientation.',
        icon: 'refresh',
      ),
    ];

    if (_query.isEmpty) return all;

    return all.where((c) {
      return c.label.toLowerCase().contains(_query) ||
          c.description.toLowerCase().contains(_query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 500,
        maxHeight: 600,
      ),
      child: FrostedHUD(
        title: 'SYSTEM_COMMANDS',
        impactPoint: Offset.zero,
        onClose: widget.onClose,
        expand: true,
        child: Padding(
          padding: allPadding16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MyoTextField(
                controller: _searchController,
                hint: 'SEARCH_COMMANDS...',
                prefixIcon: const MyoIcon(intent: 'search', size: 18),
              ),
              const SizedBox(height: 24),
              Flexible(
                child: _filteredCommands.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Text(
                            'NO_MATCHING_COMMANDS_FOUND',
                            style: context.myoTheme.caption.copyWith(
                              color: context.myoTheme.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _filteredCommands.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final metadata = _filteredCommands[index];
                          return _CommandTile(
                            metadata: metadata,
                            onPressed: () => widget.onCommandSelected(metadata.command),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommandMetadata {
  const _CommandMetadata({
    required this.command,
    required this.label,
    required this.description,
    required this.icon,
  });

  final QuickCommand command;
  final String label;
  final String description;
  final String icon;
}

class _CommandTile extends StatelessWidget {
  const _CommandTile({
    required this.metadata,
    required this.onPressed,
  });

  final _CommandMetadata metadata;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.white.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              MyoIcon(
                intent: metadata.icon,
                size: 32,
                color: theme.accentHot,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metadata.label.toUpperCase(),
                      style: theme.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      metadata.description,
                      style: theme.caption.copyWith(
                        color: theme.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              MyoIcon(
                intent: 'chevron_right',
                size: 16,
                color: theme.white.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
