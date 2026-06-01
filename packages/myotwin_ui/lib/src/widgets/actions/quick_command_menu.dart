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
    this.initialAngle = -math.pi / 2, // Upward
    this.fanAngle = math.pi / 2, // 90 degree spread
  });

  /// The current drag position relative to the menu center.
  final Offset? dragPosition;

  /// Called when a node becomes highlighted or unhighlighted.
  final ValueChanged<String?> onNodeHighlighted;

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
  String? _lastHighlighted;

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
  void didUpdateWidget(covariant QuickCommandMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dragPosition != oldWidget.dragPosition) {
      _checkBounds();
    }
  }

  void _checkBounds() {
    if (widget.dragPosition == null) return;

    String? currentHighlight;
    const radius = 70.0; // Compact radius
    const hitThreshold = 40.0; // Circular hit area

    for (var i = 0; i < _nodes.length; i++) {
      final angle = widget.initialAngle +
          (i *
              (widget.fanAngle /
                  (_nodes.length > 1 ? _nodes.length - 1 : 1)));

      final nodeCenter = Offset(
        math.cos(angle) * radius,
        math.sin(angle) * radius,
      );

      if ((widget.dragPosition! - nodeCenter).distance < hitThreshold) {
        currentHighlight = _nodes[i];
        break;
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

            final angle = widget.initialAngle +
                (index *
                    (widget.fanAngle /
                        (_nodes.length > 1 ? _nodes.length - 1 : 1)));

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

    // Stem animation: grows first 60%
    final stemProgress = (progress / 0.6).clamp(0.0, 1.0);
    // Bloom animation: scales in last 40%
    final bloomProgress = ((progress - 0.6) / 0.4).clamp(0.0, 1.0);

    const radius = 70.0; // Compact radius
    final currentRadius = stemProgress * radius;

    final x = centerOffset + math.cos(angle) * currentRadius;
    final y = centerOffset + math.sin(angle) * currentRadius;

    return Positioned(
      left: x,
      top: y,
      child: Transform.translate(
        offset: const Offset(-40, -20), // Center the label
        child: Opacity(
          opacity: stemProgress,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
