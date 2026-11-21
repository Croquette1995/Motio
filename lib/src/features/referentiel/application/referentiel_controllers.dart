import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_providers.dart';
import '../domain/conjugation.dart';
import '../domain/declension.dart';
import '../domain/grammar_lesson.dart';
import '../domain/grammar_profile.dart';
import 'vocabulary_bridge_service.dart';
import '../../vocabulary/domain/word.dart';

class ActiveReferentielLangNotifier extends Notifier<String> {
  @override
  String build() => 'fr';

  void select(String code) => state = code;
}

final activeReferentielLangProvider =
    NotifierProvider<ActiveReferentielLangNotifier, String>(ActiveReferentielLangNotifier.new);

class StudioModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setEnabled(bool enabled) => state = enabled;
  void toggle() => state = !state;
}

final referentielStudioModeProvider =
    NotifierProvider<StudioModeNotifier, bool>(StudioModeNotifier.new);

final referentielLanguagesProvider = FutureProvider<List<LanguageRecord>>((ref) async {
  final repo = ref.watch(referentielRepositoryProvider);
  return repo.getLanguages();
});

final activeLanguageRecordProvider = FutureProvider<LanguageRecord?>((ref) async {
  final langs = await ref.watch(referentielLanguagesProvider.future);
  final activeCode = ref.watch(activeReferentielLangProvider);
  if (langs.isEmpty) return null;
  return langs.firstWhere(
    (l) => l.code == activeCode,
    orElse: () => langs.first,
  );
});

final referentielConjugationsProvider =
    FutureProvider<List<ConjugationRecord>>((ref) async {
  final lang = await ref.watch(activeLanguageRecordProvider.future);
  if (lang == null) return [];
  final isStudio = ref.watch(referentielStudioModeProvider);
  final repo = ref.watch(referentielRepositoryProvider);
  return repo.getConjugations(lang.id, publishedOnly: !isStudio);
});

final referentielDeclensionsProvider =
    FutureProvider<List<DeclensionRecord>>((ref) async {
  final lang = await ref.watch(activeLanguageRecordProvider.future);
  if (lang == null || !lang.grammarProfile.hasDeclensions) return [];
  final isStudio = ref.watch(referentielStudioModeProvider);
  final repo = ref.watch(referentielRepositoryProvider);
  return repo.getDeclensions(lang.id, publishedOnly: !isStudio);
});

final referentielLessonsProvider =
    FutureProvider<List<GrammarLessonRecord>>((ref) async {
  final lang = await ref.watch(activeLanguageRecordProvider.future);
  if (lang == null) return [];
  final isStudio = ref.watch(referentielStudioModeProvider);
  final repo = ref.watch(referentielRepositoryProvider);
  return repo.getLessons(lang.id, publishedOnly: !isStudio);
});

final lessonProgressMapProvider =
    FutureProvider<Map<int, LessonProgressRecord>>((ref) async {
  final repo = ref.watch(referentielRepositoryProvider);
  return repo.getAllLessonProgress();
});

final wordMorphologyLinksProvider =
    FutureProvider.family<VocabularyMorphologyLinks, Word>((ref, word) async {
  final bridge = ref.watch(vocabularyBridgeServiceProvider);
  return bridge.findMorphologyForWord(word);
});
