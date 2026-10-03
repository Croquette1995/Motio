/// Voix de synthèse disponible sur l'appareil.
class TtsVoice {
  final String name;
  final String locale;

  const TtsVoice({required this.name, required this.locale});

  /// Déduction approximative du genre à partir du nom (non fiable selon les moteurs).
  VoiceGender get gender {
    final n = name.toLowerCase();
    const female = ['female', 'woman', 'fem', 'zira', 'samantha', 'karen', 'victoria', 'susan', 'hazel', 'serena', 'moira', 'tessa', 'fiona', 'allison', 'ava', 'jenny', 'aria', '-sfg', '-iob', '-iog', '-tpc', '-tpf'];
    const male = ['male', 'man', 'david', 'mark', 'alex', 'daniel', 'fred', 'tom', 'oliver', 'george', 'guy', 'ryan', '-iom', '-tpd', '-rjs', '-sfg'];
    if (female.any((k) => n.contains(k)) && !n.contains('male') || n.contains('female')) {
      return VoiceGender.female;
    }
    if (male.any((k) => n.contains(k))) return VoiceGender.male;
    return VoiceGender.unknown;
  }

  Map<String, String> toMap() => {'name': name, 'locale': locale};
}

enum VoiceGender { female, male, unknown }

class LearningLanguage {
  final String code; // ex: 'en'
  final String label;
  final String defaultLocale; // ex: 'en-US'

  const LearningLanguage(this.code, this.label, this.defaultLocale);

  static const english = LearningLanguage('en', 'Anglais', 'en-US');
  static const all = [english];
}

class VoiceSettings {
  final bool autoPlay;
  final String languageCode;
  final String? voiceName;
  final String? voiceLocale;
  final double rate; // 0.1 - 1.0
  final double pitch; // 0.5 - 2.0
  final double volume; // 0.0 - 1.0

  const VoiceSettings({
    this.autoPlay = true,
    this.languageCode = 'en',
    this.voiceName,
    this.voiceLocale,
    this.rate = 0.5,
    this.pitch = 1.0,
    this.volume = 1.0,
  });

  LearningLanguage get language => LearningLanguage.all
      .firstWhere((l) => l.code == languageCode, orElse: () => LearningLanguage.english);

  VoiceSettings copyWith({
    bool? autoPlay,
    String? languageCode,
    String? voiceName,
    String? voiceLocale,
    bool clearVoice = false,
    double? rate,
    double? pitch,
    double? volume,
  }) {
    return VoiceSettings(
      autoPlay: autoPlay ?? this.autoPlay,
      languageCode: languageCode ?? this.languageCode,
      voiceName: clearVoice ? null : (voiceName ?? this.voiceName),
      voiceLocale: clearVoice ? null : (voiceLocale ?? this.voiceLocale),
      rate: rate ?? this.rate,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
    );
  }
}
