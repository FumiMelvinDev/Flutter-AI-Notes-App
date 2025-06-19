import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  GeminiService();

  Future<String> askAboutNotes({
    required List<Map<String, dynamic>> notes,
    required List<String> newQuestions,
    required List<String> responses,
  }) async {
    final formattedNotes = notes
        .map(
          (note) =>
              '''
      Text: ${note['text']}
      Created at: ${note['createdAt']}
      Last Updated: ${note['updatedAt']}
      '''
                  .trim(),
        )
        .join('\n');

    final systemPrompt =
        '''
You are a helpful assistant that answers questions about a user's notes.
Assume all questions are related to the user's notes.
Make sure that your answers are not too verbose and you speak succinctly.

Your responses MUST be formatted in a clear, concise text message style. Use short paragraphs, bullet points, and numbered lists when helpful. Avoid any HTML tags, markdown, or special formatting—just plain text. Keep your answers easy to read and conversational.

Here are the user's notes:
$formattedNotes
''';

    final List<Map<String, dynamic>> contents = [
      {
        "role": "user",
        "parts": [
          {"text": systemPrompt},
        ],
      },
    ];

    for (int i = 0; i < newQuestions.length; i++) {
      contents.add({
        "role": "user",
        "parts": [
          {"text": newQuestions[i]},
        ],
      });
      if (responses.length > i) {
        contents.add({
          "role": "model",
          "parts": [
            {"text": responses[i]},
          ],
        });
      }
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
    );

    final body = jsonEncode({"contents": contents});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
          'No answer found.';
    } else {
      throw Exception('Gemini API error: ${response.body}');
    }
  }
}
