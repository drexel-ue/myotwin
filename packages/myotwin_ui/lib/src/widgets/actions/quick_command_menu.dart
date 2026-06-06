import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// The relative position of the quick menu on the screen.
enum QuickMenuPosition {
  /// Left-aligned menu.
  left,

  /// Center-aligned menu.
  center,

  /// Right-aligned menu.
  right,
}

/// A builder for a single menu item in the [QuickCommandMenu].
typedef QuickMenuItemBuilder =
    Widget Function(
      BuildContext context,
      int index, {
      required bool isHovered,
    });

/// A builder for the tooltip text shown when an item is hovered.
typedef QuickMenuTooltipBuilder = String Function(int index);

/// A radial "Stem and Bloom" command menu anchored to a center point.
class QuickCommandMenu extends StatefulWidget {
  /// Creates a [QuickCommandMenu].
  const QuickCommandMenu({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.tooltipBuilder,
    required this.onItemSelected,
    required this.child,
    this.radius = 110.0,
    this.itemSize = 56.0,
    this.preferredSpacing = math.pi / 4,
  });

  /// The number of items in the menu.
  final int itemCount;

  /// The builder for each menu item.
  final QuickMenuItemBuilder itemBuilder;

  /// Provides the text for the HUD tooltip.
  final QuickMenuTooltipBuilder? tooltipBuilder;

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

class _QuickCommandMenuState extends State<QuickCommandMenu> with TickerProviderStateMixin {
  late final AnimationController _menuController;

  /// Controls the stem and bloom animations.
  late final AnimationController _tooltipController;
  late final Animation<double> _menuAnimation;

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _fabKey = GlobalKey();

  bool _isOpen = false;
  Timer? _closeTimer;
  Timer? _tooltipDwellTimer;

  int? _hoveredIndex;

  /// Keeps track of the last hovered item for smooth exit animations.
  int? _activeTooltipIndex;

  QuickMenuPosition _currentPosition = QuickMenuPosition.center;
  Offset? _fabCenterGlobal;

  double _scrollAngle = 0.0;
  double _lastFingerAngle = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _menuAnimation = CurvedAnimation(parent: _menuController, curve: Curves.easeOutExpo);

    _tooltipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    _tooltipDwellTimer?.cancel();
    _menuController.dispose();
    _tooltipController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  // --- Spatial Math & Anchors ---

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

  double _getFingerAngle(Offset globalPosition) {
    if (_fabCenterGlobal == null) return 0.0;
    final dx = globalPosition.dx - _fabCenterGlobal!.dx;
    final dy = globalPosition.dy - _fabCenterGlobal!.dy;
    var angle = math.atan2(dy, dx);
    if (angle < 0) angle += 2 * math.pi;
    return angle;
  }

  // --- Interaction Lifecycle ---

  void _openMenu() {
    _calculatePosition();
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
    _isOpen = true;
    unawaited(_menuController.forward());
    _startTimer();
  }

