# Issue 33 : Enrichissement ciblé par mot-cible (query-first), tirage aléatoire conservé

Parent : #31 (wordlists Zipf multi-langues). Sous-issue du diagnostic du plafond A1, cause n°3
(échantillonnage aléatoire uniforme → rendement quasi nul).

## Pourquoi

Aujourd'hui `runToQuota` fetch des pages `sort=random` **sans requête** : on échantillonne
uniformément ~900 000 phrases et la probabilité qu'une phrase contienne un mot manquant du niveau
actif est quasi nulle une fois les mots les plus courants possédés (~250 phrases analysées pour
1 ajout). On inverse la boucle : **ce n'est plus la phrase qui apporte le mot, c'est le mot qui
choisit la phrase.**

## Design

1. **File de mots-cibles** : à chaque itération, sélectionner un mot manquant du niveau actif
   depuis la wordlist embarquée (#31) — absent de la base, `zipf` dans la fenêtre du niveau,
   round-robin par domaine CECRL (réutiliser la logique de diversité de `selectDiverseBatch`).
2. **Récupération ciblée** : `TatoebaService.getExamplesForWord(word)` existe déjà — l'utiliser
   pour obtenir des phrases bilingues contenant le mot-cible, puis passer le lot dans le filtre
   qualité existant (`isAcceptable`/`rankScore`).
3. **Parking** : si aucune phrase acceptable n'est trouvée pour un mot, le marquer « essayé dans
   ce run » et passer au suivant (jamais de blocage, jamais de carte nue — cohérent avec la règle
   « phrase + traduction obligatoires » de #58). Fin de run = `sourceExhausted` seulement quand
   tous les mots-cibles du run ont été essayés.
4. **Le random reste** : conserver une part de fetch aléatoire (ex. 1 batch aléatoire pour N
   batches ciblés) pour la diversité et pour laisser le hasard découvrir des mots hors file.
   Décision utilisateur : **pas de cache persistant de phrases déjà vues** — le random évite la
   monotonie, et les phrases déjà parcourues reprendront de la valeur quand un niveau supérieur
   cherchera des mots plus rares.

## Critères d'acceptation

- [ ] Rendement mesuré et affiché : mots ajoutés / phrase analysée avant–après (cible : ≥ 1 ordre
      de grandeur d'amélioration à 70+ mots possédés).
- [ ] Un run A1 complète le quota 500 tant que la wordlist contient des mots manquants avec
      phrases disponibles (pas de `sourceExhausted` prématuré).
- [ ] Part aléatoire conservée et paramétrable ; annulation (`isCancelled`) respectée.
- [ ] Aucune carte ajoutée sans phrase + traduction (règle #58 respectée).
- [ ] `flutter analyze --no-fatal-infos` et `flutter test` verts.
