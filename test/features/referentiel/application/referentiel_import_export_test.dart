import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/features/referentiel/application/referentiel_import_service.dart';
import 'package:lexiflow/src/features/referentiel/data/drift_referentiel_repository.dart';
import 'package:lexiflow/src/features/referentiel/domain/declension.dart';

void main() {
  late AppDatabase db;
  late DriftReferentielRepository repo;
  late ReferentielImportService importService;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedInitialData();
    repo = DriftReferentielRepository(db);
    importService = ReferentielImportService(repo);
  });

  tearDown(() async {
    await db.close();
  });

  test('v1.3 acceptance dataset is seeded across fr, ro, de, en', () async {
    final langs = await repo.getLanguages();
    expect(langs.map((l) => l.code), containsAll(['fr', 'ro', 'de', 'en']));

    final fr = (await repo.getLanguageByCode('fr'))!;
    expect(fr.grammarProfile.hasDeclensions, isFalse);
    final frVerbs = await repo.getConjugations(fr.id);
    expect(frVerbs.map((v) => v.lemma), containsAll(['prendre', 'monter', 'se laver', 'falloir']));
    final monter = frVerbs.firstWhere((v) => v.lemma == 'monter');
    expect(monter.auxiliaries, ['avoir', 'être']);

    final ro = (await repo.getLanguageByCode('ro'))!;
    expect(ro.grammarProfile.hasDeclensions, isTrue);
    final om = await repo.findDeclensionByLemmaPos(ro.id, 'om', DeclensionPos.noun);
    expect(om, isNotNull);
    expect(om!.forms.length, 8);
    expect(om.forms.any((f) => f.form == 'niște oameni' && f.article == 'niște'), isTrue);
    final frumos = await repo.findDeclensionByLemmaPos(ro.id, 'frumos', DeclensionPos.adj);
    expect(frumos!.forms.length, 5);

    final de = (await repo.getLanguageByCode('de'))!;
    final gut = await repo.findDeclensionByLemmaPos(de.id, 'gut', DeclensionPos.adj);
    expect(gut!.forms.length, 48);
    expect(gut.forms.where((f) => f.definiteness == 'ZERO').length, 16);
    final deLesson = await repo.findLessonBySlug(de.id, 'nominativ-und-akkusativ-nomen');
    expect(deLesson, isNotNull);
    expect(deLesson!.linkedVerbIds, isEmpty);
    expect(deLesson.linkedDeclensionIds.length, 2);

    final en = (await repo.getLanguageByCode('en'))!;
    final toGo = await repo.findConjugationByLemma(en.id, 'to go');
    expect(toGo, isNotNull);
    expect(toGo!.forms.any((f) => f.person == 'OTHER' && f.form == 'go'), isTrue);
  });

  test('Import upsert creates skeletons, forces is_published=false, and locks needs_review', () async {
    final de = (await repo.getLanguageByCode('de'))!;

    final report = await importService.importBundle(
      {
        'schema_version': '1.3',
        'lang': 'de',
        'conjugations': const [],
        'declensions': [
          {
            'lang': 'de',
            'lemma': 'Tisch',
            'pos': 'NOUN',
            'gender': 'MASC',
            'declension_class': 'Starke Deklination',
            'forms': [
              {
                'case': 'NOM',
                'number': 'SG',
                'article': 'der',
                'bare_form': 'Tisch',
                'form': 'der Tisch',
                'needs_review': true,
              },
            ],
          },
        ],
        'lessons': [
          {
            'slug': 'new-de-lesson',
            'level': 'A1',
            'order': 5,
            'title': {'fr': 'Nouvelle leçon'},
            'linked_verbs': ['sehen'], // does not exist yet -> skeleton
            'linked_declensions': ['Stuhl#NOUN'], // does not exist yet -> skeleton
            'blocks': [
              {'id': 'b1', 'type': 'rule', 'title': {'fr': 'Règle'}, 'content': {'fr': 'Texte'}},
            ],
            'exercises': const [],
          },
        ],
      },
      targetLanguage: de,
    );

    expect(report.success, isTrue);
    expect(report.unpublishedRecords, contains('declension:Tisch#NOUN'));
    expect(report.createdSkeletons, containsAll(['conjugation:sehen', 'declension:Stuhl#NOUN']));

    final tisch = await repo.findDeclensionByLemmaPos(de.id, 'Tisch', DeclensionPos.noun);
    expect(tisch!.isPublished, isFalse);
    expect(tisch.canPublish, isFalse);

    // Attempting to publish while needs_review=true stays blocked in repository
    final forced = await repo.upsertDeclension(tisch.copyWith(isPublished: true));
    expect(forced.isPublished, isFalse);
  });
}