  void _closeMenu() {
    _closeTimer?.cancel();
    _tooltipDwellTimer?.cancel();
    _isOpen = false;
    unawaited(_tooltipController.reverse()); // Ensure HUD closes
    unawaited(
      _menuController.reverse().then((_) {
        if (!_isOpen && _overlayEntry != null) {
          _overlayEntry!.remove();
          _overlayEntry = null;
          _hoveredIndex = null;
          _activeTooltipIndex = null;
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

  // --- Rotary & Hover Logic ---

  void _handleInteractionStart(Offset globalPosition) {
    _closeTimer?.cancel();
    _lastFingerAngle = _getFingerAngle(globalPosition);
    _isDragging = false;
    _updateHover(globalPosition);
    _startTimer();
  }

  bool _isOutsideActiveArea(Offset globalPosition) {
    if (_fabCenterGlobal == null) return false;
    final dx = globalPosition.dx - _fabCenterGlobal!.dx;
    final dy = globalPosition.dy - _fabCenterGlobal!.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    // 1.8x the radius gives a comfortable padding around the items
    // before a touch is considered a "dismiss" intent.
    return distance > widget.radius * 1.8;
  }

  void _handleInteractionUpdate(Offset globalPosition) {
    if (!_isOpen || _fabCenterGlobal == null) return;
    _startTimer();

    final dx = globalPosition.dx - _fabCenterGlobal!.dx;
    final dy = globalPosition.dy - _fabCenterGlobal!.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    final currentAngle = _getFingerAngle(globalPosition);
    var delta = currentAngle - _lastFingerAngle;

    if (delta > math.pi) delta -= 2 * math.pi;
    if (delta < -math.pi) delta += 2 * math.pi;

    if (distance > widget.radius * 0.4) {
      if (delta.abs() > 0.01) {
        _isDragging = true;
        _scrollAngle += delta;
      }
    }

    _lastFingerAngle = currentAngle;
    _updateHover(globalPosition);
    _overlayEntry?.markNeedsBuild();
  }

  void _handleHover(Offset globalPosition) {
    if (!_isOpen || _fabCenterGlobal == null) return;
    _startTimer();

    _lastFingerAngle = _getFingerAngle(globalPosition);
    _updateHover(globalPosition);
    _overlayEntry?.markNeedsBuild();
  }

  void _handleScroll(double delta) {
    if (!_isOpen) return;
    _startTimer();

    // Map pixel scroll to angular rotation (approx 0.005 radians per pixel)
    final angularDelta = -delta * 0.005;

    _scrollAngle += angularDelta;
    _overlayEntry?.markNeedsBuild();
  }

  void _handleInteractionEnd(Offset? globalPosition) {
    if (!_isOpen) return;
    _tooltipDwellTimer?.cancel();
    if (!_isDragging && _hoveredIndex != null) {
      _onItemTapped(_hoveredIndex!);
    } else {
      _hoveredIndex = null;
      unawaited(_tooltipController.reverse()); // Retract stem
      _overlayEntry?.markNeedsBuild();
      _startTimer();
    }
  }

  void _updateHover(Offset globalPosition) {
    if (_fabCenterGlobal == null) return;

    // --- SCROLL SUPPRESSION ---
    // If the ring is actively spinning, immediately kill any active
    // hover states and abort the rest of the hover math.
    if (_isDragging) {
      if (_hoveredIndex != null) {
        _hoveredIndex = null;
        _tooltipDwellTimer?.cancel();
        unawaited(_tooltipController.reverse());
        _overlayEntry?.markNeedsBuild();
      }
      return; // Stop processing hover logic while moving
    }

    final dx = globalPosition.dx - _fabCenterGlobal!.dx;
    final dy = globalPosition.dy - _fabCenterGlobal!.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    // Tighten the radial band to only activate when the finger is over the items.
    // This creates a precise deadzone between the FAB and the items.
    final innerBound = widget.radius - (widget.itemSize / 2) - 16.0;
    final outerBound = widget.radius + (widget.itemSize / 2) + 24.0;

    if (distance < innerBound || distance > outerBound) {
      if (_hoveredIndex != null) {
        _hoveredIndex = null;
        _tooltipDwellTimer?.cancel();
        unawaited(_tooltipController.reverse());
        _overlayEntry?.markNeedsBuild(); // Force visual update to remove hover scale
      }
      return;
    }

    final fingerAngle = _getFingerAngle(globalPosition);
    final midpoint = _currentPosition.getMidpoint();
    final visibleSpread = _currentPosition.getMaxSpread();
    final totalSweep = (widget.itemCount - 1) * widget.preferredSpacing;
    final startAngle = midpoint - math.min(totalSweep, visibleSpread) / 2;

    int? closestIndex;
    var minDiff = double.infinity;

    for (var i = 0; i < widget.itemCount; i++) {
      var itemAngle = startAngle + (i * widget.preferredSpacing) + _scrollAngle;
      itemAngle = itemAngle % (2 * math.pi);
      if (itemAngle < 0) itemAngle += 2 * math.pi;

      var diffFromFinger = (itemAngle - fingerAngle).abs();
      if (diffFromFinger > math.pi) {
        diffFromFinger = 2 * math.pi - diffFromFinger;
      }

      if (diffFromFinger < minDiff) {
        minDiff = diffFromFinger;
        closestIndex = i;
      }
    }

    final newHovered = (minDiff <= widget.preferredSpacing / 1.5) ? closestIndex : null;

    if (newHovered != _hoveredIndex) {
      _hoveredIndex = newHovered;
      _tooltipDwellTimer?.cancel();

      // Retract previous tooltip immediately when moving between items
      if (_tooltipController.value > 0) {
        unawaited(_tooltipController.reverse());
      }

      if (_hoveredIndex != null) {
        _tooltipDwellTimer = Timer(const Duration(milliseconds: 250), () {
          if (mounted && _hoveredIndex != null) {
            _activeTooltipIndex = _hoveredIndex;

            // Tell the overlay to reconstruct so the tooltip
            // passes the `activeTooltipIndex != null` check and enters the widget tree.
            _overlayEntry?.markNeedsBuild();

            // Force the tooltip to animate from 0 so it doesn't glitch across the screen
            unawaited(_tooltipController.forward(from: 0.0));
          }
        });
      } else {
        unawaited(_tooltipController.reverse());
      }

      _overlayEntry?.markNeedsBuild();
    }
  }
  // --- Overlay Renderer ---

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return _QuickCommandOverlayContent(
          menuAnimation: _menuAnimation,
          tooltipController: _tooltipController,
          layerLink: _layerLink,
          itemCount: widget.itemCount,
          itemBuilder: widget.itemBuilder,
          tooltipBuilder: widget.tooltipBuilder,
          onItemSelected: widget.onItemSelected,
          radius: widget.radius,
          itemSize: widget.itemSize,
          preferredSpacing: widget.preferredSpacing,
          position: _currentPosition,
          fabKey: _fabKey,
          scrollAngle: _scrollAngle,
          hoveredIndex: _hoveredIndex,
          activeTooltipIndex: _activeTooltipIndex,
          onInteractionStart: _handleInteractionStart,
          onInteractionUpdate: _handleInteractionUpdate,
          onHoverUpdate: _handleHover,
          onInteractionEnd: _handleInteractionEnd,
          onScroll: _handleScroll,
          onClose: _closeMenu,
          isOutsideActiveArea: _isOutsideActiveArea,
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
          _handleInteractionStart(details.globalPosition);
        },
        onLongPressMoveUpdate: (details) => _handleInteractionUpdate(details.globalPosition),
        onLongPressEnd: (details) => _handleInteractionEnd(details.globalPosition),
        onSecondaryTapDown: (details) {
          _openMenu();
          _handleInteractionStart(details.globalPosition);
        },
        child: widget.child,
      ),
    );
  }
}

class _QuickCommandOverlayContent extends StatelessWidget {
  const _QuickCommandOverlayContent({
    required this.menuAnimation,
    required this.tooltipController,
    required this.layerLink,
    required this.itemCount,
    required this.itemBuilder,
    this.tooltipBuilder,
    required this.onItemSelected,
    required this.radius,
    required this.itemSize,
    required this.preferredSpacing,
    required this.position,
    required this.fabKey,
    required this.scrollAngle,
    required this.hoveredIndex,
    required this.activeTooltipIndex,
    required this.onInteractionStart,
    required this.onInteractionUpdate,
    required this.onHoverUpdate,
    required this.onInteractionEnd,
    required this.onScroll,
    required this.onClose,
    required this.isOutsideActiveArea,
  });

  final Animation<double> menuAnimation;
  final AnimationController tooltipController;
  final LayerLink layerLink;
  final int itemCount;
  final QuickMenuItemBuilder itemBuilder;
  final QuickMenuTooltipBuilder? tooltipBuilder;
  final ValueChanged<int> onItemSelected;
  final double radius;
  final double itemSize;
  final double preferredSpacing;
  final QuickMenuPosition position;
  final GlobalKey fabKey;
  final double scrollAngle;
  final int? hoveredIndex;
  final int? activeTooltipIndex;
  final ValueChanged<Offset> onInteractionStart;
  final ValueChanged<Offset> onInteractionUpdate;
  final ValueChanged<Offset> onHoverUpdate;
  final ValueChanged<Offset?> onInteractionEnd;
  final ValueChanged<double> onScroll;
  final VoidCallback onClose;
  final bool Function(Offset) isOutsideActiveArea;

  @override
  Widget build(BuildContext context) {
    final box = fabKey.currentContext?.findRenderObject() as RenderBox?;
    final fabSize = box?.size ?? const Size(56.0, 56.0);

    final midpoint = position.getMidpoint();
    final visibleSpread = position.getMaxSpread();
    final totalSweep = (itemCount - 1) * preferredSpacing;
    final startAngle = midpoint - math.min(totalSweep, visibleSpread) / 2;

    // Determine safe zone for the Frosted Bloom based on FAB position
    final bloomCenter = switch (position) {
      QuickMenuPosition.left => Offset(
        fabSize.width / 2 + radius * 1.8,
        fabSize.height / 2 - radius * 0.5,
      ),
      QuickMenuPosition.right => Offset(
        fabSize.width / 2 - radius * 1.8,
        fabSize.height / 2 - radius * 0.5,
      ),
      QuickMenuPosition.center => Offset(
        fabSize.width / 2,
        fabSize.height / 2 - radius * 1.6,
      ),
    };

    return Stack(
      children: [
        // Use Listener for raw, instant hardware touch tracking
        // to prevent the Flutter Gesture Arena from swallowing/delaying touches.
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              if (isOutsideActiveArea(event.position)) {
                onClose();
              } else {
                onInteractionStart(event.position);
              }
            },
            onPointerMove: (event) => onInteractionUpdate(event.position),
            onPointerHover: (event) => onHoverUpdate(event.position),
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                onScroll(event.scrollDelta.dy);
              }
            },
            onPointerUp: (event) {
              if (!isOutsideActiveArea(event.position)) {
                onInteractionEnd(event.position);
              }
            },
            child: Container(color: Colors.transparent),
          ),
        ),

