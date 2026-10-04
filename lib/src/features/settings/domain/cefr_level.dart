enum CefrLevel {
  a1(
    code: 'A1',
    label: 'Niveau A1 · Débutant',
    shortLabel: 'A1 Débutant',
    description: 'Vocabulaire vital du quotidien (+/- 500 à 800 mots : salutations, chiffres, nourriture, verbes de base).',
    targetWordCount: 500,
    minZipf: 5.5,
  ),
  a2(
    code: 'A2',
    label: 'Niveau A2 · Élémentaire',
    shortLabel: 'A2 Élémentaire',
    description: 'Survie quotidienne (+/- 1 000 à 1 500 mots : routine, achats, météo, passé simple).',
    targetWordCount: 1200,
    minZipf: 4.5,
  ),
  b1(
    code: 'B1',
    label: 'Niveau B1 · Intermédiaire',
    shortLabel: 'B1 Intermédiaire',
    description: 'Autonomie & expression (+/- 2 000 à 2 500 mots : voyages, travail, opinions).',
    targetWordCount: 2200,
    minZipf: 3.5,
  ),
  b2(
    code: 'B2',
    label: 'Niveau B2 · Avancé',
    shortLabel: 'B2 Avancé',
    description: 'Aisance professionnelle (+/- 3 500 à 4 500 mots : nuances, débats techniques).',
    targetWordCount: 3500,
    minZipf: 2.5,
  );

  final String code;
  final String label;
  final String shortLabel;
  final String description;
  final int targetWordCount;
  final double minZipf;

  const CefrLevel({
    required this.code,
    required this.label,
    required this.shortLabel,
    required this.description,
    required this.targetWordCount,
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
