import '../../vocabulary/domain/i_word_repository.dart';
import '../../vocabulary/domain/word.dart';
import '../data/drift_referentiel_repository.dart';
import '../domain/conjugation.dart';
import '../domain/declension.dart';
import '../domain/text_normalizer.dart';

class VocabularyMorphologyLinks {
  final ConjugationRecord? conjugation;
  final List<DeclensionRecord> declensions;

  const VocabularyMorphologyLinks({
    this.conjugation,
    this.declensions = const [],
  });

  bool get hasAny => conjugation != null || declensions.isNotEmpty;
}

class VocabularyBridgeService {
  final DriftReferentielRepository referentielRepo;
  final IWordRepository wordRepo;

  VocabularyBridgeService({
    required this.referentielRepo,
    required this.wordRepo,
  });

  /// Depuis une fiche Vocabulaire (`Word`), recherche les fiches morphologiques publiées
  /// correspondant à `(word.language, word.lemma ?? word.term)`.
  Future<VocabularyMorphologyLinks> findMorphologyForWord(Word word) async {
    final lang = await referentielRepo.getLanguageByCode(word.language);
    if (lang == null) return const VocabularyMorphologyLinks();

    final lookupKey = TextNormalizer.normalizeVocabularyLookupKey(
      word.language,
      word.lemma ?? word.term,
    );

    final conjugations = await referentielRepo.getConjugations(lang.id, publishedOnly: true);
    ConjugationRecord? matchedVerb;
    for (final c in conjugations) {
      if (TextNormalizer.normalizeVocabularyLookupKey(lang.code, c.lemma) == lookupKey) {
        matchedVerb = c;
        break;
      }
    }

    final declensions = lang.grammarProfile.hasDeclensions
        ? await referentielRepo.getDeclensions(lang.id, publishedOnly: true)
        : const <DeclensionRecord>[];
    final matchedDeclensions = declensions
        .where(
          (d) => TextNormalizer.normalizeVocabularyLookupKey(lang.code, d.lemma) == lookupKey,
        )
        .toList();

    return VocabularyMorphologyLinks(
      conjugation: matchedVerb,
      declensions: matchedDeclensions,
    );
  }

  /// Depuis une fiche Conjugaison/Déclinaison `(langCode, lemma)`,
  /// recherche une entrée correspondante dans le module Vocabulaire (`WordsTable`).
  Future<Word?> findWordForMorphology({
    required String langCode,
    required String lemma,
  }) async {
    final allWords = await wordRepo.getAllWords();
    final lookupKey = TextNormalizer.normalizeVocabularyLookupKey(langCode, lemma);
    for (final word in allWords) {
      if (word.language.toLowerCase() != langCode.toLowerCase()) continue;
      final wordKey = TextNormalizer.normalizeVocabularyLookupKey(
        word.language,
        word.lemma ?? word.term,
      );
      if (wordKey == lookupKey) return word;
    }
    return null;
  }
}
