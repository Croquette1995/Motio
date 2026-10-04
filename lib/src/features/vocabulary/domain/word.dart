class Word {
  final int id;
  final String term;
  final String translation;
  final String contextSentence;
  final String category;
  final String level; // 'A1', 'A2', 'B1' or 'B2'
  final String language;
  final String targetLanguage;
  final String pos; // 'noun', 'verb', 'adjective', 'adverb'...
  final double frequencyScore;
  final String? lemma;
  final DateTime createdAt;

  const Word({
    required this.id,
    required this.term,
    required this.translation,
    required this.contextSentence,
    required this.category,
    required this.level,
    this.language = 'en',
    this.targetLanguage = 'fr',
    this.pos = 'noun',
    this.frequencyScore = 4.0,
    this.lemma,
    required this.createdAt,
  });

  Word copyWith({
    int? id,
    String? term,
    String? translation,
    String? contextSentence,
    String? category,
    String? level,
    String? language,
    String? targetLanguage,
    String? pos,
    double? frequencyScore,
    String? lemma,
    DateTime? createdAt,
  }) {
    return Word(
      id: id ?? this.id,
      term: term ?? this.term,
      translation: translation ?? this.translation,
      contextSentence: contextSentence ?? this.contextSentence,
      category: category ?? this.category,
      level: level ?? this.level,
      language: language ?? this.language,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      pos: pos ?? this.pos,
      frequencyScore: frequencyScore ?? this.frequencyScore,
      lemma: lemma ?? this.lemma,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Word &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          term == other.term;

  @override
  int get hashCode => id.hashCode ^ term.hashCode;
}
