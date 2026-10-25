import 'dart:async';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;

  final _transcriptController = StreamController<String>.broadcast();
  Stream<String> get transcriptStream => _transcriptController.stream;

  String _fullTranscript = '';
  String get fullTranscript => _fullTranscript;

  bool get isListening => _speech.isListening;
  bool get isAvailable => _isInitialized;

  Future<bool> initialize() async {
    _isInitialized = await _speech.initialize(
      onError: (error) => _transcriptController.addError(error.errorMsg),
    );
    return _isInitialized;
  }

  Future<void> startListening() async {
    if (_speech.isListening) return;
    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) throw Exception('Speech recognition not available');
    }

    _fullTranscript = '';
    await _speech.listen(
      onResult: _onResult,
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 10),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  void _onResult(SpeechRecognitionResult result) {
    _fullTranscript = result.recognizedWords;
    _transcriptController.add(_fullTranscript);
  }

  Future<void> stopListening() async {
    if (!_speech.isListening) return;
    await _speech.stop();
  }

  void dispose() {
    _speech.stop();
    _transcriptController.close();
  }
}
