import '../../settings/domain/cefr_level.dart';

class TatoebaSentence {
  final int id;
  final String textEn;
  final String textFr;
  final String? audioUrl;
  final String license;

  const TatoebaSentence({
    required this.id,
    required this.textEn,
    required this.textFr,
    this.audioUrl,
    this.license = 'CC BY 2.0 FR',
  });
}

class ExtractedCandidateWord {
  final String term;
  final double frequencyScore;
  final CefrLevel estimatedLevel;
  final bool isAlreadyInDb;
  final String? pos;
  final String? translation;
  final String? suggestedCategory;

  const ExtractedCandidateWord({
    required this.term,
    required this.frequencyScore,
    required this.estimatedLevel,
    required this.isAlreadyInDb,
    this.pos,
    this.translation,
    this.suggestedCategory,
  });

  ExtractedCandidateWord copyWith({
    String? term,
    double? frequencyScore,
    CefrLevel? estimatedLevel,
    bool? isAlreadyInDb,
    String? pos,
    String? translation,
    String? suggestedCategory,
  }) {
    return ExtractedCandidateWord(
      term: term ?? this.term,
      frequencyScore: frequencyScore ?? this.frequencyScore,
      estimatedLevel: estimatedLevel ?? this.estimatedLevel,
      isAlreadyInDb: isAlreadyInDb ?? this.isAlreadyInDb,
      pos: pos ?? this.pos,
      translation: translation ?? this.translation,
      suggestedCategory: suggestedCategory ?? this.suggestedCategory,
    );
  }
}

