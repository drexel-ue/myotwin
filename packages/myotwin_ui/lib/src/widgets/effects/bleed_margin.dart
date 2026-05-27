import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A widget that allows its child to paint outside its layout bounds.
/// Perfect for dropping shadows or shaders into adjacent layout space.
class BleedMargin extends SingleChildRenderObjectWidget {
  /// Creates a [BleedMargin].
  const BleedMargin({
    super.key,
    required this.margin,
    super.child,
  });

  /// The amount of space by which the child can bleed outside its layout bounds.
  final EdgeInsets margin;

  @override
  RenderBox createRenderObject(BuildContext context) {
    return RenderBleedMargin(margin: margin);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderBleedMargin renderObject) {
    renderObject.margin = margin;
  }
}

/// The [RenderObject] for [BleedMargin].
class RenderBleedMargin extends RenderShiftedBox {
  /// Creates a [RenderBleedMargin].
  RenderBleedMargin({
    required EdgeInsets margin,
    RenderBox? child,
  })  : _margin = margin,
        super(child);

  EdgeInsets _margin;

  /// The amount of space by which the child can bleed outside its layout bounds.
  set margin(EdgeInsets value) {
    if (_margin == value) return;
    _margin = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    if (child == null) {
      size = constraints.smallest;
      return;
    }

    // 1. Expand constraints so the child can physically add its shader padding
    final innerConstraints = BoxConstraints(
      minWidth: constraints.minWidth,
      maxWidth: constraints.maxWidth == double.infinity ? double.infinity : constraints.maxWidth + _margin.horizontal,
      minHeight: constraints.minHeight,
      maxHeight: constraints.maxHeight == double.infinity ? double.infinity : constraints.maxHeight + _margin.vertical,
    );

    child!.layout(innerConstraints, parentUsesSize: true);

    // 2. Report the UNPADDED core size back to the layout engine (ListView)
    size = constraints.constrain(
      Size(
        child!.size.width - _margin.horizontal,
        child!.size.height - _margin.vertical,
      ),
    );

    // 3. Defensive initialization just in case the framework missed it
    if (child!.parentData is! BoxParentData) {
      setupParentData(child!);
    }

    // 4. Shift the child backward. RenderShiftedBox uses this exact offset
    // to map the visual layer and gesture recognizers flawlessly.
    (child!.parentData! as BoxParentData).offset = Offset(-_margin.left, -_margin.top);
  }
}
