import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A HUD overlay listing all active physical constraints and injuries.
class PainHudSurface extends StatelessWidget {
  /// Creates a [PainHudSurface].
  const PainHudSurface({
    super.key,
    required this.injuries,
    required this.onResolveInjury,
    required this.onClose,
  });

  /// The list of active injuries to display.
  final List<Injury> injuries;

  /// Called when an injury is marked as resolved.
  final ValueChanged<String> onResolveInjury;

  /// Called when the HUD should be dismissed.
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 500,
        maxHeight: 600,
      ),
      child: FrostedHUD(
        title: 'INJURY_VAULT',
        impactPoint: Offset.zero,
        onClose: onClose,
        expand: true,
        child: Padding(
          padding: allPadding16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (injuries.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyoIcon(
                          intent: 'shield',
                          size: 48,
                          color: theme.onSurfaceDim,
                        ),
                        verticalMargin16,
                        Text(
                          'NO_ACTIVE_CONSTRAINTS_DETECTED',
                          style: theme.caption.copyWith(color: theme.onSurfaceDim),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: injuries.length,
                    separatorBuilder: (_, _) => const MyoDivider(),
                    itemBuilder: (context, index) {
                      final injury = injuries[index];
                      final color = switch (injury.severity) {
                        InjurySeverity.low => theme.heatMed,
                        InjurySeverity.medium => theme.heatHigh,
                        InjurySeverity.critical => theme.heatCritical,
                      };

                      return MyoListTile(
                        title: injury.description.toUpperCase(),
                        subtitle: '${injury.nodeIds.length} NODES AFFECTED',
                        leading: Container(
                          width: 4,
                          height: 24,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: theme.radiusSm,
                          ),
                        ),
                        trailing: MyoIconButton(
                          intent: 'check',
                          onPressed: () => onResolveInjury(injury.id),
                        ),
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
