import 'package:dartatui/dartatui.dart';
import 'package:dartatui/framework/framework_core.dart' as fw;
import 'package:dartatui/core/core.dart';

class TerminalPadding extends fw.SingleChildRenderWidget {
  final EdgeInsets padding;
  const TerminalPadding({super.key, required this.padding, super.child});

  @override
  fw.RenderObject createRenderObject() => _RenderTerminalPadding(padding);
}

class _RenderTerminalPadding extends fw.RenderSingleChild {
  EdgeInsets padding;
  _RenderTerminalPadding(this.padding);

  @override
  void performLayout(fw.BoxConstraints constraints) {
    final childConstraints = fw.BoxConstraints(
      minWidth: (constraints.minWidth - padding.horizontal).clamp(0, 0x3FFFFFFF),
      maxWidth: (constraints.maxWidth - padding.horizontal).clamp(0, 0x3FFFFFFF),
      minHeight: (constraints.minHeight - padding.vertical).clamp(0, 0x3FFFFFFF),
      maxHeight: (constraints.maxHeight - padding.vertical).clamp(0, 0x3FFFFFFF),
    );
    child?.layout(childConstraints);
    final childW = child?.width ?? 0;
    final childH = child?.height ?? 0;
    final w = (constraints.minWidth > childW + padding.horizontal)
        ? constraints.minWidth
        : childW + padding.horizontal;
    final h = (constraints.minHeight > childH + padding.vertical)
        ? constraints.minHeight
        : childH + padding.vertical;
    setSize(w, h);
    child?.setOffset(padding.left, padding.top);
  }

  @override
  void paint(Buffer buffer, Rect area) {
    paintSelf(buffer, area);
    if (child != null) {
      final childArea = Rect(
        area.x + child!.x,
        area.y + child!.y,
        child!.width,
        child!.height,
      );
      child!.paint(buffer, childArea);
    }
  }

  @override
  void paintSelf(Buffer buffer, Rect area) {}
}

class TerminalBorder extends fw.SingleChildRenderWidget {
  final Style? style;
  const TerminalBorder({super.key, this.style, super.child});

  @override
  fw.RenderObject createRenderObject() => _RenderTerminalBorder(style);
}

class _RenderTerminalBorder extends fw.RenderSingleChild {
  Style? style;
  _RenderTerminalBorder(this.style);

  @override
  void performLayout(fw.BoxConstraints constraints) {
    final childConstraints = fw.BoxConstraints(
      minWidth: (constraints.minWidth - 2).clamp(0, 0x3FFFFFFF),
      maxWidth: (constraints.maxWidth - 2).clamp(0, 0x3FFFFFFF),
      minHeight: (constraints.minHeight - 2).clamp(0, 0x3FFFFFFF),
      maxHeight: (constraints.maxHeight - 2).clamp(0, 0x3FFFFFFF),
    );
    child?.layout(childConstraints);
    final cw = child?.width ?? 0;
    final ch = child?.height ?? 0;
    final w = (cw + 2).clamp(constraints.minWidth, constraints.maxWidth);
    final h = (ch + 2).clamp(constraints.minHeight, constraints.maxHeight);
    setSize(w, h);
    child?.setOffset(1, 1);
  }

  @override
  void paint(Buffer buffer, Rect area) {
    paintSelf(buffer, area);
    if (child != null) {
      final childArea = Rect(
        area.x + child!.x,
        area.y + child!.y,
        child!.width,
        child!.height,
      );
      child!.paint(buffer, childArea);
    }
  }

  @override
  void paintSelf(Buffer buffer, Rect area) {
    final w = area.width;
    final h = area.height;
    if (w < 2 || h < 2) return;
    final effectiveStyle = style ?? Style.empty;

    buffer.setString(area.x, area.y, '┌${'─' * (w - 2)}┐', effectiveStyle);
    buffer.setString(area.x, area.y + h - 1, '└${'─' * (w - 2)}┘', effectiveStyle);
    for (var i = 1; i < h - 1; i++) {
      buffer.setString(area.x, area.y + i, '│', effectiveStyle);
      buffer.setString(area.x + w - 1, area.y + i, '│', effectiveStyle);
    }
  }
}
