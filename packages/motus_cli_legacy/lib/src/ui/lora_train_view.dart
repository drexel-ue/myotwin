import 'package:dartatui/dartatui.dart';
import 'terminal_text.dart';
import 'layout_fixes.dart';
import 'terminal_button.dart';

class LoraTrainView extends StatelessWidget {
  final VoidCallback onBack;

  const LoraTrainView({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return TerminalPadding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          TerminalText('Create LoRA Adapter (Modal)'),
          const SizedBox(sHeight: 2),
          TerminalButton(label: 'Back to Menu', onPressed: onBack),
        ],
      ),
    );
  }
}
