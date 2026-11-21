import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/referentiel/domain/bundle_validator.dart';
import 'package:lexiflow/src/features/referentiel/domain/grammar_profile.dart';

void main() {
  group('BundleValidator', () {
    test('derives uniqueness key dynamically from Slavic paradigm dimensions without validator changes', () {
      final slavicLang = LanguageRecord(
        id: 99,
        code: 'pl',
        nameL10n: const {'fr': 'Polonais'},
        grammarProfile: GrammarProfile.fromJson({
          'has_verb_groups': false,
          'has_auxiliaries': false,
          'has_pronominal_verbs': false,
          'has_declensions': true,
          'cases': ['NOM', 'ACC'],
          'genders': ['MASC', 'FEM', 'NEUT'],
          'dimension_values': {
            'aspect': ['IPFV', 'PFV'],
            'animacy': ['ANIM', 'INAN'],
          },
          'declension_paradigms': [
            {
              'pos': 'NOUN',
              'dimensions': ['case', 'number', 'animacy'],
            },
          ],
          'paradigms': [
            {
              'mood': 'IND',
              'tense': 'PRS',
              'kind': 'simple',
              'dimensions': ['person', 'number', 'aspect'],
            },
          ],
        }),
      );

      // Different aspect -> valid (distinct dynamic uniqueness keys)
      final validBundle = {
        'schema_version': '1.3',
        'lang': 'pl',
        'conjugations': [
          {
            'lemma': 'pisać',
            'forms': [
              {'mood': 'IND', 'tense': 'PRS', 'person': 1, 'number': 'SG', 'aspect': 'IPFV', 'form': 'piszę'},
              {'mood': 'IND', 'tense': 'PRS', 'person': 1, 'number': 'SG', 'aspect': 'PFV', 'form': 'napiszę'},
            ],
          },
        ],
        'declensions': [
          {
            'lemma': 'kot',
            'pos': 'NOUN',
            'forms': [
              {'case': 'ACC', 'number': 'SG', 'animacy': 'ANIM', 'form': 'kota'},
              {'case': 'ACC', 'number': 'SG', 'animacy': 'INAN', 'form': 'kot'},
            ],
          },
        ],
        'lessons': const [],
      };
      final ok = BundleValidator.validateBundle(bundle: validBundle, language: slavicLang);
      expect(ok.isValid, isTrue);

      // Duplicate on dynamic key -> rejected
      final dupBundle = {
        'schema_version': '1.3',
        'lang': 'pl',
        'conjugations': [
          {
            'lemma': 'pisać',
            'forms': [
              {'mood': 'IND', 'tense': 'PRS', 'person': 1, 'number': 'SG', 'aspect': 'IPFV', 'form': 'piszę'},
              {'mood': 'IND', 'tense': 'PRS', 'person': 1, 'number': 'SG', 'aspect': 'IPFV', 'form': 'pisze2'},
            ],
          },
        ],
        'declensions': const [],
        'lessons': const [],
      };
      final fail = BundleValidator.validateBundle(bundle: dupBundle, language: slavicLang);
      expect(fail.isValid, isFalse);
      expect(fail.errors.first.message, contains('Doublon'));
    });

    test('enforces linked_declensions format, declension_class separation, and cycle detection', () {
      final deLang = LanguageRecord(
        id: 3,
        code: 'de',
        nameL10n: const {'fr': 'Allemand'},
        grammarProfile: GrammarProfile.fromJson({
          'has_declensions': true,
          'cases': ['NOM', 'ACC'],
          'genders': ['MASC', 'FEM', 'NEUT'],
          'has_declension_classes': true,
          'declension_classes': ['Starke Deklination'],
          'declension_paradigms': [
            {
              'pos': 'ADJ',
              'dimensions': ['definiteness', 'case', 'gender', 'number'],
              'slots': [
                {'definiteness': 'ZERO', 'case': 'NOM', 'gender': 'MASC', 'number': 'SG'},
              ],
            },
          ],
          'paradigms': const [],
        }),
      );

      final badBundle = {
        'schema_version': '1.3',
        'lang': 'de',
        'conjugations': const [],
        'declensions': [
          {
            'lemma': 'gut',
            'pos': 'ADJ',
            'declension_class': 'Starke Deklination', // forbidden on ADJ
            'forms': [
              {'definiteness': 'ZERO', 'case': 'NOM', 'gender': 'MASC', 'number': 'SG', 'form': 'guter'},
            ],
          },
        ],
        'lessons': [
          {
            'slug': 'l-1',
            'level': 'A1',
            'prerequisites': ['l-2'],
            'linked_declensions': ['Tisch'], // missing #POS
            'blocks': const [],
            'exercises': [
              {
                'id': 'q1',
                'type': 'qcm',
                'answer': 'der',
                'distractors': ['der', 'die'], // answer in distractors
              },
            ],
          },
          {
            'slug': 'l-2',
            'level': 'A1',
            'prerequisites': ['l-1'], // cycle l-1 <-> l-2
            'blocks': const [],
            'exercises': const [],
          },
        ],
      };

      final res = BundleValidator.validateBundle(bundle: badBundle, language: deLang);
      expect(res.isValid, isFalse);
      expect(res.errors.any((e) => e.message.contains('declension_class')), isTrue);
      expect(res.errors.any((e) => e.message.contains('<lemma>#<POS>')), isTrue);
      expect(res.errors.any((e) => e.message.contains('distractors')), isTrue);
      expect(res.errors.any((e) => e.message.contains('Cycle')), isTrue);
    });
  });
}