        // TETHER & BLOOM HUD LAYER (Rendered in Composited space to perfectly align with items)
        if (tooltipBuilder != null && activeTooltipIndex != null)
          CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            child: AnimatedBuilder(
              animation: tooltipController,
              builder: (context, child) {
                final targetAngle = startAngle + (activeTooltipIndex! * preferredSpacing) + scrollAngle;
                final targetRadius = menuAnimation.value * radius;

                final itemCenter = Offset(
                  (fabSize.width / 2) + math.cos(targetAngle) * targetRadius,
                  (fabSize.height / 2) + math.sin(targetAngle) * targetRadius,
                );

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // The Stem
                    CustomPaint(
                      painter: _StemPainter(
                        itemCenter: itemCenter,
                        bloomCenter: bloomCenter,
                        progress: tooltipController.value,
                      ),
                      size: Size.infinite,
                    ),
                    // The Bloom Panel
                    Positioned(
                      left: bloomCenter.dx,
                      top: bloomCenter.dy,
                      child: FractionalTranslation(
                        translation: const Offset(-0.5, -0.5),
                        child: Opacity(
                          // Delay panel fade in until stem is drawn (50% mark)
                          opacity: (tooltipController.value - 0.5).clamp(0.0, 0.5) * 2,
                          child: Transform.scale(
                            scale: 0.8 + ((tooltipController.value - 0.5).clamp(0.0, 0.5) * 2) * 0.2,
                            child: _FrostedTooltipHud(
                              text: tooltipBuilder!(activeTooltipIndex!),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

        // THE MENU ROTARY ITEMS
        ...List.generate(itemCount, (index) {
          final itemAngle = startAngle + (index * preferredSpacing) + scrollAngle;

          return AnimatedBuilder(
            animation: menuAnimation,
            builder: (context, child) {
              final finalOpacity = menuAnimation.value;
              final isHovered = hoveredIndex == index;
              final currentRadius = menuAnimation.value * radius;

              final dx = math.cos(itemAngle) * currentRadius;
              final dy = math.sin(itemAngle) * currentRadius;

              final offset = Offset(
                (fabSize.width / 2) + dx - (itemSize / 2),
                (fabSize.height / 2) + dy - (itemSize / 2),
              );

              final baseScale = menuAnimation.value.clamp(0.0, 1.0);
              final finalScale = baseScale * (isHovered ? 1.15 : 1.0);

              return CompositedTransformFollower(
                link: layerLink,
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
              child: itemBuilder(
                context,
                index,
                isHovered: hoveredIndex == index,
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _FrostedTooltipHud extends StatelessWidget {
  const _FrostedTooltipHud({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              text.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on QuickMenuPosition {
  double getMidpoint() {
    return switch (this) {
      QuickMenuPosition.left => 15 * math.pi / 8,
      QuickMenuPosition.center => 3 * math.pi / 2,
      QuickMenuPosition.right => 9 * math.pi / 8,
    };
  }

  double getMaxSpread() {
    return 2 * math.pi;
  }
}

// --- Cyberpunk HUD Stem Painter ---

class _StemPainter extends CustomPainter {
  /// Creates a [_StemPainter].
  _StemPainter({
    required this.itemCenter,
    required this.bloomCenter,
    required this.progress,
  });

  /// The center of the menu item.
  final Offset itemCenter;

  /// The center of the bloom panel.
  final Offset bloomCenter;

  /// The drawing progress (0.0 to 1.0).
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Stem drawing progress (0.0 to 0.5 of total animation maps to 0.0 to 1.0 of line length)
    final lineProgress = (progress * 2).clamp(0.0, 1.0);

    final currentEnd = Offset(
      ui.lerpDouble(itemCenter.dx, bloomCenter.dx, lineProgress)!,
      ui.lerpDouble(itemCenter.dy, bloomCenter.dy, lineProgress)!,
    );

    canvas.drawLine(itemCenter, currentEnd, paint);

    // Glowing connection dot at the node
    if (lineProgress > 0) {
      canvas.drawCircle(itemCenter, 3.0 * lineProgress, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StemPainter oldDelegate) {
    return oldDelegate.itemCenter != itemCenter ||
        oldDelegate.bloomCenter != bloomCenter ||
        oldDelegate.progress != progress;
  }
}
