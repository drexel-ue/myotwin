import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A tactical sidebar for searching and targeting anatomical segments.
class AnatomyTargetingSurface extends StatefulWidget {
  /// Creates an [AnatomyTargetingSurface].
  const AnatomyTargetingSurface({
    super.key,
    required this.availableNodes,
    required this.onNodeSelected,
    required this.onClose,
  });

  /// The list of anatomical node IDs available for targeting.
  final List<String> availableNodes;

  /// Called when a node is selected.
  final ValueChanged<String> onNodeSelected;

  /// Called when the surface is dismissed.
  final VoidCallback onClose;

  @override
  State<AnatomyTargetingSurface> createState() =>
      _AnatomyTargetingSurfaceState();
}

class _AnatomyTargetingSurfaceState extends State<AnatomyTargetingSurface> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;

    final filteredNodes = widget.availableNodes.where((node) {
      return node.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList()
      ..sort();

    return FrostedHUD(
      impactPoint: Offset.zero,
      title: 'TARGET_LOCK',
      onClose: widget.onClose,
      expand: true,
      child: Padding(
        padding: allPadding16,
        child: Column(
          children: [
            // 1. Search Field
            MyoTextField(
              hint: 'SEARCH_KINETIC_CHAIN...',
              autofocus: true,
              prefixIcon: const MyoIcon(intent: 'target', size: 18),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            verticalMargin16,

            // 2. Node List
            Expanded(
              child: filteredNodes.isEmpty
                  ? Center(
                      child: Text(
                        'NO_NODES_FOUND',
                        style: theme.caption.copyWith(color: theme.onSurfaceDim),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredNodes.length,
                      separatorBuilder: (_, _) => const MyoDivider(),
                      itemBuilder: (context, index) {
                        final node = filteredNodes[index];
                        return MyoListTile(
                          title: node,
                          trailing: const MyoIcon(intent: 'crosshair', size: 16),
                          onTap: () => widget.onNodeSelected(node),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
