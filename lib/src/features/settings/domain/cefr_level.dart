enum CefrLevel {
  a1(
    code: 'A1',
    label: 'Niveau A1 · Débutant',
    shortLabel: 'A1 Débutant',
    description: 'Vocabulaire de base du quotidien (salutations, chiffres, nourriture, verbes courants).',
    targetWordCount: 500,
    minZipf: 5.5,
  ),
  a2(
    code: 'A2',
    label: 'Niveau A2 · Élémentaire',
    shortLabel: 'A2 Élémentaire',
    description: 'Situations courantes (routine, achats, météo, passé simple).',
    targetWordCount: 1200,
    minZipf: 4.5,
  ),
  b1(
    code: 'B1',
    label: 'Niveau B1 · Intermédiaire',
    shortLabel: 'B1 Intermédiaire',
    description: 'Autonomie et expression (voyages, travail, opinions).',
    targetWordCount: 2200,
    minZipf: 3.5,
  ),
  b2(
    code: 'B2',
    label: 'Niveau B2 · Avancé',
    shortLabel: 'B2 Avancé',
    description: 'Maîtrise avancée (nuances, discussions techniques).',
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
