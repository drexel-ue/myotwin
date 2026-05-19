import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide responsive layout utilities, such as determining if the current screen width is considered a desktop layout based on a defined threshold.
extension ResponsiveContext on BuildContext {
  /// A convenient extension on [BuildContext] to determine if the current screen width is considered a desktop layout, based on a threshold of 800 pixels.
  bool get isDesktop => MediaQuery.sizeOf(this).width >= 800;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  Size get screenSize => MediaQuery.sizeOf(this);

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
}
