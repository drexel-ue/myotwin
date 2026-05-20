import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide responsive layout utilities, such as determining if the current screen width is considered a desktop layout based on a defined threshold.
extension ResponsiveContext on BuildContext {
  /// A convenient extension on [BuildContext] to determine if the current screen width is considered a desktop layout, based on a threshold of 800 pixels.
  bool get isDesktop => MediaQuery.sizeOf(this).width >= 800;

  /// The current screen width in logical pixels.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// The current screen height in logical pixels.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// The current screen size in logical pixels.
  Size get screenSize => MediaQuery.sizeOf(this);

  /// The current media view padding (e.g. notches, status bar).
}
