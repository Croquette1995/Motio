import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../domain/voice_settings.dart';

/// Enveloppe autour de [FlutterTts]. Toutes les erreurs sont absorbées :
/// la voix ne doit jamais bloquer la session d'apprentissage.
class TtsService {
  final FlutterTts _tts = FlutterTts();

  Future<List<TtsVoice>> voicesFor(String languageCode) async {
    try {
      final raw = await _tts.getVoices;
      if (raw is! List) return [];
      final voices = <TtsVoice>[];
      for (final v in raw) {
        if (v is! Map) continue;
        final name = v['name']?.toString();
        final locale = (v['locale'] ?? '').toString().replaceAll('_', '-');
        if (name == null) continue;
        if (locale.toLowerCase().startsWith(languageCode.toLowerCase())) {
          voices.add(TtsVoice(name: name, locale: locale));
        }
      }
      voices.sort((a, b) => a.name.compareTo(b.name));
      return voices;
    } catch (e) {
      debugPrint('TTS getVoices error: $e');
      return [];
    }
  }

  /// Lit [text] et attend la fin de la lecture (avec un délai de sécurité).
  Future<void> speak(String text, VoiceSettings s) async {
    if (text.trim().isEmpty) return;
    try {
      await _tts.stop();
      await _tts.awaitSpeakCompletion(true);
      await _tts.setLanguage(s.voiceLocale ?? s.language.defaultLocale);
      if (s.voiceName != null && s.voiceLocale != null) {
        await _tts.setVoice({'name': s.voiceName!, 'locale': s.voiceLocale!});
      }
      await _tts.setSpeechRate(s.rate);
      await _tts.setPitch(s.pitch);
      await _tts.setVolume(s.volume);
      await _tts.speak(text).timeout(const Duration(seconds: 20));
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
