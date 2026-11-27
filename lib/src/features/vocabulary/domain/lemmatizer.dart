/// Lemmatisation minimale multi-langues (Issue 32) : formes fléchies → lemme.
///
/// Fonction pure : aucune IO réseau ni disque, aucune dépendance externe
/// (le palier complet reste UniMorph, Issue 15). Jamais destructif : la forme
/// de surface reste celle affichée et stockée ; le lemme ne sert qu'à la
/// comparaison (wordlist de fréquence Issue 31, dédoublonnage en base).
///
/// Un faux lemme n'est jamais grave : il est toujours testé APRÈS la forme de
/// surface et se solde au pire par une absence de correspondance.
library;

const Map<String, String> _englishIrregulars = {
  // Verbes irréguliers les plus fréquents.
  'was': 'be', 'were': 'be', 'been': 'be',
  'has': 'have', 'had': 'have',
  'did': 'do', 'done': 'do',
  'went': 'go', 'gone': 'go',
  'made': 'make', 'came': 'come', 'got': 'get',
  'took': 'take', 'taken': 'take',
  'saw': 'see', 'seen': 'see',
  'ate': 'eat', 'eaten': 'eat',
  'gave': 'give', 'given': 'give',
  'found': 'find', 'knew': 'know', 'known': 'know',
  'said': 'say', 'told': 'tell',
  'thought': 'think', 'brought': 'bring', 'bought': 'buy',
  'felt': 'feel', 'left': 'leave', 'kept': 'keep', 'met': 'meet',
  'paid': 'pay', 'sent': 'send', 'sat': 'sit', 'stood': 'stand',
  'spent': 'spend', 'spoke': 'speak', 'spoken': 'speak',
  'won': 'win', 'wrote': 'write', 'written': 'write',
  'ran': 'run', 'slept': 'sleep', 'drank': 'drink', 'drunk': 'drink',
  'flew': 'fly', 'flown': 'fly', 'grew': 'grow', 'grown': 'grow',
  'heard': 'hear', 'held': 'hold', 'lost': 'lose',
  'built': 'build', 'caught': 'catch', 'chose': 'choose',
  'chosen': 'choose', 'drew': 'draw', 'drawn': 'draw',
  'drove': 'drive', 'driven': 'drive', 'fell': 'fall',
  'fallen': 'fall', 'fought': 'fight', 'led': 'lead',
  'broke': 'break', 'broken': 'break', 'sold': 'sell',
  'stole': 'steal', 'stolen': 'steal', 'sang': 'sing', 'sung': 'sing',
  'swam': 'swim', 'swum': 'swim', 'taught': 'teach',
  'threw': 'throw', 'thrown': 'throw', 'understood': 'understand',
  'wore': 'wear', 'worn': 'wear',
  // Pluriels et comparatifs irréguliers.
  'children': 'child', 'men': 'man', 'women': 'woman',
  'feet': 'foot', 'teeth': 'tooth', 'mice': 'mouse',
  'people': 'person', 'geese': 'goose', 'wives': 'wife',
  'lives': 'life', 'leaves': 'leaf', 'wolves': 'wolf',
  'knives': 'knife', 'halves': 'half', 'shelves': 'shelf',
  'better': 'good', 'best': 'good', 'worse': 'bad', 'worst': 'bad',
  'older': 'old', 'eldest': 'old',
};

/// Mots anglais terminés par « s » qui ne sont pas des pluriels.
const Set<String> _englishInvariantSWords = {
  'this', 'bus', 'gas', 'yes', 'plus', 'news', 'always', 'lens', 'chaos',
  'status', 'virus', 'campus', 'canvas', 'alias', 'analysis', 'axis',
  'basis', 'crisis', 'iris', 'tennis', 'canvass', 'harness',
};

