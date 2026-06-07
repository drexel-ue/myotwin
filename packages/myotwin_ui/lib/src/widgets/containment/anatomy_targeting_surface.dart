import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';
import 'package:provider/provider.dart';

/// A tactical sidebar for searching and targeting anatomical segments using semantic terms.
class AnatomyTargetingSurface extends StatefulWidget {
  /// Creates an [AnatomyTargetingSurface].
  const AnatomyTargetingSurface({
    super.key,
    required this.nodesByLayer,
    required this.activeLayer,
    required this.selectedNodes,
    required this.onLayerChanged,
    required this.onNodeSelected,
    required this.onClearSelections,
    required this.onClose,
  });

  /// The map of anatomical node IDs grouped by layer.
  final Map<AnatomyLayer, List<String>> nodesByLayer;

  /// The currently isolated layer.
  final AnatomyLayer? activeLayer;

  /// The list of currently targeted nodes.
  final List<String> selectedNodes;

  /// Called when the isolated layer is changed.
  final ValueChanged<AnatomyLayer?> onLayerChanged;

  /// Called when a node is selected.
  final ValueChanged<String> onNodeSelected;

  /// Called when all selections are cleared.
  final VoidCallback onClearSelections;

  /// Called when the surface is dismissed.
  final VoidCallback onClose;

  @override
  State<AnatomyTargetingSurface> createState() => _AnatomyTargetingSurfaceState();
}

class _AnatomyTargetingSurfaceState extends State<AnatomyTargetingSurface> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;
    final semanticService = context.watch<AnatomySemanticService>();

    // 1. Create a set of valid technical IDs based on the active layer or full scene
    final Set<String> physicalLayerIds;
    if (widget.activeLayer != null) {
      physicalLayerIds = widget.nodesByLayer[widget.activeLayer]?.toSet() ?? {};
    } else {
      physicalLayerIds = widget.nodesByLayer.values.expand((e) => e).toSet();
    }

    // 2. Perform semantic search and intersect with physical availability
    final filteredNodes =
        semanticService
            .search(
              _searchQuery,
              // We no longer pass the layer to the semantic service (JSON-based)
              // to prevent miscategorization leakage.
            )
            .where((node) => physicalLayerIds.contains(node.id))
            .toList()
          ..sort((a, b) => a.laymanName.compareTo(b.laymanName));

    return FrostedHUD(
      impactPoint: Offset.zero,
      title: 'TARGET_LOCK',
      onClose: widget.onClose,
      expand: true,
      child: Padding(
        padding: allPadding16,
        child: Column(
          children: [
            // 1. Layer Filters
            MyoSegmentedButton<AnatomyLayer?>(
              value: widget.activeLayer,
              allowUnselect: true,
              onSelectionChanged: (value) {
                if (value == widget.activeLayer) {
                  widget.onLayerChanged(null);
                } else {
                  widget.onLayerChanged(value);
                }
              },
              segments: const [
                MyoSegment(
                  value: AnatomyLayer.skeletal,
                  label: '',
                  icon: Tooltip(
                    message: 'SKELETAL',
                    child: MyoIcon(intent: 'bone', size: 18),
                  ),
                ),
                MyoSegment(
                  value: AnatomyLayer.muscular,
                  label: '',
                  icon: Tooltip(
                    message: 'MUSCULAR',
                    child: MyoIcon(intent: 'activity', size: 18),
                  ),
                ),
                MyoSegment(
                  value: AnatomyLayer.nervous,
                  label: '',
                  icon: Tooltip(
                    message: 'NERVOUS',
                    child: MyoIcon(intent: 'cpu', size: 18),
                  ),
                ),
                MyoSegment(
                  value: AnatomyLayer.cardiovascular,
                  label: '',
                  icon: Tooltip(
                    message: 'CARDIO',
                    child: MyoIcon(intent: 'heart', size: 18),
                  ),
                ),
                MyoSegment(
                  value: AnatomyLayer.joints,
                  label: '',
                  icon: Tooltip(
                    message: 'JOINTS',
                    child: MyoIcon(intent: 'link', size: 18),
                  ),
                ),
              ],
            ),
            verticalMargin16,

            // 2. Search Field
            MyoTextField(
              hint: 'SEMANTIC_SEARCH...',
              autofocus: true,
              prefixIcon: const MyoIcon(intent: 'target', size: 18),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            verticalMargin8,

            // 3. Selection Summary & Clear
            if (widget.selectedNodes.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.selectedNodes.length} SELECTED',
                    style: theme.caption.copyWith(color: theme.accentHot),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onClearSelections,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Text(
                        'CLEAR_ALL',
                        style: theme.caption.copyWith(
                          color: theme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (widget.selectedNodes.isNotEmpty) verticalMargin8,

            // 4. Node List
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
                        final isSelected = widget.selectedNodes.contains(node.id);

                        return MyoListTile(
                          title: node.laymanName.toUpperCase(),
                          subtitle: node.id,
                          isSelected: isSelected,
                          trailing: MyoIcon(
                            intent: isSelected ? 'crosshair' : 'target',
                            size: 16,
                            color: isSelected ? theme.accentHot : theme.onSurfaceDim,
                          ),
                          onTap: () => widget.onNodeSelected(node.id),
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
