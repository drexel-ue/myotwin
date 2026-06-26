import 'dart:io';
import 'dart:convert';
import 'package:interact/interact.dart';
import 'package:dotenv/dotenv.dart';
import 'package:motus_cli/src/llm_api.dart';
import 'package:motus_cli/src/annas_archive_workflow.dart';
import 'package:motus_cli/src/menu_utils.dart';

final env = DotEnv(includePlatformEnvironment: true)..load(['packages/motus_cli/.env']);

void main(List<String> arguments) async {
  print('\n⏳ Checking Modal authentication status...');
  final pythonPath = 'packages/motus_cli/.venv/bin/python';
  bool isModalAuth = false;
  
  if (File(pythonPath).existsSync()) {
    final authCheck = await Process.run(pythonPath, ['-m', 'modal', 'token', 'info']);
    isModalAuth = authCheck.exitCode == 0;
  }

  while (true) {
    print('\n🤖 Welcome to Motus CLI');
    print('========================');
    print('Modal Status: ${isModalAuth ? '✅ Authenticated & Valid' : '❌ Not Authenticated or Invalid'}');
    print('========================\n');

    final options = [
      'Search & Download Book (Anna\'s Archive)',
      'Create Dataset from PDF/EPUB',
      'Create LoRA Adapter (Modal)',
      if (!isModalAuth) 'Authenticate with Modal',
      'Exit'
    ];

    final selection = promptSelect(
      'What would you like to do?',
      options,
    );

    final chosen = options[selection];

    if (chosen == 'Search & Download Book (Anna\'s Archive)') {
      await runAnnasArchiveWorkflow();
    } else if (chosen == 'Create Dataset from PDF/EPUB') {
      await _handleDatasetGeneration();
    } else if (chosen == 'Create LoRA Adapter (Modal)') {
      await _handleLoraTraining();
    } else if (chosen == 'Authenticate with Modal') {
      await _handleModalAuth();
      // Re-verify after auth attempt
      if (File(pythonPath).existsSync()) {
        print('⏳ Verifying new token...');
        final authCheck = await Process.run(pythonPath, ['-m', 'modal', 'token', 'info']);
        isModalAuth = authCheck.exitCode == 0;
      }
    } else if (chosen == 'Exit') {
      print('Exiting...');
      exit(0);
    }
    print('\n');
  }
}

Future<void> _handleModalAuth() async {
  print('\n--- Authenticate with Modal ---');
  final pythonPath = 'packages/motus_cli/.venv/bin/python';
  if (!File(pythonPath).existsSync()) {
      print('❌ Error: Python virtual environment not found at $pythonPath');
      return;
  }
  
  print('Launching Modal authentication...');
  final process = await Process.start(
    pythonPath, 
    ['-m', 'modal', 'token', 'new'],
    mode: ProcessStartMode.inheritStdio
  );
  
  await process.exitCode;
  print('\n✅ Authentication check complete.');
}

