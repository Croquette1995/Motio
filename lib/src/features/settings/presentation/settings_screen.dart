import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../application/voice_settings_controller.dart';
import '../domain/voice_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _sample = 'The quick brown fox jumps over the lazy dog.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(voiceSettingsProvider);
    final n = ref.read(voiceSettingsProvider.notifier);
    final voicesAsync = ref.watch(availableVoicesProvider(s.languageCode));
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    Widget section(String title) => Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(
            title,
            style: t.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: b.slate,
            ),
          ),
        );

    Widget slider(String label, double value, double min, double max,
        ValueChanged<double> onChanged) {
      return Row(
        children: [
          SizedBox(width: 90, child: Text(label)),
          Expanded(
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              divisions: 18,
              label: value.toStringAsFixed(2),
              onChanged: onChanged,
            ),
          ),
          SizedBox(width: 40, child: Text(value.toStringAsFixed(2))),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PARAMÈTRES',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              section('VOIX'),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Lecture vocale des phrases'),
                subtitle: const Text(
                    'Lit la phrase une fois le mot validé (réussi ou échoué).'),
                value: s.autoPlay,
                onChanged: n.setAutoPlay,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: s.languageCode,
                decoration: const InputDecoration(labelText: 'Langue apprise'),
                items: [
                  for (final l in LearningLanguage.all)
                    DropdownMenuItem(value: l.code, child: Text(l.label)),
                ],
                onChanged: (v) {
                  if (v != null) n.setLanguage(v);
                },
              ),
              section('VOIX DISPONIBLES'),
              voicesAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => const Text('Impossible de charger les voix.'),
                data: (voices) {
                  if (voices.isEmpty) {
                    return const Text(
                        'Aucune voix détectée pour cette langue. La voix par défaut du système sera utilisée.');
                  }
                  return Column(
                    children: [
                      RadioListTile<String?>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Voix par défaut du système'),
                        value: null,
                        groupValue: s.voiceName,
                        onChanged: (_) => n.setVoice(null),
                      ),
                      for (final v in voices)
                        RadioListTile<String?>(
                          contentPadding: EdgeInsets.zero,
                          title: Text(v.name),
                          subtitle: Text(
                            '${v.locale} · ${switch (v.gender) {
                              VoiceGender.female => 'voix féminine',
                              VoiceGender.male => 'voix masculine',
                              VoiceGender.unknown => 'genre non précisé',
                            }}',
                          ),
                          value: v.name,
                          groupValue: s.voiceName,
                          secondary: IconButton(
                            icon: const Icon(Icons.play_circle_outline),
                            tooltip: 'Écouter cette voix',
                            onPressed: () => n.speak(
                              _sample,
                              override: s.copyWith(
                                  voiceName: v.name, voiceLocale: v.locale),
                            ),
                          ),
                          onChanged: (_) => n.setVoice(v),
                        ),
                    ],
                  );
                },
              ),
              section('RÉGLAGES'),
              slider('Vitesse', s.rate, 0.1, 1.0, n.setRate),
              slider('Tonalité', s.pitch, 0.5, 2.0, n.setPitch),
              slider('Volume', s.volume, 0.0, 1.0, n.setVolume),
              const SizedBox(height: 12),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: b.slate,
                  foregroundColor: b.cardSurface,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => n.speak(_sample),
                icon: const Icon(Icons.volume_up),
                label: const Text('ÉCOUTER UN EXEMPLE'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
