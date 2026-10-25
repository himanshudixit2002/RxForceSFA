import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused }

class TtsService {
  TtsService._();
  static final instance = TtsService._();

  FlutterTts? _tts;
  TtsState _state = TtsState.stopped;
  final _stateController = StreamController<TtsState>.broadcast();

  Stream<TtsState> get stateStream => _stateController.stream;
  TtsState get state => _state;

  Future<void> _ensureInit() async {
    if (_tts != null) return;
    _tts = FlutterTts();

    if (!kIsWeb) {
      await _tts!.setSharedInstance(true);
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _tts!.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
      }
    }

    await _tts!.setLanguage('en-US');
    await _tts!.setSpeechRate(kIsWeb ? 1.0 : 0.5);
    await _tts!.setVolume(1.0);
    await _tts!.setPitch(1.0);

    _tts!.setStartHandler(() => _setState(TtsState.playing));
    _tts!.setCompletionHandler(() => _setState(TtsState.stopped));
    _tts!.setCancelHandler(() => _setState(TtsState.stopped));
    _tts!.setPauseHandler(() => _setState(TtsState.paused));
    _tts!.setContinueHandler(() => _setState(TtsState.playing));
    _tts!.setErrorHandler((_) => _setState(TtsState.stopped));
  }

  void _setState(TtsState s) {
    _state = s;
    _stateController.add(s);
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    await _ensureInit();
    await _tts!.speak(text);
  }

  Future<void> stop() async {
    await _tts?.stop();
    _setState(TtsState.stopped);
  }

  Future<void> pause() async {
    await _tts?.pause();
  }

  Future<void> dispose() async {
    await stop();
    await _stateController.close();
    _tts = null;
  }
}