Future<void> _handleDatasetGeneration() async {
  print('\n--- Create Dataset ---');
  
  var apiKey = env['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.isEmpty || apiKey == "your_api_key_here") {
    print('\n⚠️ Missing GEMINI_API_KEY.');
    print('The Motus CLI uses Google Gemini (the "Teacher Model") to read your PDF');
    print('and intelligently format it into a high-quality .jsonl dataset for training.');
    print('You can get a free API key here: https://aistudio.google.com/app/apikey\n');
    
    apiKey = Input(
      prompt: 'Please enter your Gemini API Key:',
    ).interact();
    
    final envFile = File('packages/motus_cli/.env');
    if (!envFile.existsSync()) {
      final exampleFile = File('packages/motus_cli/.env.example');
      if (exampleFile.existsSync()) {
        exampleFile.copySync(envFile.path);
      } else {
        envFile.createSync();
      }
    }
    
    var envContent = envFile.readAsStringSync();
    if (envContent.contains('GEMINI_API_KEY=')) {
      envContent = envContent.replaceAll(RegExp(r'GEMINI_API_KEY=.*'), 'GEMINI_API_KEY=$apiKey');
    } else {
      if (envContent.isNotEmpty && !envContent.endsWith('\n')) envContent += '\n';
      envContent += 'GEMINI_API_KEY=$apiKey\n';
    }
    
    envFile.writeAsStringSync(envContent);
    print('✅ Saved GEMINI_API_KEY to packages/motus_cli/.env\n');
  }

  final booksDir = Directory('packages/motus_cli/data/books');
  final downloadedBooks = booksDir.existsSync() ? booksDir.listSync().whereType<File>().where((e) => !e.path.endsWith('.DS_Store')).toList() : <File>[];
  
  String? filePath;
  if (downloadedBooks.isNotEmpty) {
    final options = ['Paste absolute path', ...downloadedBooks.map((e) => e.path.split('/').last)];
    final selection = promptSelect(
      'Select a downloaded book or paste a path:',
      options,
    );
    
    if (selection == 0) {
      stdout.write('? Enter the absolute path to the PDF/EPUB file: ');
      filePath = stdin.readLineSync();
    } else {
      filePath = downloadedBooks[selection - 1].path;
    }
  } else {
    stdout.write('? Enter the absolute path to the PDF/EPUB file: ');
    filePath = stdin.readLineSync();
  }
  
  if (filePath == null || filePath.trim().isEmpty) return;
  
  filePath = filePath.trim();
  // macOS drag-and-drop wraps paths with spaces in single quotes
  if (filePath.startsWith("'") && filePath.endsWith("'")) {
    filePath = filePath.substring(1, filePath.length - 1);
  } else if (filePath.startsWith("'") && !filePath.endsWith("'")) {
    // If the string was cutoff or user only pasted part of it
    filePath = filePath.substring(1);
  }

  final file = File(filePath);
  if (!file.existsSync()) {
    print('❌ Error: File not found at $filePath');
    return;
  }

  print('📄 Extracting text using PyMuPDF...');
  // Find the path to the python script relative to the execution context
  // Assuming the user runs this from the myotwin workspace root
  final scriptPath = 'packages/motus_cli/lib/src/python/extract_pdf.py';
  final pythonPath = 'packages/motus_cli/.venv/bin/python';
  
  if (!File(scriptPath).existsSync()) {
      print('❌ Error: Python script not found at $scriptPath');
      print('Ensure you are running the CLI from the workspace root: dart run packages/motus_cli/bin/motus_cli.dart');
      return;
  }
  
  if (!File(pythonPath).existsSync()) {
      print('❌ Error: Python virtual environment not found at $pythonPath');
      print('Please run ./bootstrap.sh from the workspace root to create the environment.');
      return;
  }

  final process = await Process.run(pythonPath, [scriptPath, '--pdf', file.path]);
  
  if (process.exitCode != 0) {
      print('❌ Python Error:\n${process.stderr}');
      return;
  }

  try {
      final stdoutStr = process.stdout as String;
      final startIndex = stdoutStr.indexOf('{');
      final endIndex = stdoutStr.lastIndexOf('}');
      
      if (startIndex == -1 || endIndex == -1) {
          print('❌ Extraction Error: Could not find JSON response in python output:');
          print(stdoutStr);
          return;
      }
      
      final jsonStr = stdoutStr.substring(startIndex, endIndex + 1);
      final jsonResponse = jsonDecode(jsonStr);
      
      if (jsonResponse['error'] != null) {
          print('❌ Extraction Error: ${jsonResponse['error']}');
          return;
      }
      
      final chunks = List<String>.from(jsonResponse['chunks']);
      print('✅ Successfully extracted ${chunks.length} chunks of text.');
      
      print('⏳ Connecting to Teacher LLM API (Gemini)...');
      
      final useDelay = Confirm(
        prompt: 'Apply a 4-second delay between chunks to respect the Free Tier rate limit (15 RPM)?',
        defaultValue: true,
      ).interact();
      
      if (useDelay) {
        print('ℹ️  You can check your current quota at: https://aistudio.google.com/app/rate-limit\n');
      } else {
        print('\n🚀 Running without delay. Warning: You may hit 429 Too Many Requests if you are on the free tier.\n');
      }
      
      final llmClient = TeacherLlmClient(apiKey);
      final outputFile = File('${file.parent.path}/${file.uri.pathSegments.last.split('.').first}_dataset.jsonl');
      final sink = outputFile.openWrite(mode: FileMode.append);

      int totalExamples = 0;
      for (int i = 0; i < chunks.length; i++) {
        print('🔄 Processing chunk ${i + 1}/${chunks.length}...');
        
        int retries = 0;
        bool success = false;
        
        while (!success && retries < 5) {
          try {
            final examples = await llmClient.generateDatasetFromChunk(chunks[i]);
            for (var example in examples) {
              sink.writeln(jsonEncode(example));
              totalExamples++;
            }
            success = true;
            
            if (useDelay && i < chunks.length - 1) {
              await Future.delayed(Duration(seconds: 4));
            }
          } catch (e) {
            retries++;
            print('⚠️ Error on chunk ${i + 1} (Attempt $retries/5): $e');
            if (retries >= 5) {
              print('❌ Skipping chunk ${i + 1} after 5 failed attempts.');
            } else {
              int backoffSeconds = 4 * retries; // 4s, 8s, 12s, 16s...
              print('⏳ API busy or rate limited. Retrying in $backoffSeconds seconds...');
              await Future.delayed(Duration(seconds: backoffSeconds));
            }
          }
        }
      }

      await sink.close();
      print('🎉 Done! Generated $totalExamples examples.');
      print('💾 Saved to: ${outputFile.path}');
      
      // Copy to library
      final datasetsDir = Directory('packages/motus_cli/data/datasets');
      if (!datasetsDir.existsSync()) {
        datasetsDir.createSync(recursive: true);
      }
      final copiedFile = outputFile.copySync('${datasetsDir.path}/${outputFile.uri.pathSegments.last}');
      print('📚 Added to dataset library: ${copiedFile.path}');

  } catch (e) {
      print('❌ Failed to parse python output: $e');
  }
}

