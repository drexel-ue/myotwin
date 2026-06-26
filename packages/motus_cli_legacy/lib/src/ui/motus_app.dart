import 'dart:io';
import 'package:dartatui/dartatui.dart';

import 'main_menu.dart';
import 'annas_archive_view.dart';
import 'dataset_gen_view.dart';
import 'lora_train_view.dart';
import 'terminal_text.dart';
import 'layout_fixes.dart';

enum AppRoute {
  mainMenu,
  annasArchive,
  datasetGen,
  loraTrain,
  modalAuth,
}

class MotusApp extends StatefulWidget {
  const MotusApp({super.key});

  @override
  State<MotusApp> createState() => _MotusAppState();
}

class _MotusAppState extends State<MotusApp> {
  AppRoute _currentRoute = AppRoute.mainMenu;
  bool _isModalAuth = false;

  @override
  void initState() {
    super.initState();
    _checkModalAuth();
  }

  Future<void> _checkModalAuth() async {
    final pythonPath = 'packages/motus_cli/.venv/bin/python';
    if (File(pythonPath).existsSync()) {
      final process = await Process.run(pythonPath, ['-m', 'modal', 'token', 'info']);
      setState(() {
        _isModalAuth = process.exitCode == 0;
      });
    }
  }

  void _navigate(AppRoute route) {
    setState(() {
      _currentRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (_currentRoute) {
      case AppRoute.mainMenu:
        child = MainMenu(
          isModalAuth: _isModalAuth,
          onNavigate: _navigate,
        );
        break;
      case AppRoute.annasArchive:
        child = AnnasArchiveView(
          onBack: () => _navigate(AppRoute.mainMenu),
        );
        break;
      case AppRoute.datasetGen:
        child = DatasetGenView(
          onBack: () => _navigate(AppRoute.mainMenu),
        );
        break;
      case AppRoute.loraTrain:
        child = LoraTrainView(
          onBack: () => _navigate(AppRoute.mainMenu),
        );
        break;
      case AppRoute.modalAuth:
        // Modal Auth is a procedural blocking flow that might pop out of TUI
        // But for now, we just show a message.
        child = const TerminalText('Modal Auth Flow coming soon...');
        break;
    }

    return TerminalBorder(
      style: Theme.of(context).borderStyle,
      child: child,
    );
  }
}
