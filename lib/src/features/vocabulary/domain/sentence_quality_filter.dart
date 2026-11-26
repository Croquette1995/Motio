import '../../settings/domain/cefr_level.dart';
import 'tatoeba_sentence.dart';
import 'word_categorizer_service.dart';
import 'word_frequency_service.dart';

/// Raisons de rejet d'une phrase source avant entrée dans le pipeline
/// d'enrichissement (Issue 28 : filtre qualité des phrases Tatoeba).
enum SentenceQualityIssue {
  emptyTranslation,
  tooShort,
  tooLong,
  parasiticFormatting,
  mostlyStopwords,
}

/// Filtre qualité des phrases sources :
/// - admission : longueur paramétrée par niveau CECRL, traduction française
///   disponible, pas de mise en forme parasite, phrases pas majoritairement
///   composées de mots vides ;
/// - score de pertinence : proportion (Zipf) de mots du niveau cible vs hors
///   niveau, bonus pour les phrases dotées d'un audio ;
/// - diversité : anti-doublon de phrases et répartition par domaine sémantique.
class SentenceQualityFilter {
  const SentenceQualityFilter({
    WordFrequencyService? frequencyService,
    WordCategorizerService? categorizerService,
  })  : _frequencyService = frequencyService ?? const WordFrequencyService(),
        _categorizerService = categorizerService ?? const WordCategorizerService();

  final WordFrequencyService _frequencyService;
  final WordCategorizerService _categorizerService;

  /// Stopwords anglais partagés avec l'extraction de mots candidats.
  static const Set<String> englishStopwords = {
    'the', 'a', 'an', 'and', 'or', 'but', 'if', 'because', 'as', 'until', 'while',
    'of', 'at', 'by', 'for', 'with', 'about', 'against', 'between', 'into', 'through',
    'during', 'before', 'after', 'above', 'below', 'to', 'from', 'up', 'down', 'in',
    'out', 'on', 'off', 'over', 'under', 'again', 'further', 'then', 'once', 'here',
    'there', 'when', 'where', 'why', 'how', 'all', 'any', 'both', 'each', 'few',
    'more', 'most', 'other', 'some', 'such', 'no', 'nor', 'not', 'only', 'own',
    'same', 'so', 'than', 'too', 'very', 's', 't', 'can', 'will', 'just', 'don',
    'should', 'now', 'd', 'll', 'm', 'o', 're', 've', 'y', 'ain', 'aren',
    'couldn', 'didn', 'doesn', 'hadn', 'hasn', 'haven', 'isn', 'ma', 'mightn',
    'mustn', 'needn', 'shan', 'shouldn', 'wasn', 'weren', 'won', 'wouldn',
    'i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', 'your',
    'yours', 'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she', 'her',
    'hers', 'herself', 'it', 'its', 'itself', 'they', 'them', 'their', 'theirs',
    'themselves', 'what', 'which', 'who', 'whom', 'this', 'that', 'these', 'those',
    'am', 'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had',
    'having', 'do', 'does', 'did', 'doing', 'would', 'could', 'shall'
  };

  /// Plage de longueur (en mots) acceptée par niveau CECRL :
  /// 4-8 pour A1, jusqu'à 15 mots pour B2.
  static const Map<CefrLevel, int> minWordsByLevel = {
    CefrLevel.a1: 4,
    CefrLevel.a2: 4,
    CefrLevel.b1: 5,
    CefrLevel.b2: 5,
  };

  static const Map<CefrLevel, int> maxWordsByLevel = {
    CefrLevel.a1: 8,
    CefrLevel.a2: 10,
    CefrLevel.b1: 12,
    CefrLevel.b2: 15,
  };

  /// Au-delà de ce ratio de mots vides, la phrase n'apporte aucun candidat utile.
  static const double maxStopwordRatio = 0.6;

  /// Bonus de classement appliqué aux phrases possédant un audio natif.
  static const double audioRankBonus = 0.05;

  int minWordsFor(CefrLevel level) => minWordsByLevel[level] ?? 4;

  int maxWordsFor(CefrLevel level) => maxWordsByLevel[level] ?? 12;

  int countWords(String text) => text
      .trim()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .length;

