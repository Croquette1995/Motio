import 'dart:convert';

class SeedLanguageSpec {
  final String code;
  final Map<String, String> nameL10n;
  final bool isNonLatin;
  final Map<String, dynamic> grammarProfile;

  const SeedLanguageSpec({
    required this.code,
    required this.nameL10n,
    this.isNonLatin = false,
    required this.grammarProfile,
  });

  String get nameL10nJson => jsonEncode(nameL10n);
  String get grammarProfileJson => jsonEncode(grammarProfile);
}

final List<SeedLanguageSpec> seedLanguagesV13 = [
  SeedLanguageSpec(
    code: 'fr',
    nameL10n: const {'fr': 'Français', 'en': 'French'},
    grammarProfile: _frProfile,
  ),
  SeedLanguageSpec(
    code: 'ro',
    nameL10n: const {'fr': 'Roumain', 'en': 'Romanian'},
    grammarProfile: _roProfile,
  ),
  SeedLanguageSpec(
    code: 'de',
    nameL10n: const {'fr': 'Allemand', 'en': 'German'},
    grammarProfile: _deProfile,
  ),
  SeedLanguageSpec(
    code: 'en',
    nameL10n: const {'fr': 'Anglais', 'en': 'English'},
    grammarProfile: _enProfile,
  ),
];

