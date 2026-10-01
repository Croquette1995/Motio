import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Préparation de votre séance personnalisée...'),
            ],
          ),
        ),
      );
    }

    final session = state.studySession;

    if (session == null || state.isFinished || session.isCompleted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Séance terminée')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 80),
                const SizedBox(height: 16),
                const Text(
                  'Félicitations !',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Vous avez complété tous les mots prévus pour cette session.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${state.correctAnswers}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Text('Validés du 1er coup'),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Column(
                          children: [
                            Text(
                              '${state.failedAnswers}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            const Text('Révisés en séance'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.home),
                  label: const Text('Retour au tableau de bord'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentCard = session.currentCard!;
    final totalCards = session.initialCardCount;
    final completedCards = session.completedCount;
    final progressVal = session.progressRatio;

    return Scaffold(
      appBar: AppBar(
        title: Text('Carte ${completedCards + 1} / $totalCards'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              avatar: Icon(
                switch (state.currentMode) {
                  PracticeMode.canvas => Icons.draw,
                  PracticeMode.cloze => Icons.text_fields,
                  PracticeMode.matching => Icons.grid_view,
                },
                size: 18,
              ),
              label: Text(
                switch (state.currentMode) {
                  PracticeMode.canvas => 'Canvas',
                  PracticeMode.cloze => 'Cloze',
                  PracticeMode.matching => 'Matching',
                },
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(value: progressVal),
        ),
      ),
      body: Column(
        children: [
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
                      await Future.delayed(const Duration(milliseconds: 900));
                      await notifier.submitAnswer(isSuccess);
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
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
                      await Future.delayed(const Duration(milliseconds: 600));
                      await notifier.submitAnswer(true);
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Erreur de chargement')),
                ),
            },
          ),
        ],
      ),
    );
  }
}
