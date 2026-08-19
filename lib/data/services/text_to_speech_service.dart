import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  TextToSpeechService() : _tts = FlutterTts();

  final FlutterTts _tts;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  Future<bool> speak(String text, {VoidCallback? onComplete}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;

    try {
      await initialize();
      await _tts.stop();

      if (onComplete != null) {
        _tts.setCompletionHandler(onComplete);
      } else {
        _tts.setCompletionHandler(() {});
      }

      final result = await _tts.speak(trimmed);
      return result == 1;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('TextToSpeechService.speak failed: $e');
      }
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
