class WordDefinition {
  final String partOfSpeech;
  final String text;
  final String? example;

  const WordDefinition({
    required this.partOfSpeech,
    required this.text,
    this.example,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordDefinition &&
          runtimeType == other.runtimeType &&
          partOfSpeech == other.partOfSpeech &&
          text == other.text &&
          example == other.example;

  @override
  int get hashCode => partOfSpeech.hashCode ^ text.hashCode ^ example.hashCode;
}

class WordTranslation {
  final String language;
  final String term;

  const WordTranslation({
    required this.language,
    required this.term,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordTranslation &&
          runtimeType == other.runtimeType &&
          language == other.language &&
          term == other.term;

  @override
  int get hashCode => language.hashCode ^ term.hashCode;
}

class WordDetails {
  final String term;
  final List<WordDefinition> definitions;
  final String? etymology;
  final List<String> synonyms;
  final List<WordTranslation> translations;
  final String? frenchBridge;

  const WordDetails({
    required this.term,
    this.definitions = const [],
    this.etymology,
    this.synonyms = const [],
    this.translations = const [],
    this.frenchBridge,
  });

  bool get isEmpty =>
      definitions.isEmpty &&
      (etymology == null || etymology!.trim().isEmpty) &&
      synonyms.isEmpty &&
      translations.isEmpty &&
      (frenchBridge == null || frenchBridge!.trim().isEmpty);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordDetails &&
          runtimeType == other.runtimeType &&
          term == other.term &&
          etymology == other.etymology &&
          frenchBridge == other.frenchBridge;

  @override
  int get hashCode => term.hashCode ^ etymology.hashCode ^ (frenchBridge?.hashCode ?? 0);
}
