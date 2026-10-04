import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_providers.dart';
import '../data/tatoeba_service.dart';
import '../data/wiktionary_provider.dart';

import '../domain/tatoeba_sentence.dart';
import 'vocabulary_controller.dart';

final tatoebaServiceProvider = Provider<TatoebaService>((ref) {
  return TatoebaService();
});

class TatoebaExplorerState {
  final bool isLoading;
  final String? errorMessage;
  final List<TatoebaSentence> sentences;
  final TatoebaSentence? selectedSentence;
  final List<ExtractedCandidateWord> candidates;
  final Set<String> addedTerms;

  const TatoebaExplorerState({
    this.isLoading = false,
    this.errorMessage,
    this.sentences = const [],
    this.selectedSentence,
    this.candidates = const [],
    this.addedTerms = const {},
  });

  TatoebaExplorerState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<TatoebaSentence>? sentences,
    TatoebaSentence? selectedSentence,
    List<ExtractedCandidateWord>? candidates,
    Set<String>? addedTerms,
  }) {
    return TatoebaExplorerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      sentences: sentences ?? this.sentences,
      selectedSentence: selectedSentence ?? this.selectedSentence,
      candidates: candidates ?? this.candidates,
      addedTerms: addedTerms ?? this.addedTerms,
    );
  }
}

class TatoebaExplorerNotifier extends Notifier<TatoebaExplorerState> {
  @override
  TatoebaExplorerState build() {
    return const TatoebaExplorerState();
  }

  Future<void> fetchSentences({String query = '', bool random = true}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final service = ref.read(tatoebaServiceProvider);
    final repo = ref.read(wordRepositoryProvider);

    try {
      final sentences = await service.searchSentences(
        query: query,
        random: random,
        pageSize: 6,
      );

      if (sentences.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          sentences: [],
          selectedSentence: null,
          candidates: [],
          errorMessage: 'Aucune phrase trouvée sur Tatoeba pour ces critères.',
        );
        return;
      }

      final firstSentence = sentences.first;
      final candidates = await service.analyzeSentenceWords(
        sentence: firstSentence.textEn,
        wordRepository: repo,
      );

      state = state.copyWith(
        isLoading: false,
        sentences: sentences,
        selectedSentence: firstSentence,
        candidates: candidates,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la connexion à Tatoeba: $e',
      );
    }
  }

  Future<void> selectSentence(TatoebaSentence sentence) async {
    state = state.copyWith(isLoading: true, selectedSentence: sentence);

    final service = ref.read(tatoebaServiceProvider);
    final repo = ref.read(wordRepositoryProvider);

    final candidates = await service.analyzeSentenceWords(
      sentence: sentence.textEn,
      wordRepository: repo,
    );

    state = state.copyWith(
      isLoading: false,
      selectedSentence: sentence,
      candidates: candidates,
    );
  }

  Future<void> addCandidateWordToDeck({
    required ExtractedCandidateWord candidate,
    required TatoebaSentence sentence,
    String? customTranslation,
    String? category,
  }) async {
    final repo = ref.read(wordRepositoryProvider);
    final wiktionary = ref.read(wiktionaryServiceProvider);

    // Si la traduction n'est pas renseignée, chercher via Wiktionary
    String translation = customTranslation ?? candidate.translation ?? '';
    String pos = candidate.pos ?? 'noun';
    String finalCategory = category ?? 'Général';

    if (translation.isEmpty) {
      final details = await wiktionary.fetchWordDetails(candidate.term);
      if (details.translations.isNotEmpty) {
        translation = details.translations.first.term;
      } else if (details.definitions.isNotEmpty) {
        translation = details.definitions.first.text;
      } else {
        translation = 'Traduction à préciser';
      }

      if (details.definitions.isNotEmpty && details.definitions.first.partOfSpeech.isNotEmpty) {
        pos = details.definitions.first.partOfSpeech.toLowerCase();
      }
    }

    await repo.addWord(
      term: candidate.term,
      translation: translation,
      contextSentence: sentence.textEn,
      category: finalCategory,
      level: candidate.estimatedLevel.code,
      pos: pos,
      frequencyScore: candidate.frequencyScore,
    );

    // Rafraîchir les listes Riverpod
    ref.invalidate(allWordsProvider);
    ref.invalidate(categoriesProvider);
    ref.invalidate(wordProgressMapProvider);

    // Mettre à jour l'état local
    final updatedAdded = Set<String>.from(state.addedTerms)..add(candidate.term);
    final updatedCandidates = state.candidates.map((c) {
      if (c.term == candidate.term) {
        return c.copyWith(isAlreadyInDb: true, translation: translation, pos: pos);
      }
      return c;
    }).toList();

    state = state.copyWith(
      addedTerms: updatedAdded,
      candidates: updatedCandidates,
    );
  }
}

final tatoebaExplorerProvider =
    NotifierProvider<TatoebaExplorerNotifier, TatoebaExplorerState>(
  TatoebaExplorerNotifier.new,
);
