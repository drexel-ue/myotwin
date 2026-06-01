import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myotwin_ui/myotwin_ui.dart';

/// A radial "Stem and Bloom" command menu that reacts to an external drag position.
class QuickCommandMenu extends StatefulWidget {
  /// Creates a [QuickCommandMenu].
  const QuickCommandMenu({
    super.key,
    required this.dragPosition,
    required this.onNodeHighlighted,
    required this.startAngle,
    required this.endAngle,
  });

  /// The current drag position relative to the menu center.
  final Offset? dragPosition;

  /// Called when a node becomes highlighted or unhighlighted.
  final ValueChanged<String?> onNodeHighlighted;

  /// The start boundary of the radial fan in radians.
  final double startAngle;

  /// The end boundary of the radial fan in radians.
  final double endAngle;

  @override
  State<QuickCommandMenu> createState() => _QuickCommandMenuState();
}

class _QuickCommandMenuState extends State<QuickCommandMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  String? _lastHighlighted;

  // Nodes to display (for testing multiple options)
  final List<String> _nodes = ['GOALS', 'TASKS', 'LOGS', 'STATS'];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void didUpdateWidget(covariant QuickCommandMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dragPosition != oldWidget.dragPosition) {
      _checkBounds();
    }
  }

  void _checkBounds() {
    if (widget.dragPosition == null) return;

    final distance = widget.dragPosition!.distance;
    String? currentHighlight;

    // 1. Check if thumb is in the "active ring" around the button distance (40px)
    if (distance > 15.0 && distance < 120.0) {
      // 2. Determine angle of the thumb relative to the center
      final angle = math.atan2(widget.dragPosition!.dy, widget.dragPosition!.dx);
      
      final stepAngle = (_nodes.length > 1) 
          ? (widget.endAngle - widget.startAngle) / (_nodes.length - 1)
          : 0.0;
      
      for (var i = 0; i < _nodes.length; i++) {
        final nodeAngle = (_nodes.length > 1)
            ? widget.startAngle + (i * stepAngle)
            : (widget.startAngle + widget.endAngle) / 2.0;
        
        // Circular difference check
        var diff = (angle - nodeAngle).abs();
        if (diff > math.pi) diff = (2 * math.pi) - diff;
        
        if (diff < 0.3) { // High precision angular sector
          currentHighlight = _nodes[i];
          break;
        }
      }
    }

    if (currentHighlight != _lastHighlighted) {
      _lastHighlighted = currentHighlight;
      widget.onNodeHighlighted(currentHighlight);
      if (currentHighlight != null) {
        unawaited(HapticFeedback.selectionClick());
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const menuSize = 300.0;
    const centerOffset = menuSize / 2.0;

    final stepAngle = (_nodes.length > 1) 
        ? (widget.endAngle - widget.startAngle) / (_nodes.length - 1)
        : 0.0;

    return SizedBox(
      width: menuSize,
      height: menuSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ..._nodes.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            final isHighlighted = _lastHighlighted == label;

            final angle = (_nodes.length > 1)
                ? widget.startAngle + (index * stepAngle)
                : (widget.startAngle + widget.endAngle) / 2.0;

            return _RadialNode(
              label: label,
              angle: angle,
              animation: _controller,
              isHighlighted: isHighlighted,
              centerOffset: centerOffset,
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
    required this.centerOffset,
  }) : super(listenable: animation);

  final String label;
  final double angle;
  final bool isHighlighted;
  final double centerOffset;

  Animation<double> get _animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final theme = context.myoTheme;
    final progress = _animation.value;

    final stemProgress = (progress / 0.6).clamp(0.0, 1.0);
    final bloomProgress = ((progress - 0.6) / 0.4).clamp(0.0, 1.0);

    const radius = 40.0;
    final currentRadius = stemProgress * radius;

    final x = centerOffset + math.cos(angle) * currentRadius;
    final y = centerOffset + math.sin(angle) * currentRadius;

    return Positioned(
      left: x,
      top: y,
      child: Transform.translate(
        offset: const Offset(-25, -15),
        child: Opacity(
          opacity: stemProgress,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: 0.7 + (bloomProgress * 0.3) + (isHighlighted ? 0.2 : 0.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      letterSpacing: 1.0,
                      fontSize: 9,
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