Future<void> _handleLoraTraining() async {
  print('\n--- Create LoRA Adapter ---');
  
  final datasetsDir = Directory('packages/motus_cli/data/datasets');
  if (!datasetsDir.existsSync()) {
    datasetsDir.createSync(recursive: true);
  }
  
  final datasetFiles = datasetsDir.listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.jsonl'))
      .toList();
      
  List<String> datasetPaths = [];
  
  if (datasetFiles.isEmpty) {
    stdout.write('? Enter absolute paths to .jsonl datasets (comma-separated): ');
    final input = stdin.readLineSync();
    if (input == null || input.trim().isEmpty) return;
    datasetPaths = input.split(',').map((e) => e.trim()).toList();
  } else {
    final datasetOptions = [
      ...datasetFiles.map((f) => f.uri.pathSegments.last),
      'Paste Absolute Path(s)...'
    ];
    
    final dsSelection = promptMultiSelect(
      'Select datasets to include:',
      datasetOptions,
    );
    
    if (dsSelection.isEmpty) {
      print('❌ No datasets selected.');
      return;
    }

    if (dsSelection.contains(datasetOptions.length - 1)) {
      stdout.write('? Enter absolute paths to .jsonl datasets (comma-separated): ');
      final input = stdin.readLineSync();
      if (input != null && input.trim().isNotEmpty) {
        datasetPaths.addAll(input.split(',').map((e) => e.trim()));
      }
    }
    
    for (var idx in dsSelection) {
      if (idx != datasetOptions.length - 1) {
        datasetPaths.add(datasetFiles[idx].path);
      }
    }
  }
  
  if (datasetPaths.isEmpty) return;

  // Clean paths
  datasetPaths = datasetPaths.map((p) {
    var clean = p;
    if (clean.startsWith("'") && clean.endsWith("'")) {
      clean = clean.substring(1, clean.length - 1);
    } else if (clean.startsWith("'") && !clean.endsWith("'")) {
      clean = clean.substring(1);
    }
    return clean;
  }).toList();

  final validFiles = <File>[];
  for (var p in datasetPaths) {
    final f = File(p);
    if (!f.existsSync() || !p.endsWith('.jsonl')) {
      print('⚠️ Warning: Valid .jsonl file not found at $p. Skipping.');
    } else {
      validFiles.add(f);
      if (!p.contains('packages/motus_cli/data/datasets')) {
        try {
          f.copySync('${datasetsDir.path}/${f.uri.pathSegments.last}');
          print('📚 Added $p to dataset library for future use.');
        } catch (_) {}
      }
    }
  }

  if (validFiles.isEmpty) {
    print('❌ Error: No valid datasets provided.');
    return;
  }

  File finalDatasetFile;
  if (validFiles.length == 1) {
    finalDatasetFile = validFiles.first;
    print('📚 Using dataset: ${finalDatasetFile.path}');
  } else {
    final mergedPath = '${datasetsDir.path}/merged_${DateTime.now().millisecondsSinceEpoch}.jsonl';
    finalDatasetFile = File(mergedPath);
    final sink = finalDatasetFile.openWrite();
    for (var f in validFiles) {
      sink.write(f.readAsStringSync());
      if (!f.readAsStringSync().endsWith('\n')) {
        sink.writeln();
      }
    }
    await sink.close();
    print('📚 Combined ${validFiles.length} datasets into: $mergedPath');
  }

  final historyFile = File('packages/motus_cli/data/history.json');
  List<String> historyNames = [];
  if (historyFile.existsSync()) {
    try {
      final json = jsonDecode(historyFile.readAsStringSync());
      if (json is List) {
        historyNames = List<String>.from(json);
      }
    } catch (_) {}
  }
  
  String loraName = '';
  if (historyNames.isEmpty) {
    loraName = Input(
      prompt: 'Enter a name for this LoRA (e.g., anatomy_expert):',
    ).interact();
  } else {
    final nameOptions = [
      ...historyNames,
      'Create New Name...'
    ];
    
    final nameSelection = promptSelect(
      'Select a LoRA name:',
      nameOptions,
    );
    
    if (nameSelection == nameOptions.length - 1) {
      loraName = Input(
        prompt: 'Enter a new name for this LoRA (e.g., anatomy_expert):',
      ).interact();
    } else {
      loraName = historyNames[nameSelection];
    }
  }
  
  loraName = loraName.trim();
  if (loraName.isEmpty) return;
  
  // Save to history
  if (!historyNames.contains(loraName)) {
    if (!historyFile.parent.existsSync()) {
      historyFile.parent.createSync(recursive: true);
    }
    historyNames.add(loraName);
    historyFile.writeAsStringSync(jsonEncode(historyNames));
  }

  print('🚀 Triggering Modal Cloud Training...');
  print('This will spin up an A10G GPU, train the model, and export the GGUF.');
  
  final pythonPath = 'packages/motus_cli/.venv/bin/python';
  final scriptPath = 'packages/motus_cli/lib/src/python/train_lora_modal.py';
  
  if (!File(pythonPath).existsSync()) {
      print('❌ Error: Python virtual environment not found at $pythonPath');
      return;
  }

  // We use python -m modal run to ensure it uses the venv's modal installation
  final process = await Process.start(pythonPath, [
    '-m', 'modal', 'run', scriptPath,
    '--dataset-path', finalDatasetFile.path,
    '--lora-name', loraName
  ]);

  // Stream stdout and stderr so the user can see Modal's progress
  process.stdout.transform(utf8.decoder).listen((data) => stdout.write(data));
  process.stderr.transform(utf8.decoder).listen((data) => stderr.write(data));

  final exitCode = await process.exitCode;
  
  if (exitCode == 0) {
      print('\n✅ Cloud Training Complete!');
      print('To download your LoRA to the server assets, run:');
      print('packages/motus_cli/.venv/bin/python -m modal volume get motus-models ${loraName}_lora-unsloth.Q4_K_M.gguf packages/motus_server/assets/models/');
  } else {
      print('\n❌ Cloud Training Failed with exit code $exitCode');
  }
}
