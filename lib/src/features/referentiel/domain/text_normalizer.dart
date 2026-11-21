import 'package:unorm_dart/unorm_dart.dart' as unorm;

enum AnswerStatus {
  correct(1.0),
  almost(0.5),
  wrong(0.0);

  final double points;
  const AnswerStatus(this.points);
}

class AnswerEvaluation {
  final AnswerStatus status;
  final String feedback;

  const AnswerEvaluation({
    required this.status,
    required this.feedback,
  });

  bool get isCorrect => status == AnswerStatus.correct;
  bool get isAlmost => status == AnswerStatus.almost;
  bool get isWrong => status == AnswerStatus.wrong;
}

class TextNormalizer {
  TextNormalizer._();

  static final RegExp _combiningDiacritics = RegExp(r'[\u0300-\u036f]');
  static final RegExp _multiSpaces = RegExp(r'[\s\u00A0\u202F]+');
  static final RegExp _trailingPunctuation = RegExp(r'[.!?]+$');

  /// Paires minimales par langue : si les deux formes existent et ne diffèrent
  /// que par un signe diacritique, la comparaison est stricte (pas de `almost`).
  static const Map<String, Set<String>> _strictMinimalPairGroups = {
    'fr': {
      'a', 'à',
      'ou', 'où',
      'la', 'là',
      'du', 'dû',
      'sur', 'sûr',
      'mur', 'mûr',
      'cru', 'crû',
      'crue', 'crûe',
      'jeune', 'jeûne',
      'tache', 'tâche',
      'cote', 'côte',
      'des', 'dès',
      'ce', 'ça',
    },
  };

  /// Normalisation Unicode (§4.1) :
  /// 1. NFC
  /// 2. Roumain : cédille -> virgule souscrite officielle (ş→ș, ţ→ț, Ş→Ș, Ţ→Ț)
  /// 3. Apostrophes courbes -> droite, espaces insécables/multiples -> espace simple, trim
  static String normalize(String input) {
    return normalizePreservingEdges(input).trim();
  }

  /// Normalise NFC + cédilles roumaines + apostrophes sans supprimer les espaces de bord
  /// (utile pour `sentence_before` / `sentence_after`).
  static String normalizePreservingEdges(String input) {
    var s = unorm.nfc(input);
    s = s
        .replaceAll('ş', 'ș')
        .replaceAll('ţ', 'ț')
        .replaceAll('Ş', 'Ș')
        .replaceAll('Ţ', 'Ț')
        .replaceAll('’', "'")
        .replaceAll('‘', "'")
        .replaceAll('ʼ', "'")
        .replaceAll(_multiSpaces, ' ');
    return s;
  }

  /// Normalisation pour comparaison (§4.1 point 4) :
  /// insensible à la casse et à la ponctuation finale (`.`, `!`, `?`).
  static String normalizeForComparison(String input) {
    final norm = normalize(input).toLowerCase();
    return norm.replaceAll(_trailingPunctuation, '').trim();
  }

  /// Supprime les signes diacritiques après décomposition NFD.
  static String stripDiacritics(String input) {
    final nfd = unorm.nfd(normalize(input));
    return nfd.replaceAll(_combiningDiacritics, '');
  }

  /// Correction à trois états (§4.2) :
  /// - `correct` (1.0 pt)
  /// - `almost` (0.5 pt) : égal sans diacritiques mais pas avec, hors paires minimales strictes
  /// - `wrong` (0.0 pt)
  static AnswerEvaluation evaluateAnswer({
    required String input,
    required String expected,
    List<String> acceptedAnswers = const [],
    List<String> variants = const [],
    String langCode = 'fr',
  }) {
    final normInput = normalizeForComparison(input);
    if (normInput.isEmpty) {
      return const AnswerEvaluation(
        status: AnswerStatus.wrong,
        feedback: 'Réponse vide.',
      );
    }

    final candidates = <String>[
      expected,
      ...acceptedAnswers,
      ...variants,
    ].map(normalizeForComparison).where((c) => c.isNotEmpty).toList();

    for (final candidate in candidates) {
      if (normInput == candidate) {
        return const AnswerEvaluation(
          status: AnswerStatus.correct,
          feedback: 'Exact !',
        );
      }
    }

    // Règle d'exception : paires minimales strictes (ex. a / à en français)
    final strictPairs = _strictMinimalPairGroups[langCode] ?? const <String>{};
    final normExpected = normalizeForComparison(expected);
    if (strictPairs.contains(normExpected) || strictPairs.contains(normInput)) {
      return const AnswerEvaluation(
        status: AnswerStatus.wrong,
        feedback: 'Incorrect.',
      );
    }

    final strippedInput = stripDiacritics(normInput).replaceAll(_trailingPunctuation, '').trim();
    for (final candidate in candidates) {
      final strippedCandidate =
          stripDiacritics(candidate).replaceAll(_trailingPunctuation, '').trim();
      if (strippedInput == strippedCandidate) {
        return const AnswerEvaluation(
          status: AnswerStatus.almost,
          feedback: 'Presque — attention aux accents',
        );
      }
    }

    return const AnswerEvaluation(
      status: AnswerStatus.wrong,
      feedback: 'Incorrect.',
    );
  }

  /// Normalise une entrée du Vocabulaire (`WordsTable`) ou d'une fiche morphologique
  /// pour le pont bidirectionnel (§6.2 & §7.1).
  static String normalizeVocabularyLookupKey(String langCode, String raw) {
    var s = normalize(raw).toLowerCase();
    final lang = langCode.trim().toLowerCase();
    switch (lang) {
      case 'en':
        if (s.startsWith('to ') && s.length > 3) {
          s = s.substring(3).trim();
        }
      case 'ro':
        if (s.startsWith('a se ') && s.length > 5) {
          s = s.substring(5).trim();
        } else if (s.startsWith('a ') && s.length > 2) {
          s = s.substring(2).trim();
        }
      case 'fr':
        if (s.startsWith('se ') && s.length > 3) {
          s = s.substring(3).trim();
        } else if (s.startsWith("s'") && s.length > 2) {
          s = s.substring(2).trim();
        }
      case 'de':
        for (final prefix in const ['der/die/das ', 'der ', 'die ', 'das ', 'sich ']) {
          if (s.startsWith(prefix) && s.length > prefix.length) {
            s = s.substring(prefix.length).trim();
            break;
          }
        }
      default:
        break;
    }
    return s;
  }
}
