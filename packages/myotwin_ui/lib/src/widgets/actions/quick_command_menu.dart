import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A radial "Stem and Bloom" command menu anchored to a center point.
class QuickCommandMenu extends StatefulWidget {
  /// Creates a [QuickCommandMenu].
  const QuickCommandMenu({
    super.key,
    required this.onNodeSelected,
    required this.onCancel,
    this.initialAngle = -math.pi / 2, // Upward
    this.fanAngle = math.pi / 2, // 90 degree spread
  });

  /// Called when a node is selected.
  final ValueChanged<String> onNodeSelected;

  /// Called when the menu is closed without selection.
  final VoidCallback onCancel;

  /// The starting angle of the radial arc.
  final double initialAngle;

  /// The total spread of the radial fan.
  final double fanAngle;

  @override
  State<QuickCommandMenu> createState() => _QuickCommandMenuState();
}

class _QuickCommandMenuState extends State<QuickCommandMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  String? _highlightedNode;

  // Nodes to display (initially just Goals)
  final List<String> _nodes = ['GOALS'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(Offset localPosition) {
    // Logic to determine which node is closest to the thumb
    // (Simplified for single node for now)
    final distance = localPosition.distance;
    if (distance > 40 && distance < 150) {
      if (_highlightedNode != 'GOALS') {
        setState(() => _highlightedNode = 'GOALS');
        unawaited(HapticFeedback.selectionClick());
      }
    } else {
      if (_highlightedNode != null) {
        setState(() => _highlightedNode = null);
      }
    }
  }

  void _handleDragEnd() {
    if (_highlightedNode != null) {
      widget.onNodeSelected(_highlightedNode!);
    } else {
      widget.onCancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (d) => _handleDragUpdate(d.localPosition),
      onPanEnd: (d) => _handleDragEnd(),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ..._nodes.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            final isHighlighted = _highlightedNode == label;

            // Calculate angle for this node
            final angle = widget.initialAngle +
                (index * (widget.fanAngle / (_nodes.length > 1 ? _nodes.length - 1 : 1)));

            return _RadialNode(
              label: label,
              angle: angle,
              animation: _controller,
              isHighlighted: isHighlighted,
            );
          }),
        ],
      ),
    );
  }
}

class _RadialNode extends AnimatedWidget {
  const _RadialNode({
    required this.label,
    required this.angle,
    required Animation<double> animation,
    required this.isHighlighted,
  }) : super(listenable: animation);

  final String label;
  final double angle;
  final bool isHighlighted;

  Animation<double> get _animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;
    final progress = _animation.value;

    // Stem animation: grows first 60%
    final stemProgress = (progress / 0.6).clamp(0.0, 1.0);
    // Bloom animation: scales in last 40%
    final bloomProgress = ((progress - 0.6) / 0.4).clamp(0.0, 1.0);

    const radius = 100.0;
    final currentRadius = stemProgress * radius;

    final x = math.cos(angle) * currentRadius;
    final y = math.sin(angle) * currentRadius;

    return Positioned(
      left: x,
      top: y,
      child: Transform.translate(
        offset: const Offset(-20, -20), // Center the node
        child: Opacity(
          opacity: stemProgress,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The "Stem" line could be drawn with a CustomPainter in the parent stack
              // but for this simple version we'll focus on the Bloom.
              Transform.scale(
                scale: 0.8 + (bloomProgress * 0.2) + (isHighlighted ? 0.2 : 0.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isHighlighted ? theme.accentHot : theme.surfaceElevated,
                    borderRadius: theme.radiusSm,
                    border: Border.all(
                      color: isHighlighted ? theme.white : theme.outline,
                      width: isHighlighted ? 2.0 : 1.0,
                    ),
                    boxShadow: isHighlighted
                        ? [
                            BoxShadow(
                              color: theme.accentHot.withValues(alpha: 0.3),
                              blurRadius: 12,
                            )
                          ]
                        : null,
                  ),
                  child: Text(
                    label,
                    style: theme.caption.copyWith(
                      color: isHighlighted ? theme.black : theme.onSurface,
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
