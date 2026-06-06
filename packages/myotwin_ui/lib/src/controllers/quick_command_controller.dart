import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A controller that manages the state, timers, and overlay lifecycle
/// for the quick command menu.
class QuickCommandController extends ChangeNotifier {
  /// Creates a [QuickCommandController].
  QuickCommandController();

  bool _isOpen = false;
  int? _hoveredIndex;
  int? _activeTooltipIndex;
  double _scrollAngle = 0.0;
  bool _isDragging = false;

  Timer? _closeTimer;
  Timer? _tooltipDwellTimer;

  /// Whether the menu is currently open.
  bool get isOpen => _isOpen;

  /// The index of the currently hovered menu item.
  int? get hoveredIndex => _hoveredIndex;

  /// The index of the item whose tooltip is currently displayed.
  int? get activeTooltipIndex => _activeTooltipIndex;

  /// The current rotation angle of the menu wheel.
  double get scrollAngle => _scrollAngle;

  /// Whether the user is currently dragging the wheel.
  bool get isDragging => _isDragging;

  /// Opens the menu.
  void open() {
    _isOpen = true;
    _startCloseTimer();
    notifyListeners();
  }

  /// Closes the menu.
  void close() {
    _closeTimer?.cancel();
    _tooltipDwellTimer?.cancel();
    _isOpen = false;
    _hoveredIndex = null;
    _activeTooltipIndex = null;
    notifyListeners();
  }

  /// Updates the hover state based on the calculated index.
  void updateHover(int? index, {required VoidCallback onTooltipTrigger}) {
    if (_isDragging) {
      if (_hoveredIndex != null) {
        _hoveredIndex = null;
        _tooltipDwellTimer?.cancel();
        notifyListeners();
      }
      return;
    }

    if (index != _hoveredIndex) {
      _hoveredIndex = index;
      _tooltipDwellTimer?.cancel();

      if (_hoveredIndex != null) {
        _tooltipDwellTimer = Timer(const Duration(milliseconds: 250), () {
          _activeTooltipIndex = _hoveredIndex;
          onTooltipTrigger();
          notifyListeners();
        });
      }
      notifyListeners();
    }
  }

  /// Updates the scroll angle during interaction.
  void updateScroll(double delta) {
    _isDragging = true;
    _scrollAngle += delta;
    _startCloseTimer();
    notifyListeners();
  }

  /// Resets the dragging state.
  void endInteraction() {
    _isDragging = false;
    _startCloseTimer();
    notifyListeners();
  }

  void _startCloseTimer() {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(seconds: 2), () {
      if (_isOpen) close();
    });
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    _tooltipDwellTimer?.cancel();
    super.dispose();
  }
}
