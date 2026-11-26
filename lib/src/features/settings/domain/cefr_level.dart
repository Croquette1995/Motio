/// Bar\u00e8me CECRL : objectifs cumul\u00e9s et quotas de niveau.
///
/// Deux notions coexistent et sont volontairement d\u00e9riv\u00e9es l'une de l'autre :
///
/// - `targetWordCount` : volume **cumul\u00e9** vis\u00e9 en fin de niveau (A1 \u2248 500,
///   A2 \u2248 1200, B1 \u2248 2200, B2 \u2248 3500). C'est la source de v\u00e9rit\u00e9 historique.
/// - `levelWordQuota` : objectif **non cumul\u00e9** du niveau lui-m\u00eame, c'est-\u00e0-dire
///   le nombre de nouveaux mots \u00e0 couvrir pour ce niveau (A1 = 500, A2 = 700,
///   B1 = 1000, B2 = 1300). D\u00e9riv\u00e9 des \u00e9carts entre volumes cumul\u00e9s.
///
/// Sources des bar\u00e8mes :
/// - Milton, J. (2010), *Measuring Second Language Vocabulary Acquisition*
///   (volumes cumul\u00e9s approximatifs par niveau CECRL) ;
/// - English Vocabulary Profile (Cambridge) ;
/// - bar\u00e8mes usuels des cours de langues (~500 mots de survie en A1,
///   ~1000\u20131200 cumul\u00e9s en A2, ~2000\u20132500 cumul\u00e9s en B1, ~3500\u20134000 en B2).
///
/// `levelWordQuota` est la seule r\u00e9f\u00e9rence \u00e0 utiliser pour le suivi de
/// couverture et l'arr\u00eat des pipelines d'enrichissement : ne pas r\u00e9introduire
/// de constantes de quota ailleurs.
enum CefrLevel {
  a1(
    code: 'A1',
    label: 'Niveau A1 \u00b7 D\u00e9butant',
    shortLabel: 'A1 D\u00e9butant',
    description: 'Vocabulaire de base du quotidien (salutations, chiffres, nourriture, verbes courants).',
    targetWordCount: 500,
    levelWordQuota: 500,
    minZipf: 5.5,
  ),
  a2(
    code: 'A2',
    label: 'Niveau A2 \u00b7 \u00c9l\u00e9mentaire',
    shortLabel: 'A2 \u00c9l\u00e9mentaire',
    description: 'Situations courantes (routine, achats, m\u00e9t\u00e9o, pass\u00e9 simple).',
    targetWordCount: 1200,
    levelWordQuota: 700,
    minZipf: 4.5,
  ),
  b1(
    code: 'B1',
    label: 'Niveau B1 \u00b7 Interm\u00e9diaire',
    shortLabel: 'B1 Interm\u00e9diaire',
    description: 'Autonomie et expression (voyages, travail, opinions).',
    targetWordCount: 2200,
    levelWordQuota: 1000,
    minZipf: 3.5,
  ),
  b2(
    code: 'B2',
    label: 'Niveau B2 \u00b7 Avanc\u00e9',
    shortLabel: 'B2 Avanc\u00e9',
    description: 'Ma\u00eetrise avanc\u00e9e (nuances, discussions techniques).',
    targetWordCount: 3500,
    levelWordQuota: 1300,
    minZipf: 2.5,
  );

  final String code;
  final String label;
  final String shortLabel;
  final String description;

  /// Volume cumul\u00e9 vis\u00e9 en fin de niveau (500 / 1200 / 2200 / 3500).
  final int targetWordCount;

  /// Objectif non cumul\u00e9 du niveau (500 / 700 / 1000 / 1300), d\u00e9riv\u00e9 des
  /// \u00e9carts entre volumes cumul\u00e9s du bar\u00e8me CECRL. Voir la doc de l'enum.
  final int levelWordQuota;

  final double minZipf;

  const CefrLevel({
    required this.code,
    required this.label,
    required this.shortLabel,
    required this.description,
    required this.targetWordCount,
    required this.levelWordQuota,
    required this.minZipf,
  });

  static CefrLevel fromCode(String code, {CefrLevel fallback = CefrLevel.a1}) {
    final upper = code.toUpperCase().trim();
    for (final l in CefrLevel.values) {
      if (l.code == upper) return l;
    }
    return fallback;
  }
}