final Map<String, dynamic> _frProfile = {
  'has_verb_groups': true,
  'verb_groups': ['1er groupe (-er)', '2e groupe (-ir)', '3e groupe'],
  'has_auxiliaries': true,
  'auxiliaries': ['avoir', 'être'],
  'has_pronominal_verbs': true,
  'reflexive_cases': <String>[],
  'subject_pronouns': {
    '1_SG': {'form': 'je', 'elided': "j'"},
    '2_SG': {'form': 'tu'},
    '3_SG': {'form': 'il/elle'},
    '1_PL': {'form': 'nous'},
    '2_PL': {'form': 'vous'},
    '3_PL': {'form': 'ils/elles'},
  },
  'elision_pattern': r'^[aeiouyhàâéèêëîïôûù]',
  'genders': ['MASC', 'FEM'],
  'has_declensions': false,
  'cases': <String>[],
  'case_labels_l10n': <String, dynamic>{},
  'has_declension_classes': false,
  'declension_classes': <String>[],
  'declension_paradigms': <Map<String, dynamic>>[],
  'paradigms': [
    {'mood': 'IND', 'tense': 'PRS', 'kind': 'simple', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Indicatif présent'}},
    {'mood': 'IND', 'tense': 'IMPF', 'kind': 'simple', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Indicatif imparfait'}},
    {'mood': 'IND', 'tense': 'PS', 'kind': 'simple', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Passé simple'}},
    {'mood': 'IND', 'tense': 'FUT', 'kind': 'simple', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Futur simple'}},
    {'mood': 'IND', 'tense': 'PC', 'kind': 'compound', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Passé composé'}},
    {'mood': 'IND', 'tense': 'PQP', 'kind': 'compound', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Plus-que-parfait'}},
    {'mood': 'SBJV', 'tense': 'PRS', 'kind': 'simple', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Subjonctif présent'}},
    {'mood': 'COND', 'tense': 'PRS', 'kind': 'simple', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Conditionnel présent'}},
    {
      'mood': 'IMP',
      'tense': 'PRS',
      'kind': 'simple',
      'dimensions': ['person', 'number'],
      'slots': [
        {'person': 2, 'number': 'SG'},
        {'person': 1, 'number': 'PL'},
        {'person': 2, 'number': 'PL'},
      ],
      'label_l10n': {'fr': 'Impératif présent'},
    },
    {'mood': 'PART', 'tense': 'PRS', 'kind': 'simple', 'dimensions': <String>[], 'label_l10n': {'fr': 'Participe présent'}},
    {'mood': 'PART', 'tense': 'PST', 'kind': 'simple', 'dimensions': ['gender', 'number'], 'label_l10n': {'fr': 'Participe passé'}},
  ],
};

final Map<String, dynamic> _roProfile = {
  'has_verb_groups': true,
  'verb_groups': ['Conjugarea I (-a)', 'Conjugarea II (-ea)', 'Conjugarea III (-e)', 'Conjugarea IV (-i/-î)'],
  'has_auxiliaries': true,
  'auxiliaries': ['a avea', 'a fi', 'a vrea'],
  'has_pronominal_verbs': true,
  'reflexive_cases': ['ACC', 'DAT'],
  'subject_pronouns': null,
  'genders': ['MASC', 'FEM', 'NEUT'],
  'has_declensions': true,
  'cases': ['NOM_ACC', 'GEN_DAT', 'VOC'],
  'case_labels_l10n': {
    'NOM_ACC': {'fr': 'Nominatif-Accusatif'},
    'GEN_DAT': {'fr': 'Génitif-Datif'},
    'VOC': {'fr': 'Vocatif'},
  },
  'has_declension_classes': true,
  'declension_classes': ['Nom régulier', 'Nom animé (vocatif propre)'],
  'declension_paradigms': [
    {
      'pos': 'NOUN',
      'dimensions': ['case', 'number', 'definiteness'],
      'slots': [
        {'case': 'NOM_ACC', 'number': 'SG', 'definiteness': 'INDEF'},
        {'case': 'NOM_ACC', 'number': 'SG', 'definiteness': 'DEF'},
        {'case': 'GEN_DAT', 'number': 'SG', 'definiteness': 'INDEF'},
        {'case': 'GEN_DAT', 'number': 'SG', 'definiteness': 'DEF'},
        {'case': 'NOM_ACC', 'number': 'PL', 'definiteness': 'INDEF'},
        {'case': 'NOM_ACC', 'number': 'PL', 'definiteness': 'DEF'},
        {'case': 'GEN_DAT', 'number': 'PL', 'definiteness': 'INDEF'},
        {'case': 'GEN_DAT', 'number': 'PL', 'definiteness': 'DEF'},
      ],
      'label_l10n': {'fr': 'Déclinaison standard du nom (8 formes : indéfini / défini enclitique)'},
    },
    {
      'pos': 'ADJ',
      'dimensions': ['case', 'gender', 'number'],
      'slots': [
        {'case': 'NOM_ACC', 'gender': 'MASC', 'number': 'SG'},
        {'case': 'NOM_ACC', 'gender': 'FEM', 'number': 'SG'},
        {'case': 'NOM_ACC', 'gender': 'MASC', 'number': 'PL'},
        {'case': 'NOM_ACC', 'gender': 'FEM', 'number': 'PL'},
        {'case': 'GEN_DAT', 'gender': 'FEM', 'number': 'SG'},
      ],
      'label_l10n': {'fr': "Accord et déclinaison de l'adjectif"},
    },
  ],
  'paradigms': [
    {'mood': 'IND', 'tense': 'PRS', 'kind': 'simple', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Indicatif présent'}},
    {'mood': 'IND', 'tense': 'PERF_COMP', 'kind': 'compound', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Perfect compus'}},
    {'mood': 'SBJV', 'tense': 'PRS', 'kind': 'simple', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Conjunctiv prezent'}},
    {
      'mood': 'IMP',
      'tense': 'PRS',
      'kind': 'simple',
      'dimensions': ['person', 'number'],
      'slots': [
        {'person': 2, 'number': 'SG'},
        {'person': 2, 'number': 'PL'},
      ],
      'label_l10n': {'fr': 'Imperativ'},
    },
  ],
};

List<Map<String, dynamic>> _de16Slots([String? definiteness]) {
  final out = <Map<String, dynamic>>[];
  for (final c in const ['NOM', 'ACC', 'DAT', 'GEN']) {
    for (final g in const ['MASC', 'FEM', 'NEUT']) {
      out.add({
        if (definiteness != null) 'definiteness': definiteness,
        'case': c,
        'gender': g,
        'number': 'SG',
      });
    }
    out.add({
      if (definiteness != null) 'definiteness': definiteness,
      'case': c,
      'number': 'PL',
    });
  }
  return out;
}

final Map<String, dynamic> _deProfile = {
  'has_verb_groups': true,
  'verb_groups': ['Verbe faible (régulier)', 'Verbe fort', 'Verbe mixte', 'Modal / Auxiliaire'],
  'has_auxiliaries': true,
  'auxiliaries': ['haben', 'sein'],
  'has_pronominal_verbs': true,
  'reflexive_cases': ['ACC', 'DAT'],
  'subject_pronouns': {
    '1_SG': {'form': 'ich'},
    '2_SG': {'form': 'du'},
    '3_SG': {'form': 'er/sie/es'},
    '1_PL': {'form': 'wir'},
    '2_PL': {'form': 'ihr'},
    '3_PL': {'form': 'sie/Sie'},
  },
  'genders': ['MASC', 'FEM', 'NEUT'],
  'has_declensions': true,
  'cases': ['NOM', 'ACC', 'DAT', 'GEN'],
  'case_labels_l10n': {
    'NOM': {'fr': 'Nominatif'},
    'ACC': {'fr': 'Accusatif'},
    'DAT': {'fr': 'Datif'},
    'GEN': {'fr': 'Génitif'},
  },
  'has_declension_classes': true,
  'declension_classes': [
    'Starke Deklination',
    'Schwache Deklination (n-Deklination)',
    'Gemischte Deklination',
  ],
  'declension_paradigms': [
    {
      'pos': 'NOUN',
      'dimensions': ['case', 'number'],
      'label_l10n': {'fr': 'Déclinaison du nom (4 cas × Singulier/Pluriel)'},
    },
    {
      'pos': 'DET',
      'dimensions': ['case', 'gender', 'number'],
      'slots': _de16Slots(),
      'label_l10n': {'fr': 'Tableau des déterminants (16 cases : 4 cas × 3 genres + Pluriel)'},
    },
    {
      'pos': 'ADJ',
      'dimensions': ['definiteness', 'case', 'gender', 'number'],
      'slots': [
        ..._de16Slots('DEF'),
        ..._de16Slots('INDEF'),
        ..._de16Slots('ZERO'),
      ],
      'label_l10n': {'fr': "Déclinaison de l'adjectif (48 cases : Faible DEF / Mixte INDEF / Forte ZERO × 16)"},
    },
  ],
  'paradigms': [
    {'mood': 'IND', 'tense': 'PRS', 'kind': 'simple', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Präsens'}},
    {'mood': 'IND', 'tense': 'PRET', 'kind': 'simple', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Präteritum'}},
    {'mood': 'IND', 'tense': 'PERF', 'kind': 'compound', 'dimensions': ['person', 'number'], 'label_l10n': {'fr': 'Perfekt'}},
  ],
};

final Map<String, dynamic> _enProfile = {
  'has_verb_groups': false,
  'verb_groups': <String>[],
  'has_auxiliaries': false,
  'auxiliaries': <String>[],
  'has_pronominal_verbs': false,
  'reflexive_cases': <String>[],
  'subject_pronouns': null,
  'genders': <String>[],
  'has_declensions': false,
  'cases': <String>[],
  'case_labels_l10n': <String, dynamic>{},
  'has_declension_classes': false,
  'declension_classes': <String>[],
  'declension_paradigms': <Map<String, dynamic>>[],
  'paradigms': [
    {
      'mood': 'IND',
      'tense': 'PRS',
      'kind': 'simple',
      'dimensions': ['person', 'number'],
      'slots': [
        {'person': 3, 'number': 'SG'},
        {'person': 'OTHER'},
      ],
      'label_l10n': {'fr': 'Présent simple'},
    },
    {'mood': 'IND', 'tense': 'PST', 'kind': 'simple', 'dimensions': <String>[], 'label_l10n': {'fr': 'Prétérit'}},
    {'mood': 'PART', 'tense': 'PST', 'kind': 'simple', 'dimensions': <String>[], 'label_l10n': {'fr': 'Participe passé'}},
  ],
};

// --- Jeu de données d'acceptation v1.3 (§7.4) ---

List<Map<String, dynamic>> get seedConjugationsV13 => [
      // FR: prendre (irrégulier)
      {
        'lang': 'fr',
        'lemma': 'prendre',
        'group': '3e groupe',
        'auxiliaries': ['avoir'],
        'is_pronominal': false,
        'reflexive_case': null,
        'is_irregular': true,
        'is_defective': false,
        'source': 'manual',
        'is_published': true,
        'general_note': {
          'fr': 'Verbe irrégulier du 3e groupe : double radical (prend- / pren- / prenn-) et participe passé en -is.',
        },
        'forms': [
          {'mood': 'IND', 'tense': 'PRS', 'person': 1, 'number': 'SG', 'form': 'prends', 'is_irregular': true},
          {'mood': 'IND', 'tense': 'PRS', 'person': 2, 'number': 'SG', 'form': 'prends', 'is_irregular': true},
          {'mood': 'IND', 'tense': 'PRS', 'person': 3, 'number': 'SG', 'form': 'prend', 'is_irregular': true},
          {'mood': 'IND', 'tense': 'PRS', 'person': 1, 'number': 'PL', 'form': 'prenons', 'is_irregular': true},
          {'mood': 'IND', 'tense': 'PRS', 'person': 2, 'number': 'PL', 'form': 'prenez', 'is_irregular': true},
          {'mood': 'IND', 'tense': 'PRS', 'person': 3, 'number': 'PL', 'form': 'prennent', 'is_irregular': true, 'exception_note': {'fr': 'Le n double devant e muet : ils/elles prennent.'}},
          {'mood': 'IND', 'tense': 'PC', 'person': 1, 'number': 'SG', 'auxiliary': 'avoir', 'form': 'ai pris', 'is_irregular': true},
          {'mood': 'SBJV', 'tense': 'PRS', 'person': 1, 'number': 'SG', 'form': 'prenne', 'is_irregular': true},
          {'mood': 'SBJV', 'tense': 'PRS', 'person': 2, 'number': 'SG', 'form': 'prennes', 'is_irregular': true},
          {'mood': 'SBJV', 'tense': 'PRS', 'person': 3, 'number': 'SG', 'form': 'prenne', 'is_irregular': true},
          {'mood': 'SBJV', 'tense': 'PRS', 'person': 1, 'number': 'PL', 'form': 'prenions', 'is_irregular': true},
          {'mood': 'SBJV', 'tense': 'PRS', 'person': 2, 'number': 'PL', 'form': 'preniez', 'is_irregular': true},
          {'mood': 'SBJV', 'tense': 'PRS', 'person': 3, 'number': 'PL', 'form': 'prennent', 'is_irregular': true},
          {'mood': 'IMP', 'tense': 'PRS', 'person': 2, 'number': 'SG', 'form': 'prends'},
          {'mood': 'IMP', 'tense': 'PRS', 'person': 1, 'number': 'PL', 'form': 'prenons'},
          {'mood': 'IMP', 'tense': 'PRS', 'person': 2, 'number': 'PL', 'form': 'prenez'},
        ],
      },
      // FR: monter (double auxiliaire avoir / être)
      {
        'lang': 'fr',
        'lemma': 'monter',
        'group': '1er groupe (-er)',
        'auxiliaries': ['avoir', 'être'],
        'is_pronominal': false,
        'reflexive_case': null,
        'is_irregular': false,
        'is_defective': false,
        'source': 'manual',
        'is_published': true,
        'general_note': {
          'fr': 'Accepte les deux auxiliaires aux temps composés selon la transitivité.',
        },
        'forms': [
          {'mood': 'IND', 'tense': 'PRS', 'person': 1, 'number': 'SG', 'form': 'monte'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 2, 'number': 'SG', 'form': 'montes'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 3, 'number': 'SG', 'form': 'monte'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 1, 'number': 'PL', 'form': 'montons'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 2, 'number': 'PL', 'form': 'montez'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 3, 'number': 'PL', 'form': 'montent'},
          {
            'mood': 'IND',
            'tense': 'PC',
            'person': 1,
            'number': 'SG',
            'auxiliary': 'avoir',
            'form': 'ai monté',
            'is_irregular': true,
            'exception_note': {'fr': "Avec avoir : emploi transitif (j'ai monté les valises)."},
          },
          {
            'mood': 'IND',
            'tense': 'PC',
            'person': 1,
            'number': 'SG',
            'auxiliary': 'être',
            'form': 'suis monté',
            'variants': ['suis montée'],
            'is_irregular': true,
            'exception_note': {'fr': 'Avec être : emploi intransitif (je suis monté au 3e étage).'},
          },
        ],
      },
      // FR: se laver (pronominal)
      {
        'lang': 'fr',
        'lemma': 'se laver',
        'group': '1er groupe (-er)',
        'auxiliaries': ['être'],
        'is_pronominal': true,
        'reflexive_case': null,
        'is_irregular': false,
        'is_defective': false,
        'source': 'manual',
        'is_published': true,
        'general_note': {'fr': 'Verbe pronominal régulier, conjugué avec être aux temps composés.'},
        'forms': [
          {'mood': 'IND', 'tense': 'PRS', 'person': 1, 'number': 'SG', 'pronoun': 'me', 'bare_form': 'lave', 'form': 'me lave'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 2, 'number': 'SG', 'pronoun': 'te', 'bare_form': 'laves', 'form': 'te laves'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 3, 'number': 'SG', 'pronoun': 'se', 'bare_form': 'lave', 'form': 'se lave'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 1, 'number': 'PL', 'pronoun': 'nous', 'bare_form': 'lavons', 'form': 'nous lavons'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 2, 'number': 'PL', 'pronoun': 'vous', 'bare_form': 'lavez', 'form': 'vous lavez'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 3, 'number': 'PL', 'pronoun': 'se', 'bare_form': 'lavent', 'form': 'se lavent'},
          {'mood': 'IND', 'tense': 'PC', 'person': 1, 'number': 'SG', 'auxiliary': 'être', 'pronoun': 'me', 'bare_form': 'suis lavé', 'form': 'me suis lavé', 'variants': ['me suis lavée']},
          {'mood': 'IMP', 'tense': 'PRS', 'person': 2, 'number': 'SG', 'pronoun': '-toi', 'bare_form': 'lave', 'form': 'lave-toi'},
        ],
      },
      // FR: falloir (défectif / impersonnel)
      {
        'lang': 'fr',
        'lemma': 'falloir',
        'group': '3e groupe',
        'auxiliaries': ['avoir'],
        'is_pronominal': false,
        'reflexive_case': null,
        'is_irregular': true,
        'is_defective': true,
        'source': 'manual',
        'is_published': true,
        'general_note': {'fr': 'Verbe strictement impersonnel et défectif : uniquement employé à la 3e personne du singulier (il).'},
        'forms': [
          {'mood': 'IND', 'tense': 'PRS', 'person': 3, 'number': 'SG', 'form': 'faut', 'is_irregular': true},
          {'mood': 'IND', 'tense': 'IMPF', 'person': 3, 'number': 'SG', 'form': 'fallait'},
          {'mood': 'IND', 'tense': 'FUT', 'person': 3, 'number': 'SG', 'form': 'faudra', 'is_irregular': true},
          {'mood': 'IND', 'tense': 'PC', 'person': 3, 'number': 'SG', 'auxiliary': 'avoir', 'form': 'a fallu', 'is_irregular': true},
          {'mood': 'SBJV', 'tense': 'PRS', 'person': 3, 'number': 'SG', 'form': 'faille', 'is_irregular': true, 'exception_note': {'fr': 'Subjonctif présent irrégulier : il faut que / il faille.'}},
        ],
      },
      // RO: a se spăla (pronominal, impératif postposé, élision)
      {
        'lang': 'ro',
        'lemma': 'a se spăla',
        'group': 'Conjugarea I (-a)',
        'auxiliaries': ['a avea'],
        'is_pronominal': true,
        'reflexive_case': 'ACC',
        'is_irregular': false,
        'is_defective': false,
        'source': 'manual',
        'is_published': true,
        'general_note': {'fr': "Verbe pronominal à l'accusatif. Élision m-am spălat au Perfect compus."},
        'forms': [
          {'mood': 'IND', 'tense': 'PRS', 'person': 1, 'number': 'SG', 'pronoun': 'mă', 'bare_form': 'spăl', 'form': 'mă spăl'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 2, 'number': 'SG', 'pronoun': 'te', 'bare_form': 'speli', 'form': 'te speli'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 3, 'number': 'SG', 'pronoun': 'se', 'bare_form': 'spală', 'form': 'se spală'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 1, 'number': 'PL', 'pronoun': 'ne', 'bare_form': 'spălăm', 'form': 'ne spălăm'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 2, 'number': 'PL', 'pronoun': 'vă', 'bare_form': 'spălați', 'form': 'vă spălați'},
          {'mood': 'IND', 'tense': 'PRS', 'person': 3, 'number': 'PL', 'pronoun': 'se', 'bare_form': 'spală', 'form': 'se spală'},
          {'mood': 'IND', 'tense': 'PERF_COMP', 'person': 1, 'number': 'SG', 'auxiliary': 'a avea', 'pronoun': 'm-', 'bare_form': 'am spălat', 'form': 'm-am spălat'},
          {
            'mood': 'IMP',
            'tense': 'PRS',
            'person': 2,
            'number': 'SG',
            'pronoun': '-te',
            'bare_form': 'spală',
            'form': 'spală-te',
            'is_irregular': true,
            'exception_note': {'fr': "À l'impératif affirmatif, le pronom réfléchi est postposé."},
          },
          {'mood': 'IMP', 'tense': 'PRS', 'person': 2, 'number': 'PL', 'pronoun': '-vă', 'bare_form': 'spălați', 'form': 'spălați-vă'},
        ],
      },
      // EN: to go (profil minimal, OTHER)
      {
        'lang': 'en',
        'lemma': 'to go',
        'group': null,
        'auxiliaries': <String>[],
        'is_pronominal': false,
        'reflexive_case': null,
        'is_irregular': true,
        'is_defective': false,
        'source': 'manual',
        'is_published': true,
        'general_note': {'fr': 'Verbe irrégulier fondamental (go / went / gone).'},
        'forms': [
          {'mood': 'IND', 'tense': 'PRS', 'person': 3, 'number': 'SG', 'form': 'goes', 'is_irregular': true, 'exception_note': {'fr': 'Prend -es à la 3e personne du singulier.'}},
          {'mood': 'IND', 'tense': 'PRS', 'person': 'OTHER', 'form': 'go'},
          {'mood': 'IND', 'tense': 'PST', 'form': 'went', 'is_irregular': true},
          {'mood': 'PART', 'tense': 'PST', 'form': 'gone', 'is_irregular': true},
        ],
      },
    ];

List<Map<String, dynamic>> get seedDeclensionsV13 {
  final gutForms = <Map<String, dynamic>>[];
  const endingsDef = {
    'NOM_MASC_SG': 'gute',
    'NOM_FEM_SG': 'gute',
    'NOM_NEUT_SG': 'gute',
    'NOM_PL': 'guten',
    'ACC_MASC_SG': 'guten',
    'ACC_FEM_SG': 'gute',
    'ACC_NEUT_SG': 'gute',
    'ACC_PL': 'guten',
    'DAT_MASC_SG': 'guten',
    'DAT_FEM_SG': 'guten',
    'DAT_NEUT_SG': 'guten',
    'DAT_PL': 'guten',
    'GEN_MASC_SG': 'guten',
    'GEN_FEM_SG': 'guten',
    'GEN_NEUT_SG': 'guten',
    'GEN_PL': 'guten',
  };
  const endingsIndef = {
    'NOM_MASC_SG': 'guter',
    'NOM_FEM_SG': 'gute',
    'NOM_NEUT_SG': 'gutes',
    'NOM_PL': 'guten',
    'ACC_MASC_SG': 'guten',
    'ACC_FEM_SG': 'gute',
    'ACC_NEUT_SG': 'gutes',
    'ACC_PL': 'guten',
    'DAT_MASC_SG': 'guten',
    'DAT_FEM_SG': 'guten',
    'DAT_NEUT_SG': 'guten',
    'DAT_PL': 'guten',
    'GEN_MASC_SG': 'guten',
    'GEN_FEM_SG': 'guten',
    'GEN_NEUT_SG': 'guten',
    'GEN_PL': 'guten',
  };
  const endingsZero = {
    'NOM_MASC_SG': 'guter',
    'NOM_FEM_SG': 'gute',
    'NOM_NEUT_SG': 'gutes',
    'NOM_PL': 'gute',
    'ACC_MASC_SG': 'guten',
    'ACC_FEM_SG': 'gute',
    'ACC_NEUT_SG': 'gutes',
    'ACC_PL': 'gute',
    'DAT_MASC_SG': 'gutem',
    'DAT_FEM_SG': 'guter',
    'DAT_NEUT_SG': 'gutem',
    'DAT_PL': 'guten',
    'GEN_MASC_SG': 'guten',
    'GEN_FEM_SG': 'guter',
    'GEN_NEUT_SG': 'guten',
    'GEN_PL': 'guter',
  };

  for (final entry in [
    MapEntry('DEF', endingsDef),
    MapEntry('INDEF', endingsIndef),
    MapEntry('ZERO', endingsZero),
  ]) {
    final defMode = entry.key;
    for (final slot in _de16Slots(defMode)) {
      final k = slot['number'] == 'PL'
          ? '${slot['case']}_PL'
          : '${slot['case']}_${slot['gender']}_SG';
      final note = switch ((defMode, slot['case'], slot['gender'], slot['number'])) {
        ('DEF', 'DAT', 'MASC', 'SG') => {
            'fr': 'Déclinaison faible (après der/dem) : terminaison -en (ex. mit dem guten Mann).',
          },
        ('INDEF', 'NOM', 'MASC', 'SG') => {
            'fr': 'Déclinaison mixte (après ein/kein/mein) : marque -er du masculin (ex. ein guter Mann).',
          },
        ('ZERO', 'DAT', 'MASC', 'SG') => {
            'fr': "Déclinaison forte (sans article) : l'adjectif porte la marque -em (ex. mit gutem Wein).",
          },
        _ => null,
      };
      gutForms.add({
        ...slot,
        'form': entry.value[k]!,
        if (note != null) 'exception_note': note,
      });
    }
  }

  return [
    // RO: om (NOUN, 8 slots, niște oameni)
    {
      'lang': 'ro',
      'lemma': 'om',
      'pos': 'NOUN',
      'gender': 'MASC',
      'declension_class': 'Nom régulier',
      'is_irregular': true,
      'is_invariable': false,
      'source': 'manual',
      'is_published': true,
      'general_note': {
        'fr': 'Pluriel irrégulier (oameni). L’article défini se soude en suffixe (-ul au Nom/Acc sg, -ului au Gén/Dat sg).',
      },
      'forms': [
        {'case': 'NOM_ACC', 'number': 'SG', 'definiteness': 'INDEF', 'article': 'un', 'bare_form': 'om', 'form': 'un om'},
        {'case': 'NOM_ACC', 'number': 'SG', 'definiteness': 'DEF', 'form': 'omul'},
        {'case': 'GEN_DAT', 'number': 'SG', 'definiteness': 'INDEF', 'article': 'unui', 'bare_form': 'om', 'form': 'unui om'},
        {'case': 'GEN_DAT', 'number': 'SG', 'definiteness': 'DEF', 'form': 'omului'},
        {
          'case': 'NOM_ACC',
          'number': 'PL',
          'definiteness': 'INDEF',
          'article': 'niște',
          'bare_form': 'oameni',
          'form': 'niște oameni',
          'is_irregular': true,
          'exception_note': {'fr': 'Pluriel irrégulier : om -> oameni.'},
        },
        {'case': 'NOM_ACC', 'number': 'PL', 'definiteness': 'DEF', 'form': 'oamenii', 'is_irregular': true},
        {'case': 'GEN_DAT', 'number': 'PL', 'definiteness': 'INDEF', 'article': 'unor', 'bare_form': 'oameni', 'form': 'unor oameni'},
        {'case': 'GEN_DAT', 'number': 'PL', 'definiteness': 'DEF', 'form': 'oamenilor'},
      ],
    },
    // RO: frumos (ADJ, 5 slots)
    {
      'lang': 'ro',
      'lemma': 'frumos',
      'pos': 'ADJ',
      'gender': null,
      'declension_class': null,
      'is_irregular': false,
      'is_invariable': false,
      'source': 'manual',
      'is_published': true,
      'general_note': {'fr': 'Adjectif variable à 4 formes + génitif/datif féminin singulier identique au pluriel féminin.'},
      'forms': [
        {'case': 'NOM_ACC', 'gender': 'MASC', 'number': 'SG', 'form': 'frumos'},
        {'case': 'NOM_ACC', 'gender': 'FEM', 'number': 'SG', 'form': 'frumoasă'},
        {'case': 'NOM_ACC', 'gender': 'MASC', 'number': 'PL', 'form': 'frumoși'},
        {'case': 'NOM_ACC', 'gender': 'FEM', 'number': 'PL', 'form': 'frumoase'},
        {'case': 'GEN_DAT', 'gender': 'FEM', 'number': 'SG', 'form': 'frumoase'},
      ],
    },
    // DE: Tisch (NOUN, Starke Deklination, 8 slots)
    {
      'lang': 'de',
      'lemma': 'Tisch',
      'pos': 'NOUN',
      'gender': 'MASC',
      'declension_class': 'Starke Deklination',
      'is_irregular': false,
      'is_invariable': false,
      'source': 'manual',
      'is_published': true,
      'general_note': {
        'fr': 'Nom masculin de déclinaison forte : prend -(e)s au génitif singulier et -e au pluriel (avec -n au datif pluriel).',
      },
      'forms': [
        {'case': 'NOM', 'number': 'SG', 'article': 'der', 'bare_form': 'Tisch', 'form': 'der Tisch'},
        {'case': 'ACC', 'number': 'SG', 'article': 'den', 'bare_form': 'Tisch', 'form': 'den Tisch'},
        {'case': 'DAT', 'number': 'SG', 'article': 'dem', 'bare_form': 'Tisch', 'form': 'dem Tisch'},
        {'case': 'GEN', 'number': 'SG', 'article': 'des', 'bare_form': 'Tisches', 'form': 'des Tisches', 'variants': ['des Tischs']},
        {'case': 'NOM', 'number': 'PL', 'article': 'die', 'bare_form': 'Tische', 'form': 'die Tische'},
        {'case': 'ACC', 'number': 'PL', 'article': 'die', 'bare_form': 'Tische', 'form': 'die Tische'},
        {
          'case': 'DAT',
          'number': 'PL',
          'article': 'den',
          'bare_form': 'Tischen',
          'form': 'den Tischen',
          'is_irregular': true,
          'exception_note': {'fr': "Au datif pluriel, tous les noms allemands prennent un -n final (s'ils n'en ont pas déjà un)."},
        },
        {'case': 'GEN', 'number': 'PL', 'article': 'der', 'bare_form': 'Tische', 'form': 'der Tische'},
      ],
    },
    // DE: gut (ADJ, 48 slots)
    {
      'lang': 'de',
      'lemma': 'gut',
      'pos': 'ADJ',
      'gender': null,
      'declension_class': null,
      'is_irregular': false,
      'is_invariable': false,
      'source': 'manual',
      'is_published': true,
      'general_note': {
        'fr': 'Adjectif régulier : sa terminaison dépend du déterminant qui le précède (faible DEF après der, mixte INDEF après ein, forte ZERO sans article).',
      },
      'forms': gutForms,
    },
    // DE: der/die/das (DET, 16 slots)
    {
      'lang': 'de',
      'lemma': 'der/die/das',
      'pos': 'DET',
      'gender': null,
      'declension_class': null,
      'is_irregular': false,
      'is_invariable': false,
      'source': 'manual',
      'is_published': true,
      'general_note': {'fr': 'Article défini allemand décliné sur les 4 cas (3 genres au singulier + pluriel commun).'},
      'forms': [
        {'case': 'NOM', 'gender': 'MASC', 'number': 'SG', 'form': 'der'},
        {'case': 'NOM', 'gender': 'FEM', 'number': 'SG', 'form': 'die'},
        {'case': 'NOM', 'gender': 'NEUT', 'number': 'SG', 'form': 'das'},
        {'case': 'NOM', 'number': 'PL', 'form': 'die'},
        {'case': 'ACC', 'gender': 'MASC', 'number': 'SG', 'form': 'den'},
        {'case': 'ACC', 'gender': 'FEM', 'number': 'SG', 'form': 'die'},
        {'case': 'ACC', 'gender': 'NEUT', 'number': 'SG', 'form': 'das'},
        {'case': 'ACC', 'number': 'PL', 'form': 'die'},
        {'case': 'DAT', 'gender': 'MASC', 'number': 'SG', 'form': 'dem'},
        {'case': 'DAT', 'gender': 'FEM', 'number': 'SG', 'form': 'der'},
        {'case': 'DAT', 'gender': 'NEUT', 'number': 'SG', 'form': 'dem'},
        {'case': 'DAT', 'number': 'PL', 'form': 'den'},
        {'case': 'GEN', 'gender': 'MASC', 'number': 'SG', 'form': 'des'},
        {'case': 'GEN', 'gender': 'FEM', 'number': 'SG', 'form': 'der'},
        {'case': 'GEN', 'gender': 'NEUT', 'number': 'SG', 'form': 'des'},
        {'case': 'GEN', 'number': 'PL', 'form': 'der'},
      ],
    },
  ];
}

List<Map<String, dynamic>> get seedLessonsV13 => [
      // DE: nominativ-und-akkusativ-nomen (sans linked_verbs)
      {
        'lang': 'de',
        'slug': 'nominativ-und-akkusativ-nomen',
        'level': 'A1',
        'order': 4,
        'is_published': true,
        'title': {'fr': "Nominatif et Accusatif : l'article masculin change"},
        'prerequisites': <String>[],
        'target_tenses': <Map<String, dynamic>>[],
        'linked_verbs': <String>[],
        'target_cases': ['NOM', 'ACC'],
        'linked_declensions': ['Tisch#NOUN', 'der/die/das#DET'],
        'blocks': [
          {
            'id': 'b_regle_acc',
            'type': 'rule',
            'title': {'fr': 'Le changement au masculin singulier'},
            'content': {
              'fr': "À l'Accusatif (complément d'objet direct), seul le masculin singulier change : 'der' devient 'den' (et 'ein' devient 'einen'). Le féminin, le neutre et le pluriel sont identiques au Nominatif.",
            },
            'examples': [
              {'sentence': 'Der Tisch ist groß. (Nominatif - sujet)', 'highlight': 'Der Tisch'},
              {'sentence': 'Ich kaufe den Tisch. (Accusatif - COD)', 'highlight': 'den Tisch'},
            ],
          },
          {
            'id': 'b_tableau_articles',
            'type': 'table',
            'title': {'fr': 'Récapitulatif des articles définis (Nominatif / Accusatif)'},
            'headers': ['Cas', 'Masculin', 'Féminin', 'Neutre', 'Pluriel'],
            'rows': [
              ['Nominatif', 'der', 'die', 'das', 'die'],
              ['Accusatif', 'den', 'die', 'das', 'die'],
            ],
          },
        ],
        'exercises': [
          {
            'id': 'ex_kaufen_tisch',
            'type': 'cloze',
            'prompt': {'fr': "Complète avec l'article défini correct :"},
            'sentence_before': 'Wir sehen ',
            'sentence_after': ' Tisch (m.).',
            'answer': 'den',
            'accepted_answers': <String>[],
            'distractors': <String>[],
            'explanation': {'fr': "'Tisch' est masculin et COD du verbe 'sehen' -> Accusatif masculin = 'den'."},
          },
          {
            'id': 'ex_nom_tisch',
            'type': 'qcm',
            'prompt': {'fr': 'Choisis la forme correcte au Nominatif :'},
            'sentence_before': '',
            'sentence_after': ' steht im Wohnzimmer.',
            'answer': 'Der Tisch',
            'distractors': ['Den Tisch', 'Dem Tisch', 'Des Tisches'],
            'explanation': {'fr': "'Der Tisch' est sujet du verbe 'steht' -> Nominatif masculin."},
          },
        ],
      },
      // FR: subjonctif-present
      {
        'lang': 'fr',
        'slug': 'subjonctif-present',
        'level': 'B1',
        'order': 1,
        'is_published': true,
        'title': {'fr': 'Le Subjonctif présent après la nécessité'},
        'prerequisites': <String>[],
        'target_tenses': [
          {'mood': 'SBJV', 'tense': 'PRS'},
        ],
        'linked_verbs': ['prendre', 'falloir'],
        'target_cases': <String>[],
        'linked_declensions': <String>[],
        'blocks': [
          {
            'id': 'b_regle_sbjv',
            'type': 'rule',
            'title': {'fr': 'Emploi après il faut que'},
            'content': {
              'fr': 'Le subjonctif présent exprime la nécessité ou la volonté après des locutions comme « il faut que ».',
            },
            'examples': [
              {'sentence': 'Il faut que je prenne le train de 8h.', 'highlight': 'prenne'},
            ],
          },
          {
            'id': 'b_exc_prendre',
            'type': 'exception',
            'title': {'fr': 'Alternance de radical sur prendre'},
            'content': {
              'fr': 'Aux personnes 1/2/3 sg et 3 pl, le radical prend deux n (prenn-). Aux 1/2 pl, un seul n (prenions, preniez).',
            },
          },
        ],
        'exercises': [
          {
            'id': 'ex_sbjv_prendre',
            'type': 'cloze',
            'prompt': {'fr': 'Conjugue prendre au subjonctif présent :'},
            'sentence_before': 'Il faut que tu ',
            'sentence_after': ' ton parapluie.',
            'answer': 'prennes',
            'accepted_answers': <String>[],
            'distractors': <String>[],
            'explanation': {'fr': '2e personne du singulier du subjonctif présent de prendre -> prennes.'},
          },
        ],
      },
      // RO: articolul-hotarat-enclitic
      {
        'lang': 'ro',
        'slug': 'articolul-hotarat-enclitic',
        'level': 'A1',
        'order': 1,
        'is_published': true,
        'title': {'fr': "L'article défini enclitique en roumain"},
        'prerequisites': <String>[],
        'target_tenses': <Map<String, dynamic>>[],
        'linked_verbs': <String>[],
        'target_cases': ['NOM_ACC', 'GEN_DAT'],
        'linked_declensions': ['om#NOUN', 'frumos#ADJ'],
        'blocks': [
          {
            'id': 'b_ro_article',
            'type': 'rule',
            'title': {'fr': 'Soudure en fin de mot'},
            'content': {
              'fr': "Contrairement au français, l'article défini roumain se soude à la fin du nom : un om -> omul, niște oameni -> oamenii.",
            },
            'examples': [
              {'sentence': 'Un om intră. Omul este frumos.', 'highlight': 'Omul'},
            ],
          },
        ],
        'exercises': [
          {
            'id': 'ex_ro_omul',
            'type': 'cloze',
            'prompt': {'fr': "Donne la forme définie de « un om » au Nominatif-Accusatif singulier :"},
            'sentence_before': '',
            'sentence_after': ' citește o carte.',
            'answer': 'Omul',
            'accepted_answers': <String>[],
            'distractors': <String>[],
            'explanation': {'fr': 'om + article défini enclitique -ul -> omul.'},
          },
        ],
      },
      // EN: present-simple-s
      {
        'lang': 'en',
        'slug': 'present-simple-s',
        'level': 'A1',
        'order': 1,
        'is_published': true,
        'title': {'fr': 'Le présent simple et la 3e personne du singulier'},
        'prerequisites': <String>[],
        'target_tenses': [
          {'mood': 'IND', 'tense': 'PRS'},
        ],
        'linked_verbs': ['to go'],
        'target_cases': <String>[],
        'linked_declensions': <String>[],
        'blocks': [
          {
            'id': 'b_en_prs',
            'type': 'rule',
            'title': {'fr': 'Marque -s / -es à he/she/it'},
            'content': {
              'fr': 'En anglais, le présent simple est identique à la base verbale sauf à la 3e personne du singulier (he/she/it) qui prend -s ou -es.',
            },
            'examples': [
              {'sentence': 'She goes to school every morning.', 'highlight': 'goes'},
            ],
          },
        ],
        'exercises': [
          {
            'id': 'ex_en_goes',
            'type': 'cloze',
            'prompt': {'fr': 'Conjugue "to go" au présent simple :'},
            'sentence_before': 'He ',
            'sentence_after': ' to work by train.',
            'answer': 'goes',
            'accepted_answers': <String>[],
            'distractors': <String>[],
            'explanation': {'fr': '3e personne du singulier de to go -> goes.'},
          },
        ],
      },
    ];
