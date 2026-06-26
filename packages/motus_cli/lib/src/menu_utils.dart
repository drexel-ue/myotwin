import 'dart:io';

int promptSelect(String prompt, List<String> options) {
  while (true) {
    print('\n$prompt');
    for (int i = 0; i < options.length; i++) {
      print('  ${i + 1}) ${options[i]}');
    }
    stdout.write('\nSelect an option (1-${options.length}): ');
    final input = stdin.readLineSync();
    if (input == null) exit(0);
    final choice = int.tryParse(input.trim());
    if (choice != null && choice >= 1 && choice <= options.length) {
      return choice - 1;
    }
    print('❌ Invalid selection. Please try again.');
  }
}

List<int> promptMultiSelect(String prompt, List<String> options) {
  while (true) {
    print('\n$prompt');
    for (int i = 0; i < options.length; i++) {
      print('  ${i + 1}) ${options[i]}');
    }
    stdout.write('\nSelect options by number (comma-separated, e.g. 1,3) or press Enter to skip: ');
    final input = stdin.readLineSync();
    if (input == null) exit(0);
    if (input.trim().isEmpty) return [];
    
    final parts = input.split(',');
    final selections = <int>[];
    bool valid = true;
    
    for (final part in parts) {
      final choice = int.tryParse(part.trim());
      if (choice != null && choice >= 1 && choice <= options.length) {
        selections.add(choice - 1);
      } else {
        valid = false;
        break;
      }
    }
    
    if (valid) return selections;
    print('❌ Invalid selection format. Please try again.');
  }
}
