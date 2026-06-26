import 'package:dartatui/dartatui.dart';
import 'package:dotenv/dotenv.dart';
import 'package:motus_cli/src/ui/motus_app.dart';
import 'package:motus_cli/src/ui/theme.dart';

final env = DotEnv(includePlatformEnvironment: true)..load(['packages/motus_cli/.env']);

void main(List<String> arguments) {
  runTerminalApp(const MotusApp(), theme: motusTheme);
}
