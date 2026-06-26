import 'dart:convert';
import 'package:http/http.dart' as http;

class TeacherLlmClient {
  final String apiKey;
  // Use Gemini 2.5 Flash as the default Teacher Model (faster and cheaper for bulk generation)
  final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  TeacherLlmClient(this.apiKey);

  Future<List<Map<String, dynamic>>> generateDatasetFromChunk(String textChunk) async {
    final systemInstruction = '''
You are a Dataset Generator. You extract physical therapy and rehab knowledge from the provided textbook chunk and convert it into synthetic conversation examples.
Output strictly a JSON array of conversational objects. Each object should have a "messages" array representing the conversation, ending with a tool call.

Example output format:
[
  {
    "messages": [
      {"role": "system", "content": "You are Motus, an AI physical therapist..."},
      {"role": "user", "content": "I have shoulder impingement, it hurts when I lift my arm."},
      {
        "role": "assistant",
        "content": "I've generated a rehab protocol for shoulder impingement based on your symptoms.",
        "tool_calls": [
          {
            "id": "call_rehab_1",
            "type": "function",
            "function": {
              "name": "generate_workout_protocol",
              "arguments": "{\\"exercises\\":[\\"Wall Slides\\",\\"Scapular Retractions\\"],\\"intensity\\":\\"low\\"}"
            }
          }
        ]
      }
    ]
  }
]

Generate 3 to 5 realistic examples based ONLY on the clinical information in the text chunk below. Return ONLY the raw JSON array.
''';

    final response = await http.post(
      Uri.parse('$baseUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "systemInstruction": {
          "parts": [{"text": systemInstruction}]
        },
        "contents": [
          {
            "parts": [
              {"text": "Textbook Chunk:\\n\\n$textChunk"}
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.2,
          "responseMimeType": "application/json"
        }
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to generate content: ${response.body}');
    }

    final data = jsonDecode(response.body);
    try {
      final textResponse = data['candidates'][0]['content']['parts'][0]['text'] as String;
      final parsedArray = jsonDecode(textResponse) as List<dynamic>;
      return parsedArray.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to parse Teacher LLM output. Model may not have returned strict JSON.\\nError: $e');
    }
  }
}
