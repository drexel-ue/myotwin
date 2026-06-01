import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// The relative position of the quick menu on the screen.
enum QuickMenuPosition {
  /// Left aligned.
  left,

  /// Center aligned.
  center,

  /// Right aligned.
  right,
}

/// A builder for a single menu item in the [QuickCommandMenu].
typedef QuickMenuItemBuilder =
    Widget Function(
      BuildContext context,
      int index, {
      required bool isHovered,
    });

/// A radial "Stem and Bloom" command menu anchored to a center point.
class QuickCommandMenu extends StatefulWidget {
  /// Creates a [QuickCommandMenu].
  const QuickCommandMenu({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onItemSelected,
    required this.child,
    this.radius = 110.0,
    this.itemSize = 56.0,
    this.preferredSpacing = math.pi / 4, // 45 degrees
  });

  /// The number of items in the menu.
  final int itemCount;

  /// The builder for each menu item.
  final QuickMenuItemBuilder itemBuilder;

  /// Callback for when an item is selected.
  final ValueChanged<int> onItemSelected;

  /// The child widget to anchor the menu to.
  final Widget child;

  /// The radius of the radial arc.
  final double radius;

  /// The size of each menu item.
  final double itemSize;

  /// The preferred spacing between items in radians.
  final double preferredSpacing;

  @override
  State<QuickCommandMenu> createState() => _QuickCommandMenuState();
}

