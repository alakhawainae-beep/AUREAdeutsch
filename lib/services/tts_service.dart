import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._() {
    _tts.setLanguage('de-DE');
    _tts.setSpeechRate(0.42);
    _tts.setVolume(1);
    _tts.setPitch(1);
  }

  static final TtsService instance = TtsService._();
  final FlutterTts _tts = FlutterTts();

  Future<void> speakGerman(String text) async {
    await _tts.stop();
    await _tts.setLanguage('de-DE');
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();
}
