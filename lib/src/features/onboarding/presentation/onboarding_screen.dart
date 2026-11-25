import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../../settings/application/user_level_controller.dart';
import '../../settings/application/voice_settings_controller.dart';
import '../../settings/domain/cefr_level.dart';
import '../../settings/domain/voice_settings.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  LearningLanguage _language = LearningLanguage.english;
  CefrLevel _level = CefrLevel.a1;

  Future<void> _complete(CefrLevel level) async {
    ref.read(voiceSettingsProvider.notifier).setLanguage(_language.code);
    await ref.read(userLevelProvider.notifier).setLevel(level);
    ref.invalidate(isLevelOnboardedProvider);
    await ref.read(isLevelOnboardedProvider.future);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    Widget sectionTitle(String text) => Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 8),
          child: Text(
            text,
            style: t.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: b.slate,
            ),
          ),
        );

    Widget languageCard(LearningLanguage lang, {bool comingSoon = false}) {
      final selected = !comingSoon && lang.code == _language.code;
      return Opacity(
        opacity: comingSoon ? 0.55 : 1.0,
        child: Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 0,
          color: selected ? b.pastelBlue.withValues(alpha: 0.18) : b.cardSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: selected ? b.pastelBlue : b.lineGrey,
              width: selected ? 2 : 1.5,
            ),
          ),
          child: ListTile(
            onTap: comingSoon ? null : () => setState(() => _language = lang),
            leading: Icon(
              selected ? Icons.check_circle : Icons.language,
              color: selected ? b.pastelBlue : b.slate,
            ),
            title: Text(
              comingSoon ? '${lang.label} · bientôt disponible' : lang.label,
              style: t.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: b.slate,
              ),
            ),
            trailing: comingSoon
                ? Icon(Icons.lock_outline, size: 18, color: b.slate.withValues(alpha: 0.5))
                : null,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: b.chalk,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: b.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: b.slate, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: b.slate,
                    offset: const Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Bienvenue dans Motio',
                    style: t.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: b.slate,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Apprends du vocabulaire grâce à la répétition espacée et à l\'écriture manuscrite.',
                    style: t.bodyMedium?.copyWith(
                      color: b.slate.withValues(alpha: 0.75),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const BauhausRule(),
                  sectionTitle('LANGUE APPRISE'),
                  for (final lang in LearningLanguage.all) languageCard(lang),
                  languageCard(
                    const LearningLanguage('xx', 'Autre langue', ''),
                    comingSoon: true,
                  ),
                  sectionTitle('NIVEAU DE DÉPART'),
                  RadioGroup<CefrLevel>(
                    groupValue: _level,
                    onChanged: (val) {
                      if (val != null) setState(() => _level = val);
                    },
                    child: Column(
                      children: [
                        for (final lvl in CefrLevel.values)
                          Material(
                            type: MaterialType.transparency,
                            child: RadioListTile<CefrLevel>(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              title: Text(
                                lvl.label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              subtitle: Text(
                                lvl.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: b.slate.withValues(alpha: 0.7),
                                ),
                              ),
                              value: lvl,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tu apprends l\'${_language.label.toLowerCase()} · niveau ${_level.code}',
                    style: t.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: b.pastelBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _complete(CefrLevel.a1),
                          child: const Text('JE NE SAIS PAS'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _complete(_level),
                          child: const Text('COMMENCER'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
