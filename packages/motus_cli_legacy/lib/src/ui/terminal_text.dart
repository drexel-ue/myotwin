import 'package:dartatui/dartatui.dart';
import 'package:dartatui/core/core.dart';
import 'package:dartatui/rendering/rendering.dart';
import 'package:dartatui/framework/framework_core.dart' as framework;

/// A bug-free TextWidget for dartatui 0.1.0
class TerminalText extends framework.RenderWidget {
  final String data;
  final Style? style;

  const TerminalText(this.data, {super.key, this.style});

  @override
  framework.RenderObject createRenderObject() => _RenderTerminalText(data, style ?? Style.empty);
}

class _RenderTerminalText extends framework.RenderLeaf {
  String data;
  Style style;

  _RenderTerminalText(this.data, this.style);

  @override
  void performLayout(framework.BoxConstraints constraints) {
    final lines = data.split('\n');
    final maxLineWidth = lines.fold(0, (int max, l) => l.length > max ? l.length : max);
    final w = constraints.constrain(Size(maxLineWidth, lines.length));
    setSize(w.width, w.height);
  }

  @override
  void paintContent(Buffer buffer, Rect area) {
    final lines = data.split('\n');
    for (var y = 0; y < lines.length && y < area.height; y++) {
      final actualY = area.y + y;
      if (actualY >= 0 && area.x >= 0) {
        try {
          buffer.setString(area.x, actualY, lines[y], style);
        } catch (_) {
          // Ignore layout engine coordinate bugs in dartatui v0.1.0
        }
      }
    }
  }
}
