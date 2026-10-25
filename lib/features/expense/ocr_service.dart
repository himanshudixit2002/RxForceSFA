import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../core/errors/app_exception.dart';

class OcrResult {
  final double? amount;
  final DateTime? date;
  final String rawText;

  const OcrResult({this.amount, this.date, required this.rawText});
}

class OcrService {
  final _recognizer = TextRecognizer();

  Future<OcrResult> extractFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFile(File(imagePath));
      final recognized = await _recognizer.processImage(inputImage);
      final fullText = recognized.text;

      return OcrResult(
        amount: _extractAmount(fullText),
        date: _extractDate(fullText),
        rawText: fullText,
      );
    } catch (e) {
      throw OCRException('Failed to process receipt image', originalError: e);
    }
  }

  double? _extractAmount(String text) {
    // Look for patterns like "Total: 450.00", "TOTAL Rs. 1,234.56", "Grand Total ₹ 500"
    final patterns = [
      RegExp(
        r'(?:grand\s*)?total\s*[:\s]*[₹Rs.]*\s*([\d,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(
        r'(?:amount|amt)\s*[:\s]*[₹Rs.]*\s*([\d,]+\.?\d*)',
        caseSensitive: false,
      ),
      RegExp(r'[₹]\s*([\d,]+\.?\d*)'),
      RegExp(r'Rs\.?\s*([\d,]+\.?\d*)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final raw = match.group(1)?.replaceAll(',', '');
        if (raw != null) {
          final value = double.tryParse(raw);
          if (value != null && value > 0) return value;
        }
      }
    }
    return null;
  }

  DateTime? _extractDate(String text) {
    final patterns = [
      // dd/mm/yyyy or dd-mm-yyyy
      RegExp(r'(\d{1,2})[/\-](\d{1,2})[/\-](\d{2,4})'),
      // yyyy-mm-dd
      RegExp(r'(\d{4})-(\d{2})-(\d{2})'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          if (match.group(1)!.length == 4) {
            final parsed = DateTime.tryParse(
              '${match.group(1)}-${match.group(2)}-${match.group(3)}',
            );
            if (parsed != null && !parsed.isAfter(DateTime.now())) {
              return parsed;
            }
            continue;
          }
          final day = int.parse(match.group(1)!);
          final month = int.parse(match.group(2)!);
          var year = int.parse(match.group(3)!);
          if (year < 100) {
            final currentCentury = DateTime.now().year ~/ 100 * 100;
            year += currentCentury;
            if (year > DateTime.now().year) year -= 100;
          }
          if (day >= 1 && day <= 31 && month >= 1 && month <= 12) {
            try {
              final date = DateTime(year, month, day);
              if (date.month == month &&
                  date.day == day &&
                  !date.isAfter(DateTime.now())) {
                return date;
              }
            } catch (_) {}
          }
        } catch (_) {}
      }
    }
    return null;
  }

  void dispose() {
    _recognizer.close();
  }
}
