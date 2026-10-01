import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../../vocabulary/presentation/vocabulary_controller.dart';
import '../../practice_canvas/presentation/canvas_view.dart';
import '../../practice_cloze/presentation/cloze_view.dart';
import '../../practice_matching/presentation/matching_view.dart';
import 'session_controller.dart';

class SessionScreen extends ConsumerWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionControllerProvider);
    final notifier = ref.read(sessionControllerProvider.notifier);
    final allWordsAsync = ref.watch(allWordsProvider);
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    if (state.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: b.slate,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Préparation de votre séance...',
                style: t.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: b.slate,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final session = state.studySession;

    if (session == null || state.isFinished || session.isCompleted) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'SÉANCE TERMINÉE',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: b.pastelYellow,
                      shape: BoxShape.circle,
                      border: Border.all(color: b.slate, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: b.slate,
                          offset: const Offset(3, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(Icons.star, color: b.slate, size: 36),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'FÉLICITATIONS !',
                    style: t.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: b.slate,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vous avez complété tous les mots prévus pour cette session.',
                    textAlign: TextAlign.center,
                    style: t.bodyMedium?.copyWith(
                      color: b.slate.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: b.cardSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: b.slate, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: b.slate,
                          offset: const Offset(3, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: b.pastelMint,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: b.slate, width: 1),
                              ),
                              child: Text(
                                '${state.correctAnswers}',
                                style: t.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: b.slate,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'VALIDÉS',
                              style: t.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: b.slate,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 1.5,
                          height: 50,
                          color: b.lineGrey,
                        ),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: b.pastelRed,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: b.slate, width: 1),
                              ),
                              child: Text(
                                '${state.failedAnswers}',
                                style: t.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: b.slate,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'À REVOIR',
                              style: t.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: b.slate,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: b.slate,
                        foregroundColor: b.cardSurface,
                        shape: bauhausBorder(radius: 10, color: b.slate),
                      ),
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.home, size: 20),
                      label: const Text(
                        'RETOUR AU TABLEAU DE BORD',
                        style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final currentCard = session.currentCard!;
    final totalCards = session.initialCardCount;
    final completedCards = session.completedCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CARTE ${completedCards + 1} / $totalCards',
          style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5, fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: b.pastelYellow,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: b.slate, width: 1.2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    switch (state.currentMode) {
                      PracticeMode.canvas => Icons.draw,
                      PracticeMode.cloze => Icons.text_fields,
                      PracticeMode.matching => Icons.grid_view,
                    },
                    size: 14,
                    color: b.slate,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    switch (state.currentMode) {
                      PracticeMode.canvas => 'CANVAS',
                      PracticeMode.cloze => 'CLOZE',
                      PracticeMode.matching => 'MATCHING',
                    },
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: b.slate,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          // Modular Bauhaus block progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: BauhausProgress(
              done: completedCards,
              total: totalCards,
              height: 7,
              activeColor: b.pastelBlue,
              currentColor: b.pastelYellow,
            ),
          ),

          // Exercise View based on mode
          Expanded(
            child: switch (state.currentMode) {
              PracticeMode.canvas => CanvasPracticeView(
                  key: ValueKey(currentCard.word.id),
                  word: currentCard.word,
                  onSelfEvaluation: (isSuccess) async {
                    await notifier.submitAnswer(isSuccess);
                  },
                ),
              PracticeMode.cloze => allWordsAsync.when(
                  data: (words) => ClozePracticeView(
                    key: ValueKey(currentCard.word.id),
                    word: currentCard.word,
                    availableWords: words,
                    onAnswerSubmitted: (isSuccess) async {
                      await Future.delayed(const Duration(milliseconds: 700));
                      await notifier.submitAnswer(isSuccess);
                    },
                  ),
                  loading: () => Center(
                    child: CircularProgressIndicator(color: b.slate),
                  ),
                  error: (_, __) => const Center(child: Text('Erreur de chargement')),
                ),
              PracticeMode.matching => allWordsAsync.when(
                  data: (words) => MatchingPracticeView(
                    key: ValueKey('matching_${completedCards}_${currentCard.word.id}'),
                    words: [
                      currentCard.word,
                      ...words.where((w) => w.id != currentCard.word.id).take(5),
                    ],
                    onComplete: () async {
                      await Future.delayed(const Duration(milliseconds: 500));
                      await notifier.submitAnswer(true);
                    },
                  ),
                  loading: () => Center(
                    child: CircularProgressIndicator(color: b.slate),
                  ),
                  error: (_, __) => const Center(child: Text('Erreur de chargement')),
                ),
            },
          ),
        ],
      ),
    );
  }
}
