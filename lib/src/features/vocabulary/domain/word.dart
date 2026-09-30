class Word {
  final int id;
  final String term;
  final String translation;
  final String contextSentence;
  final String category;
  final String level; // 'B1' or 'B2'
  final DateTime createdAt;

  const Word({
    required this.id,
    required this.term,
    required this.translation,
    required this.contextSentence,
    required this.category,
    required this.level,
    required this.createdAt,
  });

  Word copyWith({
    int? id,
    String? term,
    String? translation,
    String? contextSentence,
    String? category,
    String? level,
    DateTime? createdAt,
  }) {
    return Word(
      id: id ?? this.id,
      term: term ?? this.term,
      translation: translation ?? this.translation,
      contextSentence: contextSentence ?? this.contextSentence,
      category: category ?? this.category,
      level: level ?? this.level,
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