class _QuickCommandMenuState extends State<QuickCommandMenu> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fabKey = GlobalKey();

  bool _isOpen = false;
  Timer? _closeTimer;
  int? _hoveredIndex;

  QuickMenuPosition _currentPosition = QuickMenuPosition.center;
  Offset? _fabCenterGlobal;

  // --- Rotary Dial State ---
  double _scrollAngle = 0.0;
  double _lastFingerAngle = 0.0; // Changed to relative frame tracking
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    _controller.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  // --- Spatial & Arc Mathematics ---

  void _calculatePosition() {
    final box = _fabKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final offset = box.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;

    _fabCenterGlobal = Offset(
      offset.dx + (box.size.width / 2),
      offset.dy + (box.size.height / 2),
    );

    final centerX = _fabCenterGlobal!.dx;
    if (centerX < screenWidth * 0.35) {
      _currentPosition = QuickMenuPosition.left;
    } else if (centerX > screenWidth * 0.65) {
      _currentPosition = QuickMenuPosition.right;
    } else {
      _currentPosition = QuickMenuPosition.center;
    }
  }

  double _getMidpoint() {
    // Recalculated to pin to the top of the screen (270 degrees) and fan downward
    switch (_currentPosition) {
      case QuickMenuPosition.left:
        return 15 * math.pi / 8; // 337.5°
      case QuickMenuPosition.center:
        return 3 * math.pi / 2; // 270.0°
      case QuickMenuPosition.right:
        return 9 * math.pi / 8; // 202.5°
    }
  }

  double _getMaxSpread() {
    // Increased left and right windows to 135 degrees
    switch (_currentPosition) {
      case QuickMenuPosition.left:
        return 3 * math.pi / 4; // 135° limit
      case QuickMenuPosition.center:
        return math.pi; // 180° limit
      case QuickMenuPosition.right:
        return 3 * math.pi / 4; // 135° limit
    }
  }

  double _getFingerAngle(Offset globalPosition) {
    if (_fabCenterGlobal == null) return 0.0;
    final dx = globalPosition.dx - _fabCenterGlobal!.dx;
    final dy = globalPosition.dy - _fabCenterGlobal!.dy;
    var angle = math.atan2(dy, dx);
    if (angle < 0) angle += 2 * math.pi;
    return angle;
  }

  // --- Core Interaction Lifecycle ---

  void _openMenu() {
    _calculatePosition();
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    _isOpen = true;
    unawaited(_controller.forward());
  }

  void _closeMenu() {
    _closeTimer?.cancel();
    _isOpen = false;
    unawaited(
      _controller.reverse().then((_) {
        if (!_isOpen && _overlayEntry != null) {
          _overlayEntry!.remove();
          _overlayEntry = null;
          _hoveredIndex = null;
        }
      }),
    );
  }

  void _startTimer() {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(seconds: 2), () {
      if (_isOpen) _closeMenu();
    });
  }

  void _onItemTapped(int index) {
    _closeTimer?.cancel();
    widget.onItemSelected(index);
    _closeMenu();
  }

  // --- Rotary Drag Handlers ---

  void _startInteraction(Offset globalPosition) {
    _closeTimer?.cancel();
    _lastFingerAngle = _getFingerAngle(globalPosition);
    _isDragging = false;
    _updateHover(globalPosition);
  }

  void _updateInteraction(Offset globalPosition) {
    if (_fabCenterGlobal == null) return;

    final dx = globalPosition.dx - _fabCenterGlobal!.dx;
    final dy = globalPosition.dy - _fabCenterGlobal!.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    final currentAngle = _getFingerAngle(globalPosition);
    var delta = currentAngle - _lastFingerAngle;

    // Normalize delta for shortest-path wrap around
    if (delta > math.pi) delta -= 2 * math.pi;
    if (delta < -math.pi) delta += 2 * math.pi;

    // ONLY process scroll if they have pushed out of the unstable dead zone
    if (distance > widget.radius * 0.4) {
      if (delta.abs() > 0.01) {
        // 0.01 rad is roughly 0.5 degrees
        _isDragging = true;

        final visibleSpread = _getMaxSpread();
        final totalSweep = (widget.itemCount - 1) * widget.preferredSpacing;

        if (totalSweep > visibleSpread) {
          final maxScroll = totalSweep - visibleSpread;
          _scrollAngle += delta; // Add relative movement
          _scrollAngle = _scrollAngle.clamp(-maxScroll, 0.0);
        }
      }
    }

    // Always update the last angle so exiting the dead zone doesn't cause a jump
    _lastFingerAngle = currentAngle;

    _updateHover(globalPosition);
    _overlayEntry?.markNeedsBuild();
  }

  void _endInteraction(Offset? globalPosition) {
    if (!_isDragging && _hoveredIndex != null) {
      _onItemTapped(_hoveredIndex!);
    } else {
      _hoveredIndex = null;
      _overlayEntry?.markNeedsBuild();
      _startTimer();
    }
  }

  void _updateHover(Offset globalPosition) {
    if (_fabCenterGlobal == null) return;

    final dx = globalPosition.dx - _fabCenterGlobal!.dx;
    final dy = globalPosition.dy - _fabCenterGlobal!.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    if ((distance - widget.radius).abs() > widget.itemSize * 1.5) {
      _hoveredIndex = null;
      return;
    }

    final fingerAngle = _getFingerAngle(globalPosition);
    final midpoint = _getMidpoint();
    final visibleSpread = _getMaxSpread();
    final totalSweep = (widget.itemCount - 1) * widget.preferredSpacing;
    final startAngle = midpoint - math.min(totalSweep, visibleSpread) / 2;

    int? closestIndex;
    var minDiff = double.infinity;

    for (var i = 0; i < widget.itemCount; i++) {
      var itemAngle = startAngle + (i * widget.preferredSpacing) + _scrollAngle;

      itemAngle = itemAngle % (2 * math.pi);
      if (itemAngle < 0) itemAngle += 2 * math.pi;

      var diff = (itemAngle - fingerAngle).abs();
      if (diff > math.pi) diff = 2 * math.pi - diff;

      if (diff < minDiff) {
        minDiff = diff;
        closestIndex = i;
      }
    }

    _hoveredIndex = (minDiff <= widget.preferredSpacing / 1.5) ? closestIndex : null;
  }

  // --- Overlay Renderer ---

  OverlayEntry _createOverlayEntry() {
    final box = _fabKey.currentContext?.findRenderObject() as RenderBox?;
    final fabSize = box?.size ?? const Size(56.0, 56.0);
    final itemSize = widget.itemSize;

    return OverlayEntry(
      builder: (context) {
        final midpoint = _getMidpoint();
        final visibleSpread = _getMaxSpread();
        final totalSweep = (widget.itemCount - 1) * widget.preferredSpacing;
        final startAngle = midpoint - math.min(totalSweep, visibleSpread) / 2;
        const fadeZone = math.pi / 8;

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapDown: (details) => _startInteraction(details.globalPosition),
                onTapUp: (details) => _endInteraction(details.globalPosition),
                onPanStart: (details) => _startInteraction(details.globalPosition),
                onPanUpdate: (details) => _updateInteraction(details.globalPosition),
                onPanEnd: (details) => _endInteraction(null),
                child: Container(color: Colors.transparent),
              ),
            ),
            ...List.generate(widget.itemCount, (index) {
              final itemAngle = startAngle + (index * widget.preferredSpacing) + _scrollAngle;

              var angularDiff = (itemAngle - midpoint).abs();
              if (angularDiff > math.pi) angularDiff = 2 * math.pi - angularDiff;

              final edgeDist = (visibleSpread / 2) - angularDiff;
              var targetOpacity = 1.0;
              var scaleShrink = 1.0;

              if (edgeDist <= 0) {
                targetOpacity = 0.0;
                scaleShrink = 0.4;
              } else if (edgeDist < fadeZone) {
                final ratio = edgeDist / fadeZone;
                targetOpacity = ratio;
                scaleShrink = 0.4 + (0.6 * ratio);
              }

              return AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final finalOpacity = (targetOpacity * _animation.value).clamp(0.0, 1.0);
                  final isHovered = _hoveredIndex == index;
                  final currentRadius = _animation.value * widget.radius;

                  final dx = math.cos(itemAngle) * currentRadius;
                  final dy = math.sin(itemAngle) * currentRadius;

                  final offset = Offset(
                    (fabSize.width / 2) + dx - (itemSize / 2),
                    (fabSize.height / 2) + dy - (itemSize / 2),
                  );

                  final baseScale = _animation.value.clamp(0.0, 1.0);
                  final finalScale = baseScale * scaleShrink * (isHovered ? 1.15 : 1.0);

                  return CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset: offset,
                    child: IgnorePointer(
                      child: Transform.scale(
                        scale: finalScale,
                        child: Opacity(
                          opacity: finalOpacity,
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: itemSize,
                  height: itemSize,
                  child: widget.itemBuilder(
                    context,
                    index,
                    isHovered: _hoveredIndex == index,
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _fabKey,
        onLongPressStart: (details) {
          _openMenu();
          _startInteraction(details.globalPosition);
        },
        onLongPressMoveUpdate: (details) => _updateInteraction(details.globalPosition),
        onLongPressEnd: (details) => _endInteraction(details.globalPosition),
        child: widget.child,
      ),
    );
  }
}
