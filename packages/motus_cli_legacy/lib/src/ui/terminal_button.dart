import 'package:dartatui/dartatui.dart';
import 'package:dartatui/framework/framework.dart' as fw;

class TerminalButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Style? style;
  final Style? focusedStyle;
  final Style? activeStyle;

  const TerminalButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style,
    this.focusedStyle,
    this.activeStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Focus(
      canFocus: true,
      onKey: (event) {
        if (event.code == KeyCode.enter ||
            (event.code == KeyCode.char && event.charCode == 0x20)) {
          onPressed?.call();
          return true;
        }
        if (event.code == KeyCode.up || event.code == KeyCode.left) {
          FocusManager.instance.previous();
          return true;
        }
        if (event.code == KeyCode.down || event.code == KeyCode.right) {
          FocusManager.instance.next();
          return true;
        }
        return false;
      },
      child: _ButtonRender(
        label: label,
        style: style ?? theme.borderStyle ?? Style.empty,
        focusedStyle: focusedStyle ?? theme.focusedBorderStyle ?? Style(
          fg: Color.cyan,
          addModifier: Modifier.bold,
        ),
        activeStyle: activeStyle ?? Style(
          fg: Color.white,
          bg: Color.blue,
        ),
      ),
    );
  }
}

class _ButtonRender extends fw.SingleChildRenderWidget {
  final String label;
  final Style style;
  final Style focusedStyle;
  final Style activeStyle;

  const _ButtonRender({
    required this.label,
    required this.style,
    required this.focusedStyle,
    required this.activeStyle,
  });

  @override
  fw.RenderObject createRenderObject() => _ButtonRenderObject(
    label: label,
    style: style,
    focusedStyle: focusedStyle,
    activeStyle: activeStyle,
  );
}

class _ButtonRenderObject extends fw.RenderSingleChild {
  String label;
  Style style;
  Style focusedStyle;
  Style activeStyle;

  _ButtonRenderObject({
    required this.label,
    required this.style,
    required this.focusedStyle,
    required this.activeStyle,
  });

  @override
  void performLayout(BoxConstraints constraints) {
    final w = (label.length + 4).clamp(constraints.minWidth, constraints.maxWidth);
    final h = 3.clamp(constraints.minHeight, constraints.maxHeight);
    child?.layout(BoxConstraints.tight(Size(w, h)));
    child?.setOffset(0, 0);
    setSize(w, h);
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
    final x = area.x;
    final y = area.y;
    final w = area.width;
    final h = area.height;
    if (w < 2 || h < 2) return;

    final isFocused = _hasFocusedAncestor();
    final btnStyle = isFocused ? focusedStyle : style;

    try {
      buffer.setString(x, y, '┌${'─' * (w - 2)}┐', btnStyle);
      buffer.setString(x, y + h - 1, '└${'─' * (w - 2)}┘', btnStyle);
      for (var i = 1; i < h - 1; i++) {
        buffer.setString(x, y + i, '│', btnStyle);
        buffer.setString(x + w - 1, y + i, '│', btnStyle);
      }

      final labelX = x + (w - label.length) ~/ 2;
      final labelY = y + (h - 1) ~/ 2;
      if (labelX >= x && labelY >= y && labelX + label.length <= x + w) {
        for (var i = 0; i < w - 2; i++) {
          buffer.setString(x + 1 + i, labelY, ' ', Style.empty);
        }
        buffer.setString(labelX, labelY, label, btnStyle.copyWith(
          addModifier: btnStyle.addModifier.union(Modifier.bold),
        ));
      }
    } catch (_) {
      // Safegaurd against out-of-bounds rendering
    }
  }

  bool _hasFocusedAncestor() {
    fw.RenderObject? current = parent;
    while (current != null) {
      if (current is fw.RenderFocus && current.node.hasFocus) return true;
      current = current.parent;
    }
    return false;
  }
}
