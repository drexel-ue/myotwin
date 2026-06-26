import 'dart:io';
import 'dart:convert';
import 'package:interact/interact.dart';
import 'package:dotenv/dotenv.dart';
import 'package:motus_cli/src/llm_api.dart';

final env = DotEnv(includePlatformEnvironment: true)..load();

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
      'Create Dataset from PDF/EPUB',
      'Create LoRA Adapter (Modal)',
      if (!isModalAuth) 'Authenticate with Modal',
      'Exit'
    ];

    final selection = Select(
      prompt: 'What would you like to do?',
      options: options,
    ).interact();

    final chosen = options[selection];

    if (chosen == 'Create Dataset from PDF/EPUB') {
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
  final filePath = Input(
    prompt: 'Enter the absolute path to the PDF/EPUB file:',
  ).interact();

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
      final jsonResponse = jsonDecode(process.stdout as String);
      if (jsonResponse['error'] != null) {
          print('❌ Extraction Error: ${jsonResponse['error']}');
          return;
      }
      
      final chunks = List<String>.from(jsonResponse['chunks']);
      print('✅ Successfully extracted ${chunks.length} chunks of text.');
      
      print('⏳ Connecting to Teacher LLM API (Gemini)...');
      
      final apiKey = env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty || apiKey == "your_api_key_here") {
        print('❌ Error: Missing GEMINI_API_KEY in packages/motus_cli/.env');
        print('Please copy packages/motus_cli/.env.example to packages/motus_cli/.env and add your key.');
        return;
      }

      final llmClient = TeacherLlmClient(apiKey);
      final outputFile = File('${file.parent.path}/${file.uri.pathSegments.last.split('.').first}_dataset.jsonl');
      final sink = outputFile.openWrite(mode: FileMode.append);

      int totalExamples = 0;
      for (int i = 0; i < chunks.length; i++) {
        print('🔄 Processing chunk ${i + 1}/${chunks.length}...');
        try {
          final examples = await llmClient.generateDatasetFromChunk(chunks[i]);
          for (var example in examples) {
            sink.writeln(jsonEncode(example));
            totalExamples++;
          }
        } catch (e) {
          print('⚠️ Error on chunk ${i + 1}: $e');
        }
      }

      await sink.close();
      print('🎉 Done! Generated $totalExamples examples.');
      print('💾 Saved to: ${outputFile.path}');

  } catch (e) {
      print('❌ Failed to parse python output: $e');
  }
}

Future<void> _handleLoraTraining() async {
  print('\n--- Create LoRA Adapter ---');
  
  final datasetPath = Input(
    prompt: 'Enter the absolute path to the .jsonl dataset:',
  ).interact();

  final file = File(datasetPath);
  if (!file.existsSync() || !datasetPath.endsWith('.jsonl')) {
    print('❌ Error: Valid .jsonl file not found at $datasetPath');
    return;
  }

  final loraName = Input(
    prompt: 'Enter a name for this LoRA (e.g., anatomy_expert):',
  ).interact();

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
    '--dataset-path', file.path,
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
