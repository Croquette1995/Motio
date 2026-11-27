# Issue 31 : Wordlists de fréquence Zipf embarquées multi-langues — lever le plafond A1 (épique)

## Contexte — diagnostic du plafond

L'enrichissement Tatoeba plafonne : à ~70 mots A1, le pipeline parcourt des centaines de phrases
pour ajouter quelques mots, alors que `levelQuota(A1) = 500`. La cause n'est **pas** la source
(Tatoeba : ~900 000 phrases anglaises, largement suffisante) mais un **plafond structurel interne** :

1. **`_curatedEnglishZipf` ne contient que 78 mots A1** (`word_frequency_service.dart`).
   Le pipeline n'accepte un candidat que si `estimatedLevel == level`
   (`vocab_enrichment_service.dart`) : un mot n'est classé A1 que s'il figure dans cette liste.
2. **5 des 78 mots (`be`, `do`, `have`, `other`, `own`) sont aussi des stopwords** et exclus de
   l'extraction → **pool A1 réellement extractible = 73 mots**.
3. **L'heuristique de secours (fallback par longueur) ne peut jamais produire de A1** :
   son score maximum est 5.2 (mots ≤ 4 lettres) alors que `CefrLevel.a1.minZipf = 5.5`.
   Tout mot inconnu est donc classé A2/B1/B2, quelle que soit la phrase source.
4. **Aucune lemmatisation** : « dogs », « went », « eating » ne matchent ni les lemmes du
   dictionnaire ni la base (`wordExists` compare les formes de surface).

Conséquence observée : ~250 phrases analysées pour 1 ajout, puis `sourceExhausted` récurrent.
**La source de vérité du niveau A1 est une liste de 73 mots, pas le corpus.**

## Décision de source : wordfreq (rspeer/wordfreq v3.x)

Comparatif des candidates :

| Source | Licence | Langues | Échelle | Verdict |
|---|---|---|---|---|
| **wordfreq** | code MIT, **data CC BY-SA 4.0 redistribuable** (documenté) | ~100+ dont toutes les langues européennes visées | **Zipf 0–8, identique à l'app** | ✅ **retenue** |
| Google Trillion Word Corpus | dérivée Google Books Ngrams, redistribution incertaine | en surtout | comptes bruts | ❌ licence + couverture |
| FrequencyWords / OpenSubtitles | dérivée sous-titres, licence amont incertaine (rejet #48 sur les sources sous-titres) | nombreuses | comptes bruts | ❌ confiance moindre |
| Leipzig Corpora Collection | CC BY 4.0 | nombreuses | listes de fréquence | 🔄 secours éventuel |

Atouts décisifs de wordfreq :
- `zipf_frequency(word, lang)` sort **exactement l'échelle Zipf** déjà consommée par
  `determineLevel` (seuils `minZipf` inchangés) ;
- langues visées v1 couvertes : en, fr, de, es, it, pt, nl, sv, pl, ro ;
- données figées (~2021) : acceptable pour des fréquences lexicales de surface.

**Obligation d'attribution CC BY-SA 4.0** : créditer Robyn Speer (2022), rspeer/wordfreq v3.0.2
(Zenodo DOI 10.5281/zenodo.7199437) + sources amont, dans l'écran « À propos »
(same emplacement que Tatoeba/Wiktionary/UniMorph).

## Périmètre

1. **Script générateur one-off (Python, hors app)** : exporte par langue un asset embarqué
   `wordlist_<lang>.json` (ou CSV compressé) : `word → zipf`, **formes de surface telles quelles**
   — wordfreq liste « dogs » et « dog » séparément : ne PAS tenter de lemmatiser la wordlist à la
   génération ; c'est au moment du lookup que le lemme (sous-issue #32) résout l'inflection
   (forme de surface testée d'abord, puis lemme). Top N (cible ~10 000 entrées/langue, Zipf ≥ 2.0 ;
   calibrer le poids APK, objectif < 1 Mo/langue).
2. **`WordFrequencyService` multilingue** : charge la wordlist de la langue apprise
   (asset loader + cache), `getFrequencyScore`/`determineLevel` interrogent la wordlist **avant**
   la carte curated ; la carte `_curatedEnglishZipf` est conservée comme override de secours puis
   dépréciée ; le fallback par longueur reste le tout dernier recours (mot absent de tout).
3. **Câblage langue** : la langue apprise (déjà persistée depuis l'onboarding) est propagée de
   `VocabEnrichmentService`/`SentenceQualityFilter` vers `WordFrequencyService` (paramètre
   `language` déjà présent mais inutilisé par la wordlist).
4. **Attribution** : mention CC BY-SA 4.0 / wordfreq dans les crédits (À propos) et README.

Sous-issues :
- #32 Lemmatisation minimale multi-langues (préalable qualité, pas bloquant pour livrer la wordlist)
- #33 Enrichissement ciblé par mot-cible (rendement de la boucle d'acquisition)

Alignement : implémente le socle « listes de fréquence par langue » du **Palier 1** de #58
(l'enrichissement par graphe Wiktionary et la génération LLM restent dans #58).

## Non retenu (décision explicite)

- **Cache persistant de phrases déjà analysées (anti re-scan)** : rejeté. Le tirage aléatoire
  reste voulu (diversité, pas de monotonie), et les phrases déjà vues reprennent de la valeur
  quand un niveau supérieur s'intéresse à des mots plus rares. Le rendement est traité par #33
  (ciblage par mot), pas par la mémorisation.

## Critères d'acceptation

- [ ] Pool A1 anglais extractible **≥ 500 mots** (vs 73 aujourd'hui), mesuré par un test.
- [ ] Un run `runToQuota(A1)` complète le quota 500 sans `sourceExhausted` (test d'intégration).
- [ ] Wordlists embarquées pour : en, fr, de, es, it, pt, nl, sv, pl, ro — poids total APK maîtrisé.
- [ ] `determineLevel` consomme la wordlist de la langue apprise ; seuils `minZipf` inchangés.
- [ ] Attribution CC BY-SA 4.0 (wordfreq) visible dans « À propos ».
- [ ] `flutter analyze --no-fatal-infos` et `flutter test` verts.

## Références

- Diagnostic : `lib/src/features/vocabulary/domain/word_frequency_service.dart`,
  `lib/src/features/vocabulary/application/vocab_enrichment_service.dart`
- Sous-projet connexe : #58 (Palier 1) · barème : `lib/src/features/settings/domain/cefr_level.dart`
