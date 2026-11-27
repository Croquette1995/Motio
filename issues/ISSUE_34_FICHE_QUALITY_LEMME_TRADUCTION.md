# Issue 34 : Qualité des fiches d'enrichissement — lemme comme terme, traduction française, sens obsolètes filtrés

## Problème

Des fiches aberrantes sortent du pipeline d'enrichissement automatique (« Enrichir mon niveau »). Exemple constaté : une fiche **« made »** dont le contenu est **« a grub or maggot »** (asticot) — alors que « made » est une forme conjuguée de « make » (« a fait »), et que la traduction affichée est en anglais et fausse.

Trois défauts se combinent :

1. **Des formes fléchies deviennent des fiches.** L'extraction Tatoeba garde les formes de surface (« made », « went », « works »…) et une fiche est créée dès que le lemme n'est pas déjà en base. Le lemmatizer connaît pourtant `made → make`, mais il n'est pas utilisé au moment de créer la fiche.
2. **Le champ « traduction » peut contenir une définition anglaise.** `resolveTranslation` retombe sur `definitions.first` quand la page Wiktionary n'a pas de traduction française : une définition anglaise (souvent absurde) est enregistrée comme traduction d'une fiche fr/en.
3. **Le premier sens venu gagne, même désuet.** L'API de définitions renvoie les sens dans l'ordre de la page. La page Wiktionary « made » liste d'abord un nom étiqueté *(UK, dialectal or obsolete)* — « A grub or maggot », du vieil anglais *maþu* (« asticot ») — avant le verbe. Aucun filtrage des labels `obsolete / archaic / dialectal / dated` n'est appliqué, ni à l'affichage ni au choix de la traduction.

## Cause racine

- `vocab_enrichment_service.dart` : `resolveTranslation` prend `translations.first` puis `definitions.first` sans filtre ; `_addWordFromCandidate` stocke la forme de surface (`candidate.term`) comme terme de fiche.
- `wiktionary_service.dart` : `_parseRestDefinitions` garde tous les sens, sans lire les étiquettes de registre ; le fallback « forme fléchie → lemme » ne se déclenche que si `definitions.isEmpty`, donc jamais quand un sens désuet existe.

## Corrections attendues

- **La fiche est créée sur le lemme** (« made » → fiche « make ») ; la forme fléchie reste visible dans la phrase d'exemple de la carte (règle #58 : toute carte a une phrase source).
- **La traduction est résolue en français uniquement** : forme de surface puis lemme ; sans traduction française, la carte reste « Traduction à préciser » — jamais une définition anglaise.
- **Les sens désuets/archaïques/dialectaux/dated sont écartés** des définitions tant qu'il existe des sens courants.
- **Une seule cible par lemme** dans la file query-first (Issue 33) : « make » et « made » ne valent qu'une requête.

## Vérification

- Wordlist A1 embarquée : 674 candidats → 578 lemmes uniques, le quota CECRL A1 (500) reste atteignable.
- `flutter analyze --no-fatal-infos` : 0 nouvelle info.
- `flutter test` : 198 tests verts, dont 6 nouveaux (lemme stocké, unicité par lemme, traduction via lemme, pas de définition anglaise, filtrage des sens désuets).

## Hors scope

- Le nettoyage des fiches déjà polluées dans les bases SQLite existantes (les mauvaises traductions déjà stockées ne sont pas corrigées par cette issue).
