import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../application/level_unlock_controller.dart';
import '../application/level_up_suggestion_controller.dart';
import '../application/user_level_controller.dart';
import '../domain/cefr_level.dart';
import '../application/voice_settings_controller.dart';
import '../domain/voice_settings.dart';
import 'learning_reset_dialog.dart';
import 'level_unlock_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _sample = 'The quick brown fox jumps over the lazy dog.';
  static const _appVersion = '1.0.0';
  static const _repoUrl = 'github.com/Croquette1995/Motio';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(voiceSettingsProvider);
    final n = ref.read(voiceSettingsProvider.notifier);
    final currentLevel = ref.watch(userLevelProvider);
    final levelNotifier = ref.read(userLevelProvider.notifier);
    final unlockState = ref.watch(levelUnlockDisplayProvider);
    final levelUpSuggestion = ref.watch(levelUpSuggestionDisplayProvider);
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

    Future<void> confirmRestartOnboarding() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: b.slate, width: 1.5),
          ),
          title: const Text('Relancer l\u2019onboarding ?'),
          content: const Text(
            'Tu vas re-choisir la langue apprise et le niveau de départ. '
            'Ta progression n\u2019est pas supprimée.',
            style: TextStyle(height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: b.slate,
                foregroundColor: b.cardSurface,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Relancer'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
      await levelNotifier.restartOnboarding();
    }

    Future<void> onLevelSelected(CefrLevel val) async {
      if (val == currentLevel) return;
      if (!unlockState.isUnlocked(val)) {
        LevelUnlockDialog.show(context, val);
        return;
      }
      if (val.index > currentLevel.index) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: b.slate, width: 1.5),
            ),
            title: Text('Passer au ${val.code} ?'),
            content: Text(
              'Le contenu du ${val.code} deviendra ton niveau actif. '
              'Les niveaux déjà couverts restent consultables en révision.',
              style: const TextStyle(height: 1.4),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Annuler'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: b.slate,
                  foregroundColor: b.cardSurface,
                ),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text('Passer au ${val.code}'),
              ),
            ],
          ),
        );
        if (confirmed != true) return;
      }
      await levelNotifier.setLevel(val);
    }

    Widget levelSubtitle(CefrLevel lvl) {
      final requirement = unlockState.requirementFor(lvl);
      final locked = !unlockState.isUnlocked(lvl);
      final lines = <String>[
        lvl.description,
        if (locked && requirement != null) requirement.message(target: lvl),
        if (lvl.index < currentLevel.index)
          'Consultable en révision.',
      ];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in lines)
            Text(
              line,
              style: TextStyle(
                fontSize: 12,
                color: b.slate.withValues(alpha: 0.7),
                fontWeight:
                    locked && requirement != null ? FontWeight.w700 : null,
              ),
            ),
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
              section('APPRENTISSAGE'),
              Card(
                elevation: 0,
                color: b.cardSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: b.lineGrey),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading:
                          Icon(Icons.language, size: 22, color: b.pastelBlue),
                      title: const Text(
                        'Langue apprise',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      subtitle: Text(
                        '${s.language.label} · source de vérité pour la voix de synthèse et le contenu.',
                        style: TextStyle(
                            fontSize: 12,
                            color: b.slate.withValues(alpha: 0.7)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: confirmRestartOnboarding,
                          icon: const Icon(Icons.school, size: 18),
                          label: const Text(
                            'RECHOISIR VIA L\u2019ONBOARDING',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'NIVEAU CECRL ACTIF : ${currentLevel.code}',
                style: t.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: b.slate.withValues(alpha: 0.8),
                ),
              ),
              RadioGroup<CefrLevel>(
                groupValue: currentLevel,
                onChanged: (val) {
                  if (val == null) return;
                  onLevelSelected(val);
                },
                child: Column(
                  children: [
                    for (final lvl in CefrLevel.values)
                      RadioListTile<CefrLevel>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(lvl.label,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14)),
                        subtitle: levelSubtitle(lvl),
                        value: lvl,
                        secondary: Icon(
                          !unlockState.isUnlocked(lvl)
                              ? Icons.lock
                              : lvl.index < currentLevel.index
                                  ? Icons.history_edu
                                  : Icons.check_circle,
                          size: 20,
                          color: !unlockState.isUnlocked(lvl)
                              ? b.slate.withValues(alpha: 0.5)
                              : lvl.index < currentLevel.index
                                  ? b.pastelYellow
                                  : b.pastelMint,
                        ),
                      ),
                  ],
                ),
              ),
              if (levelUpSuggestion.suggestion != null) ...[
                section('MONTÉE EN NIVEAU'),
                Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 0,
                  color: b.pastelMint.withValues(alpha: 0.18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: b.lineGrey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          levelUpSuggestion.suggestion!.message(),
                          style: t.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: b.slate,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () => ref
                                    .read(levelUpSuggestionStateProvider.notifier)
                                    .accept(),
                                child: Text(
                                    'PASSER AU ${levelUpSuggestion.suggestion!.targetLevel.code}'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => ref
                                    .read(levelUpSuggestionStateProvider.notifier)
                                    .decline(),
                                child: const Text('PLUS TARD'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              section('VOIX & LECTURE (TTS)'),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Lecture vocale des phrases'),
                subtitle: const Text(
                    'Lit la phrase une fois le mot validé (réussi ou échoué).'),
                value: s.autoPlay,
                onChanged: n.setAutoPlay,
              ),
              const SizedBox(height: 8),
              Text(
                'VOIX DISPONIBLES',
                style: t.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: b.slate.withValues(alpha: 0.8),
                ),
              ),
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
                  return RadioGroup<String>(
                    groupValue: s.voiceName ?? '',
                    onChanged: (selectedVal) {
                      if (selectedVal == null || selectedVal.isEmpty) {
                        n.setVoice(null);
                      } else {
                        final v = voices.firstWhere((x) => x.name == selectedVal);
                        n.setVoice(v);
                      }
                    },
                    child: Column(
                      children: [
                        const RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Voix par défaut du système'),
                          value: '',
                        ),
                        for (final v in voices)
                          RadioListTile<String>(
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
                            secondary: IconButton(
                              icon: const Icon(Icons.play_circle_outline),
                              tooltip: 'Écouter cette voix',
                              onPressed: () => n.speak(
                                _sample,
                                override: s.copyWith(
                                    voiceName: v.name, voiceLocale: v.locale),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
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
              section('DONNÉES'),
              Card(
                elevation: 0,
                color: b.cardSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: b.lineGrey),
                ),
                child: ListTile(
                  leading: Icon(Icons.restart_alt, size: 22, color: b.pastelRed),
                  title: const Text(
                    'Recommencer',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  subtitle: Text(
                    'Réinitialiser la progression SRS, supprimer les mots ajoutés depuis Tatoeba ou relancer l\u2019onboarding.',
                    style: TextStyle(
                        fontSize: 12, color: b.slate.withValues(alpha: 0.7)),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => LearningResetDialog.show(context),
                ),
              ),
              section('À PROPOS'),
              Text(
                'Motio · version $_appVersion',
                style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                '$_repoUrl',
                style: t.bodySmall?.copyWith(
                  color: b.slate.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sources des contenus embarqués :',
                style: t.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: b.slate.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Wiktionnaire (CC BY-SA 4.0) · wiktionary.org\n'
                'Tatoeba (CC BY 2.0 FR) · tatoeba.org\n'
                'UniMorph (CC BY-SA 4.0) · unimorph.github.io\n'
                'Wordlists de fréquence wordfreq — © Robyn Speer 2022, '
                'rspeer/wordfreq v3.0.2 (CC BY-SA 4.0) · '
                'doi.org/10.5281/zenodo.7199437',
                style: t.bodySmall?.copyWith(
                  height: 1.5,
                  color: b.slate.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
