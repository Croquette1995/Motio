# Issue 29 : Étude — Wikinews / Wikipedia comme source complémentaire d'enrichissement

Épique : Issue 24 — Enrichissement v2 (sous-issue #48 · type « question / étude », **aucune décision d'implémentation acquise avant le verdict**).

## Question

Wikinews produit-il des phrases de meilleure qualité que Tatoeba pour l'enrichissement du vocabulaire ?

## Verdict : **REJET — Tatoeba seul conservé pour l'enrichissement**

Wikinews ne produit **pas** des phrases de meilleure qualité que Tatoeba pour ce cas d'usage, et le projet a de surcroît **cessé d'exister comme source alimentable**. Aucun développement d'ingestion Wikinews/Wikipedia n'est lancé. Les raisons sont consignées ci-dessous pour éviter de reposer la question.

> ⚠️ Ce verdict ne ferme pas la porte à Wikipedia/Wikinews comme **matériau de lecture** (feature « lecture guidée B1/B2 ») — piste distincte, hors périmètre de l'enrichissement. Voir « Conditions de réexamen ».

---

## 1. Fait bloqueur : English Wikinews est fermé

- Le 30 juin 2025, la Wikimedia Foundation publie un rapport de 29 pages (Sister Projects Task Force) sur Wikinews, préconisant la fermeture pour inactivité : engagement volontaire très bas, difficulté à retenir les contributeurs faute de relecteurs actifs.
- La revue constate une **chute d'environ 40 % des contributeurs entre 2019 et 2024** et un raccourcissement continu des articles.
- En novembre 2025, le SPTF recommande officiellement au Board of Trustees d'arrêter définitivement l'activité de Wikinews.
- **Le 4 mai 2026, la Wikimedia Foundation ferme Wikinews** (lecture seule). L'édition anglophone n'est plus une source vivante.

Intégrer en janvier 2027 une API d'extraction sur un projet dont la production est arrêtée ne présente aucun intérêt : le flux s'épuiserait mécaniquement (l'équivalent de `EnrichmentRunStatus.sourceExhausted` dès le premier run).

## 2. Registre lexical : inadapté au barème Zipf de l'app

Le registre journalistique (noms propres, dates, passif, subordonnées enchâssées) est structurellement en conflit avec l'architecture actuelle :

- **Barème de longueur** : `SentenceQualityFilter.maxWordsByLevel` plafonne les phrases admises à 8 mots (A1), 10 (A2), 12 (B1), 15 (B2). La prose journalistique anglaise dépasse largement ces plafonds en moyenne ; après filtrage, le taux d'acceptation serait très faible.
- **Signature de pertinence** : `relevanceScore` compte la proportion de mots pleins dont `determineLevel` renvoie le niveau cible via l'échelle Zipf (`CefrLevel.minZipf` : 5.5/4.5/3.5/2.5). Les listes de fréquence (SUBTLEX, OpenSubtitles) attribuent mécaniquement des scores Zipf bas aux noms propres — le cœur du registre Wikinews — qui sont donc classés « B2 » à tort même quand la phrase est élémentaire. Le bruit serait massif.
- **Clients visés** : l'app est orientée A1→B2 avec traduction française par phrase (check `emptyTranslation`). Le registre Wikinews n'aurait de valeur qu'en lecture autonome B1/B2, pas en extraction de vocabulaire.

## 3. Volume : aucun besoin de source complémentaire

- Tatoeba : plus de **900 000 phrases anglaises relues** dont ~89 % avec audio (avril 2024, miroir manythings.org), et des dizaines de milliers alignées avec traduction française.
- Besoin maximal de l'app : quotas incrémentaux `VocabEnrichmentService.levelQuota` = 500 (A1) / +700 (A2) / +1000 (B1) / +1300 (B2), soit 3 500 mots cumulés (`CefrLevel.targetWordCount`). L'offre Tatoeba dépasse le besoin de deux ordres de grandeur.
- **Il n'existe donc aucun déficit de volume à combler** : une seconde source résoudrait un problème que l'app n'a pas.

## 4. Coût d'intégration (si explosion du besoin un jour)

Pour mémoire, l'adexion de Wikinews exigerait :

- un pipeline de segmentation phrase-par-phrase du wikitexte (aucun alignement de traduction FR disponible par phrase → machine translation ou nouveau résolveur, alors que `TatoebaSentence.textFr` est aujourd'hui fourni nativement) ;
- un détecteur de noms propres et de dates en amont de `WordCategorizerService.categorizeWord` ;
- un dédoublon par hash de texte (les id entiers Tatoeba n'existent pas côté MediaWiki) ;
- toute la batterie de tests du filtre qualité à rejouer sur un corpus « bruité ».

## 5. Impact licence : CC BY-SA = coût réel, bénéfice nul

| Source | Licence | Conséquence pour l'app |
|---|---|---|
| Tatoeba (actuel) | CC BY 2.0 FR (portions CC0) | Simple attribution, déjà gérée (`TatoebaService` capture la licence par phrase) |
| Wikipedia | CC BY-SA 4.0 (+ GFDL) | Partage à l'identique : attribution par phrase + mention licence + lien, suivi de provenance en base, écran de crédits |
| Wikinews | CC BY 2.5 | Même principe, hors projet fermé |
| Wiktionary / Kaikki | CC BY-SA | Concerne la traduction (déjà consommée via `WiktionaryService`), pas les phrases |
| Oxford 3000/5000, English Vocabulary Profile | Propriétaires | Non redistribuables → exclus d'office |

Le copyleft CC BY-SA impose une machinerie de redistribution (attributs, notices, provenance) sans apporter de gain de qualité : c'est un coût pur ici.

## 6. Alternatives évaluées

- **Simple English Wikipedia** : licence CC BY-SA + registre encyclopédique toujours riche en noms propres. Pertinent uniquement comme Corpus de **lecture** B1/B2 (future feature distincte), pas pour l'extraction.
- **Extraction de phrases Wiktionary (Kaikki)** : données massives mais CC BY-SA et volumineuses à embarquer ; gain marginal par rapport au pipeline Tatoeba actuel — non retenu.
- **Listes de fréquence par niveau (Oxford 3000/5000, EVProfile)** : propriétaires, non redistribuables. Le besoin de catégorisation par niveau est déjà couvert par `WordFrequencyService` (Zipf curé) + `WordCategorizerService`.

## Conditions de réexamen

Réouvrir l'étude uniquement si **l'un** de ces signaux apparaît :

1. `EnrichmentRunStatus.sourceExhausted` revient récurrent sur un niveau dont le quota n'est pas atteint (épuisement réel de Tatoeba) ;
2. une feature « lecture B1/B2 » est décidée — Simple English Wikipedia redevient candidate, comme source de lecture et non d'enrichissement.

---

## Références

- Rapport Sister Projects Task Force sur Wikinews (juin 2025), méta.wikimedia.org — recommandation de fermeture ; baisse de 40 % des contributeurs 2019–2024.
- *The Signpost*, « Entirety of Wikinews to be shut down » (31 mars 2026) et édition du 22 mai 2026 : fermeture effective de Wikinews le 4 mai 2026.
- Tatoeba, page de téléchargement : corpus sous CC BY 2.0 FR (portions CC0) ; miroir manythings.org : 944 236 phrases anglaises relues, 89 % avec audio (avril 2024).
- `lib/src/features/vocabulary/domain/sentence_quality_filter.dart` : plafonds de longueur par niveau, check de traduction vide, score Zipf de pertinence.
- `lib/src/features/vocabulary/application/vocab_enrichment_service.dart` : quotas incrémentaux par niveau.
- `lib/src/features/settings/domain/cefr_level.dart` : cibles cumulées 500/1200/2200/3500 et seuils Zipf.
