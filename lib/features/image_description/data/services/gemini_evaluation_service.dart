import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:duolingo_test_app/features/image_description/domain/entities/evaluation_result.dart';
import 'package:duolingo_test_app/features/image_description/domain/services/i_evaluation_service.dart';

const _prompt = '''
You are a language assessment AI for a Duolingo-style speaking exercise.

The user was shown the attached image and had 30 seconds to describe it out loud.
The attached audio contains their spoken response (AAC format).

Return ONLY a valid JSON object — no markdown, no code fences, no explanation:

{
  "score": <integer 0–100>,
  "transcript": "<verbatim transcription of what the user said>",
  "suggestion": "<one concise, actionable improvement tip>"
}

Scoring guidelines:
- 85–100: Detailed, fluent description covering people, objects, setting, and mood
- 65–84: Good description with minor gaps or fluency issues
- 40–64: Partial description, limited vocabulary or structure
- 0–39: Very brief, incoherent, or off-topic

If no speech is detected in the audio, return:
{"score": 0, "transcript": "", "suggestion": "No speech detected. Try describing the image out loud."}
''';

String _cleanJson(String text) {
  final trimmed = text.trim();
  if (trimmed.startsWith('```')) {
    return trimmed
        .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
        .replaceFirst(RegExp(r'\s*```$'), '')
        .trim();
  }
  return trimmed;
}

class GeminiEvaluationService implements IEvaluationService {
  GeminiEvaluationService({required String apiKey}) : _apiKey = apiKey;

  final String _apiKey;

  static const _model = 'gemini-2.0-flash';
  static const _endpoint =
      'https://generativelanguage.googleapis.com/v1/models/$_model:generateContent';

  @override
  Future<EvaluationResult> evaluate({
    required Uint8List audioBytes,
    required Uint8List imageBytes,
  }) async {
    final imageBase64 = base64Encode(imageBytes);
    final audioBase64 = base64Encode(audioBytes);

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': _prompt},
            {
              'inline_data': {'mime_type': 'image/jpeg', 'data': imageBase64},
            },
            {
              'inline_data': {'mime_type': 'audio/aac', 'data': audioBase64},
            },
          ],
        },
      ],
    });

    try {
      final response = await http.post(
        Uri.parse('$_endpoint?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) {
        debugPrint('[Gemini] HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Gemini API error ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final text =
          json['candidates'][0]['content']['parts'][0]['text'] as String;

      debugPrint('[Gemini] raw response: $text');

      final result = jsonDecode(_cleanJson(text)) as Map<String, dynamic>;

      return EvaluationResult(
        score: (result['score'] as num).toInt(),
        transcript: result['transcript'] as String,
        suggestion: result['suggestion'] as String,
      );
    } on FormatException catch (e) {
      debugPrint('[Gemini] parse error: $e');
      throw Exception('Failed to parse Gemini response: $e');
    } catch (e) {
      debugPrint('[Gemini] error: $e');
      throw Exception('Evaluation failed: $e');
    }
  }
}