  /// Mots pleins (hors stopwords), utilisés pour le score de pertinence.
  List<String> contentWords(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z\s\-]"), ' ')
        .split(RegExp(r'\s+'))
        .map((w) => w.replaceAll(RegExp(r'^-+|-+$'), ''))
        .where((w) => w.length >= 2 && !englishStopwords.contains(w))
        .toList();
  }

  /// Proportion de mots vides parmi les mots de la phrase.
  double stopwordRatio(String text) {
    final tokens = text
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z\s']"), ' ')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (tokens.isEmpty) return 0;
    final stopwords = tokens.where(englishStopwords.contains).length;
    return stopwords / tokens.length;
  }

  /// URLs, balises HTML ou majuscules excessives.
  bool hasParasiticFormatting(String text) {
    if (RegExp(r'https?://|www\.', caseSensitive: false).hasMatch(text)) return true;
    if (RegExp(r'<[^>]+>').hasMatch(text)) return true;
    return _excessiveUppercase(text);
  }

  bool _excessiveUppercase(String text) {
    final letters = text.replaceAll(RegExp(r'[^A-Za-z]'), '');
    if (letters.length < 8) return false;
    final upperCount = letters.replaceAll(RegExp(r'[^A-Z]'), '').length;
    return upperCount / letters.length > 0.5;
  }

  /// Liste des raisons de rejet pour une phrase candidate au niveau cible.
  Set<SentenceQualityIssue> qualityIssues(
    TatoebaSentence sentence, {
    required CefrLevel level,
  }) {
    final issues = <SentenceQualityIssue>{};
    if (sentence.textFr.trim().isEmpty) {
      issues.add(SentenceQualityIssue.emptyTranslation);
    }

    final wordCount = countWords(sentence.textEn);
    if (wordCount < minWordsFor(level)) {
      issues.add(SentenceQualityIssue.tooShort);
    } else if (wordCount > maxWordsFor(level)) {
      issues.add(SentenceQualityIssue.tooLong);
    }

    if (hasParasiticFormatting(sentence.textEn) ||
        hasParasiticFormatting(sentence.textFr)) {
      issues.add(SentenceQualityIssue.parasiticFormatting);
    }

    if (stopwordRatio(sentence.textEn) > maxStopwordRatio) {
      issues.add(SentenceQualityIssue.mostlyStopwords);
    }

    return issues;
  }

  bool isAcceptable(TatoebaSentence sentence, {required CefrLevel level}) =>
      qualityIssues(sentence, level: level).isEmpty;

  /// Score de pertinence niveau : proportion de mots pleins du niveau cible
  /// versus hors niveau (échelle Zipf), entre 0.0 et 1.0.
  double relevanceScore(TatoebaSentence sentence, {required CefrLevel targetLevel}) {
    final words = contentWords(sentence.textEn);
    if (words.isEmpty) return 0;
    final inLevel =
        words.where((w) => _frequencyService.determineLevel(w) == targetLevel).length;
    return inLevel / words.length;
  }

  /// Score de classement : pertinence niveau + bonus audio.
  double rankScore(TatoebaSentence sentence, {required CefrLevel targetLevel}) =>
      relevanceScore(sentence, targetLevel: targetLevel) +
      (sentence.hasAudio ? audioRankBonus : 0);

  /// Domaine sémantique dominant d'une phrase (par son premier mot plein).
  String domainFor(TatoebaSentence sentence) {
    final words = contentWords(sentence.textEn);
    final term = words.isEmpty ? sentence.textEn.trim() : words.first;
    return _categorizerService.categorizeWord(term, contextSentence: sentence.textEn);
  }

  /// Répartition des phrases d'un lot entre les 9 domaines CECRL.
  Map<String, int> domainDistribution(List<TatoebaSentence> sentences) {
    final distribution = <String, int>{};
    for (final sentence in sentences) {
      final domain = domainFor(sentence);
      distribution[domain] = (distribution[domain] ?? 0) + 1;
    }
    return distribution;
  }

  /// Anti-doublon : une même phrase (id ou texte normalisé) n'est admise qu'une fois.
  List<TatoebaSentence> deduplicate(List<TatoebaSentence> sentences) {
    final seenIds = <int>{};
    final seenTexts = <String>{};
    final unique = <TatoebaSentence>[];
    for (final sentence in sentences) {
      final key = _normalize(sentence.textEn);
      if (!seenIds.add(sentence.id) || !seenTexts.add(key)) continue;
      unique.add(sentence);
    }
    return unique;
  }

  /// Filtre le lot puis le trie par score de classement décroissant :
  /// les phrases les plus pertinentes pour le niveau actif sont traitées en premier.
  List<TatoebaSentence> filterAndRank(
    List<TatoebaSentence> sentences, {
    required CefrLevel level,
  }) {
    final accepted = deduplicate(sentences)
        .where((s) => isAcceptable(s, level: level))
        .toList()
      ..sort((a, b) {
        final byScore = rankScore(b, targetLevel: level)
            .compareTo(rankScore(a, targetLevel: level));
        if (byScore != 0) return byScore;
        return a.id.compareTo(b.id);
      });
    return accepted;
  }

  /// Lot prêt pour le pipeline : filtre + classement + répartition
  /// round-robin entre les domaines sémantiques pour éviter les lots
  /// monoculture (tous les mots d'un même thème).
  List<TatoebaSentence> selectDiverseBatch(
    List<TatoebaSentence> sentences, {
    required CefrLevel level,
    int? maxSentences,
  }) {
    final ranked = filterAndRank(sentences, level: level);
    final limit = maxSentences ?? ranked.length;
    if (limit <= 0) return const [];

    final buckets = <String, List<TatoebaSentence>>{};
    for (final sentence in ranked) {
      buckets.putIfAbsent(domainFor(sentence), () => []).add(sentence);
    }

    final selected = <TatoebaSentence>[];
    while (selected.length < limit) {
      var progressed = false;
      for (final bucket in buckets.values) {
        if (bucket.isEmpty) continue;
        selected.add(bucket.removeAt(0));
        progressed = true;
        if (selected.length >= limit) break;
      }
      if (!progressed) break;
    }
    return selected;
  }

  String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
