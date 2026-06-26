import 'package:dartatui/dartatui.dart';
import 'motus_app.dart';

import 'terminal_text.dart';
import 'layout_fixes.dart';
import 'terminal_button.dart';

class MainMenu extends StatelessWidget {
  final bool isModalAuth;
  final void Function(AppRoute) onNavigate;

  const MainMenu({
    super.key,
    required this.isModalAuth,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TerminalPadding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          TerminalText(
            '🤖 Welcome to Motus CLI',
            style: theme.headingStyle,
          ),
          const SizedBox(sHeight: 1),
          TerminalText(
            'Modal Status: ${isModalAuth ? '✅ Authenticated & Valid' : '❌ Not Authenticated'}',
            style: theme.textStyle,
          ),
          const SizedBox(sHeight: 2),
          TerminalText('What would you like to do? (Tab/Shift+Tab to navigate, Enter to select)', style: theme.textStyle),
          const SizedBox(sHeight: 1),
          TerminalButton(
            label: 'Search & Download Book (Anna\'s Archive)',
            onPressed: () => onNavigate(AppRoute.annasArchive),
          ),
          const SizedBox(sHeight: 1),
          TerminalButton(
            label: 'Create Dataset from PDF/EPUB',
            onPressed: () => onNavigate(AppRoute.datasetGen),
          ),
          const SizedBox(sHeight: 1),
          TerminalButton(
            label: 'Create LoRA Adapter (Modal)',
            onPressed: () => onNavigate(AppRoute.loraTrain),
          ),
          if (!isModalAuth) ...[
            const SizedBox(sHeight: 1),
            TerminalButton(
              label: 'Authenticate with Modal',
              onPressed: () => onNavigate(AppRoute.modalAuth),
            ),
          ],
        ],
      ),
    );
  }
}
