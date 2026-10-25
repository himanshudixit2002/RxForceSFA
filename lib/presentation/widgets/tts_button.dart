import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/tts_service.dart';

class TtsButton extends StatefulWidget {
  final String text;
  final double? iconSize;
  final String? tooltip;

  const TtsButton({
    super.key,
    required this.text,
    this.iconSize,
    this.tooltip,
  });

  @override
  State<TtsButton> createState() => _TtsButtonState();
}

class _TtsButtonState extends State<TtsButton> {
  final _tts = TtsService.instance;
  late StreamSubscription<TtsState> _sub;
  TtsState _state = TtsState.stopped;

  @override
  void initState() {
    super.initState();
    _state = _tts.state;
    _sub = _tts.stateStream.listen((s) {
      if (mounted) setState(() => _state = s);
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_state == TtsState.playing) {
      await _tts.stop();
    } else {
      await _tts.speak(widget.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _state == TtsState.playing;
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          isPlaying ? Icons.stop_circle_outlined : Icons.volume_up_rounded,
          key: ValueKey(isPlaying),
          color: isPlaying
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
        ),
      ),
      iconSize: widget.iconSize ?? 24,
      tooltip: widget.tooltip ?? (isPlaying ? 'Stop reading' : 'Read aloud'),
      onPressed: _toggle,
    );
  }
}
