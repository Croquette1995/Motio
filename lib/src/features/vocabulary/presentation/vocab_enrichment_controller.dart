import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_providers.dart';
import '../../settings/application/user_level_controller.dart';
import '../../settings/domain/cefr_level.dart';
import '../application/category_progress_service.dart';
import '../application/vocab_enrichment_service.dart';
import '../data/tatoeba_service.dart';
import '../data/wiktionary_provider.dart';
import 'vocabulary_controller.dart';

final vocabEnrichmentServiceProvider = Provider<VocabEnrichmentService>((ref) {
  return VocabEnrichmentService(
    wordRepository: ref.watch(wordRepositoryProvider),
    tatoebaService: ref.watch(tatoebaServiceProvider),
    wiktionaryService: ref.watch(wiktionaryServiceProvider),
  );
});

enum VocabEnrichmentPhase { idle, running, done, cancelled, failed }

class VocabEnrichmentState {
  final VocabEnrichmentPhase phase;
  final CefrLevel? level;
  final int baseWords;
  final int addedWords;
  final int targetWords;
  final int sentencesAnalyzed;
  final String? errorMessage;

  const VocabEnrichmentState({
    this.phase = VocabEnrichmentPhase.idle,
    this.level,
    this.baseWords = 0,
    this.addedWords = 0,
    this.targetWords = 0,
    this.sentencesAnalyzed = 0,
    this.errorMessage,
  });

  bool get isRunning => phase == VocabEnrichmentPhase.running;

  VocabEnrichmentState copyWith({
    VocabEnrichmentPhase? phase,
    CefrLevel? level,
    int? baseWords,
    int? addedWords,
    int? targetWords,
    int? sentencesAnalyzed,
    String? errorMessage,
  }) {
    return VocabEnrichmentState(
      phase: phase ?? this.phase,
      level: level ?? this.level,
      baseWords: baseWords ?? this.baseWords,
      addedWords: addedWords ?? this.addedWords,
      targetWords: targetWords ?? this.targetWords,
      sentencesAnalyzed: sentencesAnalyzed ?? this.sentencesAnalyzed,
      errorMessage: errorMessage,
    );
  }
}

/// Enrichissement « en 1 clic » du niveau actif : un seul geste utilisateur,
/// aucun choix manuel de phrases ou de mots candidats.
class VocabEnrichmentNotifier extends Notifier<VocabEnrichmentState> {
  bool _cancelRequested = false;
  bool _starting = false;

  @override
  VocabEnrichmentState build() {
    return const VocabEnrichmentState();
  }

  /// Lancement automatique (fin d'onboarding, changement de niveau :
  /// Paramètres, suggestion de montée) ou reprise après interruption.
  /// Le pipeline est idempotent : rien n'est re-traité inutilement.
  void startAutoEnrichment() {
    unawaited(_start());
  }

  /// Lancement depuis le geste utilisateur « Enrichir mon niveau ».
  Future<void> startEnrichment() => _start();

  void cancel() {
    if (state.isRunning) _cancelRequested = true;
  }

  bool isCancelledNow() => _cancelRequested;

  Future<void> _start() async {
    if (_starting || state.phase == VocabEnrichmentPhase.running) return;
    _starting = true;
    try {
      await _runPipeline();
    } finally {
      _starting = false;
    }
  }

  Future<void> _runPipeline() async {
    final onboarded = await ref.read(isLevelOnboardedProvider.future);
    if (!onboarded) return;
    if (state.phase == VocabEnrichmentPhase.running) return;

    final level = ref.read(userLevelProvider);
    _cancelRequested = false;

    final wordRepository = ref.read(wordRepositoryProvider);
    final baseWords = (await wordRepository.getWordsByLevel(level.code)).length;
    state = VocabEnrichmentState(
      phase: VocabEnrichmentPhase.running,
      level: level,
      baseWords: baseWords,
      targetWords: VocabEnrichmentService.levelQuota(level),
    );

    final service = ref.read(vocabEnrichmentServiceProvider);

    try {
      final result = await service.runToQuota(
        level: level,
        onProgress: (progress) {
          state = state.copyWith(
            addedWords: progress.addedWords,
            targetWords: progress.targetWords,
            sentencesAnalyzed: progress.sentencesAnalyzed,
          );
        },
        isCancelled: isCancelledNow,
      );

      _refreshVocabularyProviders();

      if (state.level != level) return;

      switch (result.status) {
        case EnrichmentRunStatus.quotaAlreadyReached:
        case EnrichmentRunStatus.completed:
          state = state.copyWith(phase: VocabEnrichmentPhase.done);
          break;
        case EnrichmentRunStatus.cancelled:
          state = state.copyWith(phase: VocabEnrichmentPhase.cancelled);
          break;
        case EnrichmentRunStatus.networkError:
        case EnrichmentRunStatus.sourceExhausted:
          state = state.copyWith(
            phase: VocabEnrichmentPhase.failed,
            errorMessage: result.errorMessage,
          );
          break;
      }
    } catch (e) {
      state = state.copyWith(
        phase: VocabEnrichmentPhase.failed,
        errorMessage: 'Erreur pendant l\u2019enrichissement : $e',
      );
    }
  }

  void _refreshVocabularyProviders() {
    ref.invalidate(allWordsProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(wordProgressMapProvider);
    ref.invalidate(levelCategoryProgressProvider);
  }
}

final vocabEnrichmentProvider =
    NotifierProvider<VocabEnrichmentNotifier, VocabEnrichmentState>(
  VocabEnrichmentNotifier.new,
);

/// Déclencheur automatique du pré-remplissage, initialisé au démarrage de
/// l'application : tout changement du niveau actif (onboarding, Paramètres,
/// montée en niveau suggérée) relance le pipeline pour ce niveau.
/// Les tests qui n'initialisent pas ce provider ne lancent jamais le pipeline.
final vocabEnrichmentAutoTriggerProvider = Provider<void>((ref) {
  ref.listen(userLevelProvider, (previous, next) {
    ref.read(vocabEnrichmentProvider.notifier).startAutoEnrichment();
  });
});
