import '../../../core/database/app_database.dart';
import '../domain/word.dart';

extension WordEntryMapper on WordEntry {
  Word toDomain() {
    return Word(
      id: id,
      term: term,
      translation: translation,
      contextSentence: contextSentence,
      category: category,
      level: level,
      createdAt: createdAt,
    );
  }
}
