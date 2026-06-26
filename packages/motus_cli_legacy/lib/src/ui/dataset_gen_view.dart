import 'package:dartatui/dartatui.dart';
import 'terminal_text.dart';
import 'layout_fixes.dart';
import 'terminal_button.dart';

class DatasetGenView extends StatelessWidget {
  final VoidCallback onBack;

  const DatasetGenView({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return TerminalPadding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          TerminalText('Create Dataset from PDF/EPUB'),
          const SizedBox(sHeight: 2),
          TerminalButton(label: 'Back to Menu', onPressed: onBack),
        ],
      ),
    );
  }
}
