import 'package:flutter/material.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A tactical sidebar for searching and targeting anatomical segments.
class AnatomyTargetingSurface extends StatefulWidget {
  /// Creates an [AnatomyTargetingSurface].
  const AnatomyTargetingSurface({
    super.key,
    required this.nodesByLayer,
    required this.activeLayer,
    required this.onLayerChanged,
    required this.onNodeSelected,
    required this.onClose,
  });

  /// The map of anatomical node IDs grouped by layer.
  final Map<AnatomyLayer, List<String>> nodesByLayer;

  /// The currently isolated layer.
  final AnatomyLayer? activeLayer;

  /// Called when the isolated layer is changed.
  final ValueChanged<AnatomyLayer?> onLayerChanged;

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

    // 1. Flatten and filter nodes based on selected layer and search query
    final List<String> filteredNodes = [];
    if (widget.activeLayer != null) {
      // Only show nodes from the selected layer
      final layerNodes = widget.nodesByLayer[widget.activeLayer] ?? [];
      filteredNodes.addAll(layerNodes.where((node) {
        return node.toLowerCase().contains(_searchQuery.toLowerCase());
      }));
    } else {
      // Show all nodes from all layers
      for (final layerNodes in widget.nodesByLayer.values) {
        filteredNodes.addAll(layerNodes.where((node) {
          return node.toLowerCase().contains(_searchQuery.toLowerCase());
        }));
      }
    }
    filteredNodes.sort();

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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: MyoSegmentedButton<AnatomyLayer?>(
                value: widget.activeLayer,
                onSelectionChanged: (value) {
                  // If tapping already selected, toggle off
                  if (value == widget.activeLayer) {
                    widget.onLayerChanged(null);
                  } else {
                    widget.onLayerChanged(value);
                  }
                },
                segments: [
                  MyoSegment(
                    value: AnatomyLayer.skeletal,
                    label: '',
                    icon: Tooltip(
                      message: 'SKELETAL',
                      child: MyoIcon(
                        intent: 'bone',
                        size: 18,
                        color: widget.activeLayer == AnatomyLayer.skeletal
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  MyoSegment(
                    value: AnatomyLayer.muscular,
                    label: '',
                    icon: Tooltip(
                      message: 'MUSCULAR',
                      child: MyoIcon(
                        intent: 'activity',
                        size: 18,
                        color: widget.activeLayer == AnatomyLayer.muscular
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  MyoSegment(
                    value: AnatomyLayer.nervous,
                    label: '',
                    icon: Tooltip(
                      message: 'NERVOUS',
                      child: MyoIcon(
                        intent: 'cpu',
                        size: 18,
                        color: widget.activeLayer == AnatomyLayer.nervous
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  MyoSegment(
                    value: AnatomyLayer.cardiovascular,
                    label: '',
                    icon: Tooltip(
                      message: 'CARDIO',
                      child: MyoIcon(
                        intent: 'heart',
                        size: 18,
                        color: widget.activeLayer == AnatomyLayer.cardiovascular
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  MyoSegment(
                    value: AnatomyLayer.joints,
                    label: '',
                    icon: Tooltip(
                      message: 'JOINTS',
                      child: MyoIcon(
                        intent: 'link',
                        size: 18,
                        color: widget.activeLayer == AnatomyLayer.joints
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            verticalMargin16,

            // 2. Search Field
            MyoTextField(
              hint: 'SEARCH_KINETIC_CHAIN...',
              autofocus: true,
              prefixIcon: const MyoIcon(intent: 'target', size: 18),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            verticalMargin16,

            // 3. Node List
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
                      separatorBuilder: (_, __) => const MyoDivider(),
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
