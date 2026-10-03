import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/voice_settings.dart';
import 'tts_service.dart';

final ttsServiceProvider = Provider<TtsService>((ref) => TtsService());

final availableVoicesProvider =
    FutureProvider.family<List<TtsVoice>, String>((ref, languageCode) {
  return ref.read(ttsServiceProvider).voicesFor(languageCode);
});

class VoiceSettingsNotifier extends Notifier<VoiceSettings> {
  static const _kAuto = 'tts_auto';
  static const _kLang = 'tts_lang';
  static const _kVoice = 'tts_voice';
  static const _kLocale = 'tts_locale';
  static const _kRate = 'tts_rate';
  static const _kPitch = 'tts_pitch';
  static const _kVolume = 'tts_volume';

  @override
  VoiceSettings build() {
    _load();
    return const VoiceSettings();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = VoiceSettings(
      autoPlay: p.getBool(_kAuto) ?? true,
      languageCode: p.getString(_kLang) ?? 'en',
      voiceName: p.getString(_kVoice),
      voiceLocale: p.getString(_kLocale),
      rate: p.getDouble(_kRate) ?? 0.5,
      pitch: p.getDouble(_kPitch) ?? 1.0,
      volume: p.getDouble(_kVolume) ?? 1.0,
    );
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kAuto, state.autoPlay);
    await p.setString(_kLang, state.languageCode);
    if (state.voiceName == null) {
      await p.remove(_kVoice);
      await p.remove(_kLocale);
    } else {
      await p.setString(_kVoice, state.voiceName!);
      await p.setString(_kLocale, state.voiceLocale ?? '');
    }
    await p.setDouble(_kRate, state.rate);
    await p.setDouble(_kPitch, state.pitch);
    await p.setDouble(_kVolume, state.volume);
  }

  void _update(VoiceSettings s) {
    state = s;
    _save();
  }

  void setAutoPlay(bool v) => _update(state.copyWith(autoPlay: v));
  void setLanguage(String code) =>
      _update(state.copyWith(languageCode: code, clearVoice: true));
  void setVoice(TtsVoice? v) => _update(v == null
      ? state.copyWith(clearVoice: true)
      : state.copyWith(voiceName: v.name, voiceLocale: v.locale));
  void setRate(double v) => _update(state.copyWith(rate: v));
  void setPitch(double v) => _update(state.copyWith(pitch: v));
  void setVolume(double v) => _update(state.copyWith(volume: v));

  /// Lit un texte avec les réglages courants (aperçu ou carte).
  Future<void> speak(String text, {VoiceSettings? override}) =>
      ref.read(ttsServiceProvider).speak(text, override ?? state);
}

final voiceSettingsProvider =
    NotifierProvider<VoiceSettingsNotifier, VoiceSettings>(VoiceSettingsNotifier.new);
