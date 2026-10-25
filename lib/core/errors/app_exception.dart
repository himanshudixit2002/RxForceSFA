class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AppException($code): $message';
}

class SyncException extends AppException {
  const SyncException(super.message, {super.code, super.originalError});
}

class AIParsingException extends AppException {
  const AIParsingException(super.message, {super.code, super.originalError});
}

class OCRException extends AppException {
  const OCRException(super.message, {super.code, super.originalError});
}
