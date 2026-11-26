import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/bauhaus_theme.dart';
import '../../settings/application/user_level_controller.dart';
import '../../settings/domain/cefr_level.dart';
import '../../../core/database/database_providers.dart';
import '../application/vocab_enrichment_service.dart';
import 'vocab_enrichment_controller.dart';

final _levelWordCountProvider =
    FutureProvider.family<int, CefrLevel>((ref, level) async {
  final repo = ref.watch(wordRepositoryProvider);
  final words = await repo.getWordsByLevel(level.code);
  return words.length;
});

/// Écran d'enrichissement « en 1 clic » du niveau actif : un bouton lance le
/// pipeline automatique jusqu'au quota CECRL, avec progression temps réel.
class VocabEnrichmentScreen extends ConsumerWidget {
  const VocabEnrichmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = context.bauhaus;
    final state = ref.watch(vocabEnrichmentProvider);
    final activeLevel = ref.watch(userLevelProvider);
    final notifier = ref.read(vocabEnrichmentProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: b.pastelMint,
                shape: BoxShape.circle,
                border: Border.all(color: b.slate, width: 1),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'ENRICHISSEMENT',
              style: TextStyle(
                  fontWeight: FontWeight.w800, letterSpacing: 0.5, fontSize: 16),
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: switch (state.phase) {
            VocabEnrichmentPhase.running =>
              _ProgressView(state: state, level: state.level ?? activeLevel),
            VocabEnrichmentPhase.done => _ResultView(
                title: 'Enrichissement terminé',
                level: state.level ?? activeLevel,
                addedWords: state.addedWords,
                sentencesAnalyzed: state.sentencesAnalyzed,
              ),
            VocabEnrichmentPhase.cancelled => _ResultView(
                title: 'Enrichissement interrompu',
                level: state.level ?? activeLevel,
                addedWords: state.addedWords,
                sentencesAnalyzed: state.sentencesAnalyzed,
                message:
                    'Les mots déjà ajoutés sont conservés. Relance « Enrichir mon niveau » pour compléter.',
              ),
            VocabEnrichmentPhase.failed => _ErrorView(
                message: state.errorMessage ?? 'Erreur inconnue.',
              ),
            VocabEnrichmentPhase.idle =>
              _IdleView(level: activeLevel, notifier: notifier),
          },
        ),
      ),
    );
  }
}

class _IdleView extends ConsumerWidget {
  final CefrLevel level;
  final VocabEnrichmentNotifier notifier;

  const _IdleView({required this.level, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final coverageAsync = ref.watch(_levelWordCountProvider(level));
    final quota = VocabEnrichmentService.levelQuota(level);

    final wordCount = coverageAsync.asData?.value;
    final quotaReached = wordCount != null && wordCount >= quota;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: b.cardSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: b.slate, width: 2),
              boxShadow: [
                BoxShadow(color: b.slate, offset: const Offset(3, 3), blurRadius: 0),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.auto_awesome, size: 40, color: b.pastelYellow),
                const SizedBox(height: 12),
                Text(
                  'ENRICHIR MON NIVEAU ${level.code}',
                  style: t.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: b.slate,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Motio récupère automatiquement des phrases Tatoeba, en extrait '
                  'les mots du niveau ${level.code}, les traduit et les ajoute à ta '
                  'collection — sans aucun choix à faire.',
                  style: t.bodyMedium?.copyWith(
                    color: b.slate.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                coverageAsync.when(
                  data: (count) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: quotaReached ? b.pastelMint : b.chalk,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: b.slate, width: 1),
                    ),
                    child: Text(
                      'Couverture du ${level.code} : $count / $quota mots',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    ),
                  ),
                  loading: () => const SizedBox(height: 24),
                  error: (_, __) => const SizedBox(height: 24),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (quotaReached)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: b.pastelMint.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: b.slate, width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: b.slate, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Quota du niveau ${level.code} déjà couvert : rien à enrichir pour le moment.',
                      style: t.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: b.slate,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: b.slate,
                foregroundColor: b.cardSurface,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.bolt, size: 20),
              label: const Text(
                'ENRICHIR MON NIVEAU',
                style:
                    TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.8),
              ),
              onPressed: () => notifier.startEnrichment(),
            ),
        ],
      ),
    );
  }
}

class _ProgressView extends ConsumerWidget {
  final VocabEnrichmentState state;
  final CefrLevel level;

  const _ProgressView({required this.state, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final covered = state.baseWords + state.addedWords;
    final target = state.targetWords;
    final progress =
        target == 0 ? 0.0 : (covered / target).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.hourglass_top, size: 40, color: b.pastelBlue),
          const SizedBox(height: 12),
          Text(
            'ENRICHISSEMENT DU ${level.code}',
            style: t.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: b.slate,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'L\u2019opération peut prendre quelques minutes : elle est automatique.',
            style: t.bodySmall?.copyWith(
              color: b.slate.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: b.chalk,
              valueColor: AlwaysStoppedAnimation<Color>(b.slate),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '$covered / $target mots ajoutés',
            style: t.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: b.slate,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${state.sentencesAnalyzed} phrases analysées',
            style: t.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: b.slate.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: b.slate,
              side: const BorderSide(),
            ),
            icon: const Icon(Icons.stop, size: 20),
            label: const Text(
              'ANNULER',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            onPressed: () => ref.read(vocabEnrichmentProvider.notifier).cancel(),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends ConsumerWidget {
  final String title;
  final CefrLevel level;
  final int addedWords;
  final int sentencesAnalyzed;
  final String? message;

  const _ResultView({
    required this.title,
    required this.level,
    required this.addedWords,
    required this.sentencesAnalyzed,
    this.message,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: b.pastelMint.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: b.slate, width: 1.5),
            ),
            child: Column(
              children: [
                Icon(Icons.check_circle_outline, size: 40, color: b.slate),
                const SizedBox(height: 10),
                Text(
                  title.toUpperCase(),
                  style: t.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: b.slate,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$addedWords mots ajoutés au ${level.code} · '
                  '$sentencesAnalyzed phrases analysées',
                  style: t.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: b.slate,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (message != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    message!,
                    style: t.bodySmall?.copyWith(
                      color: b.slate.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (addedWords > 0)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: b.slate,
                side: const BorderSide(),
              ),
              icon: const Icon(Icons.bolt, size: 20),
              label: const Text(
                'CONTINUER L\u2019ENRICHISSEMENT',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              onPressed: () => ref.read(vocabEnrichmentProvider.notifier).startEnrichment(),
            ),
        ],
      ),
    );
  }
}

class _ErrorView extends ConsumerWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(Icons.error_outline, size: 40, color: b.pastelRed),
          const SizedBox(height: 12),
          Text(
            'ENRICHISSEMENT SUSPENDU',
            style: t.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: b.slate,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: t.bodyMedium?.copyWith(
              color: b.slate.withValues(alpha: 0.8),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: b.slate,
              foregroundColor: b.cardSurface,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text(
              'RÉESSAYER',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            onPressed: () =>
                ref.read(vocabEnrichmentProvider.notifier).startEnrichment(),
          ),
        ],
      ),
    );
  }
}