/// Réduit [token] (forme de surface, insensible à la casse) à son lemme selon
/// des règles de suffixes paramétrées par [language] et une table minimale
/// d'irréguliers pour l'anglais. Les mots courts (< 3 lettres) et invariables
/// sont retournés tels quels.
String lemmatize(String token, {String language = 'en'}) {
  final w = token.trim().toLowerCase();
  if (w.length < 3) return w;

  switch (language) {
    case 'en':
      return _lemmatizeEnglish(w);
    case 'fr':
      return _stripSuffixes(w, const ['s']);
    case 'es':
      return _stripSuffixes(w, const ['es', 's']);
    case 'it':
      return _replaceSuffixes(w, const {'i': 'o', 'e': 'a'});
    case 'pt':
      return _replaceSuffixes(w, const {'ões': 'ão', 's': ''});
    case 'ro':
      return _stripSuffixes(w, const ['uri', 'i']);
    case 'de':
      return _stripSuffixes(w, const ['en', 'er', 'e', 's']);
    case 'nl':
      return _stripSuffixes(w, const ['en', 's']);
    case 'sv':
      return _stripSuffixes(w, const ['ar', 'er', 'or']);
    case 'pl':
      return _stripSuffixes(w, const ['ów', 'y', 'i']);
    default:
      return _lemmatizeEnglish(w);
  }
}

String _lemmatizeEnglish(String w) {
  // Possessif : « dog’s » / « dog's » -> « dog ».
  if (w.endsWith("'s") || w.endsWith('’s')) {
    final stem = w.substring(0, w.length - 2);
    return stem.length >= 2 ? stem : w;
  }

  final irregular = _englishIrregulars[w];
  if (irregular != null) return irregular;

  // Pluriels : -ies/-ves avec substitutions, -es après ch/sh/x/z/s, -s sinon.
  if (w.endsWith('ies') && w.length >= 5) {
    return '${w.substring(0, w.length - 3)}y';
  }
  if (w.endsWith('ves') && w.length >= 5) {
    return '${w.substring(0, w.length - 3)}f';
  }
  if (w.length >= 5 &&
      (w.endsWith('ches') ||
          w.endsWith('shes') ||
          w.endsWith('xes') ||
          w.endsWith('zes'))) {
    return w.substring(0, w.length - 2);
  }

  // Formes verbales : -ing/-ed avec gémination (running -> run, stopped -> stop).
  final verbal = _stripVerbalSuffix(w, 'ing') ?? _stripVerbalSuffix(w, 'ed');
  if (verbal != null) return verbal;

  // Pluriel simple -s (hors mots invariables et terminaisons déjà traitées).
  if (w.endsWith('s') &&
      !_englishInvariantSWords.contains(w) &&
      !w.endsWith('ss') &&
      !w.endsWith('us') &&
      !w.endsWith('is')) {
    final stem = w.substring(0, w.length - 1);
    if (stem.length >= 3) return stem;
  }

  return w;
}

String? _stripVerbalSuffix(String w, String suffix) {
  if (!w.endsWith(suffix)) return null;
  final stem = w.substring(0, w.length - suffix.length);
  if (stem.length < 3) return null;

  // Gémination : la consonne finale est doublée et précédée d'une voyelle
  // (running -> runn -> run). Limite connue : filled -> fil (palier minimal).
  if (stem.length >= 4) {
    final last = stem[stem.length - 1];
    final prev = stem[stem.length - 2];
    final before = stem[stem.length - 3];
    final isVowel = 'aeiouy'.contains(before);
    if (last == prev && !'aeiouy'.contains(last) && isVowel) {
      return stem.substring(0, stem.length - 1);
    }
  }
  return stem;
}

/// Règles Romance/germaniques simplifiées : retire les suffixes de pluriel
/// usuels (jamais de transformation si le radical résultant est trop court).
String _stripSuffixes(String w, List<String> suffixes) {
  for (final suffix in suffixes) {
    if (!w.endsWith(suffix) || w.length <= suffix.length) continue;
    final stem = w.substring(0, w.length - suffix.length);
    if (stem.length >= 3) return stem;
  }
  return w;
}

/// Variantes avec substitution (pluriels italiens -i/-e, portugais -ões).
String _replaceSuffixes(String w, Map<String, String> replacements) {
  final entries = replacements.entries.toList()
    ..sort((a, b) => b.key.length.compareTo(a.key.length));
  for (final entry in entries) {
    if (!w.endsWith(entry.key) || w.length <= entry.key.length) continue;
    final stem = w.substring(0, w.length - entry.key.length) + entry.value;
    if (stem.length >= 3) return stem;
  }
  return w;
}
