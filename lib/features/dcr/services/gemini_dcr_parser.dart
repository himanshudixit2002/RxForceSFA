import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/errors/app_exception.dart';

class ParsedDcr {
  final String doctorName;
  final List<String> productsDiscussed;
  final DateTime? followUpDate;

  const ParsedDcr({
    required this.doctorName,
    required this.productsDiscussed,
    this.followUpDate,
  });
}

class GeminiDcrParser {
  final GenerativeModel _model;

  GeminiDcrParser({required String apiKey})
    : _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
        systemInstruction: Content.system(
          'You are a medical sales call report parser. '
          'Extract Doctor Name, Products Discussed, and Follow-up Date '
          'from a medical representative\'s spoken report. '
          'Return ONLY a valid JSON object with these exact keys: '
          '"doctorName" (string), '
          '"productsDiscussed" (array of strings), '
          '"followUpDate" (ISO 8601 date string or null). '
          'Do not include any other text, explanation, or markdown.',
        ),
      );

  Future<ParsedDcr> parse(String transcript) async {
    if (transcript.trim().isEmpty) {
      throw const AIParsingException('Empty transcript');
    }

    try {
      final response = await _model.generateContent([Content.text(transcript)]);

      final text = response.text;
      if (text == null || text.isEmpty) {
        throw const AIParsingException('Empty response from Gemini');
      }

      final cleaned = _extractJson(text);
      final json = jsonDecode(cleaned) as Map<String, dynamic>;

      return ParsedDcr(
        doctorName: json['doctorName'] as String? ?? '',
        productsDiscussed:
            (json['productsDiscussed'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        followUpDate: json['followUpDate'] != null
            ? DateTime.tryParse(json['followUpDate'] as String)
            : null,
      );
    } on FormatException catch (e) {
      throw AIParsingException('Failed to parse AI response', originalError: e);
    } on GenerativeAIException catch (e) {
      throw AIParsingException('Gemini API error', originalError: e);
    }
  }

  /// Strip markdown fences if the model wraps the JSON in ```json ... ```
  String _extractJson(String text) {
    var result = text.trim();
    if (result.startsWith('```')) {
      final firstNewline = result.indexOf('\n');
      if (firstNewline != -1) {
        result = result.substring(firstNewline + 1);
      }
      if (result.endsWith('```')) {
        result = result.substring(0, result.length - 3);
      }
    }
    return result.trim();
  }
}
