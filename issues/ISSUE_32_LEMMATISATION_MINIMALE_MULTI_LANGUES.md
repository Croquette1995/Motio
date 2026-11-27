# Issue 32 : Lemmatisation minimale multi-langues (formes fléchies → lemme)

Parent : #31 (wordlists Zipf multi-langues). Sous-issue du diagnostic du plafond A1, cause n°4.

## Pourquoi

Aujourd'hui `extractCandidateTokens` et `wordExists` comparent des **formes de surface** :
« dogs », « went », « eating », « trees » ne matchent ni les lemmes de la wordlist
(« dog », « go », « eat », « tree ») ni la base. Effets :

- faux négatifs de niveau : une forme fléchie passe par le fallback (A2/B1) même si son lemme est A1 ;
- doublons sémantiques en base (« dog » et « dogs » comptés comme deux mots) ;
- pour les langues à diacritiques/cas (roumain : ă/â/î/ș/ț, 3 genres), le dédoublonnage par
  forme de surface est encore plus insuffisant.

Pour les langues européennes visées (segmentation par espaces), **pas de segmentation nouvelle
nécessaire** : c'est bien de la lemmatisation, pas de la tokenization complexe (hors scope :
CJK, arabe — non visés).

## Périmètre (palier minimal, sans dépendance)

1. **Lemmatisateur par règles, paramétré par langue** : suffixes pluriel (-s/-es), verbaux
   (-ed/-ing/-s), possessif (’s) pour l'anglais ; règles génériques Romance (fr/es/it/pt/ro :
   pluriels -s/-es/-i/-e, accents) et germaniques (nl/sv/pl simplifiés).
2. **Table d'irréguliers embarquée, minime** : au moins l'anglais (went→go, ate→eat, children→child,
   better→good...), extensible par langue.
3. **Point d'insertion unique** : une fonction `lemmatize(token, language)` utilisée à la fois par
   l'extraction de candidats et par la résolution `wordExists` (tester la forme de surface **puis**
   le lemme). Jamais de transformation destructive de la forme affichée (garder la surface pour
   l'UI/la carte).
4. **Normalisation accents** (dédiacritisation uniquement pour la comparaison, jamais pour l'affichage).

Long terme : le palier complet reste **UniMorph** (#15, déjà crédité) ; ce palier minimal vise
zéro dépendance et zéro réseau.

## Critères d'acceptation

- [ ] en : dogs→dog, went→go, eating→eat, children→child, better→good.
- [ ] Aucun faux lemme sur les mots invariables (be, the, is) ni sur les mots courts (< 3 lettres).
- [ ] Un candidat fléchi hérite du niveau Zipf de son lemme (test : « dogs » → A1 via « dog »).
- [ ] Pas d'IO réseau ni disque dans le chemin d'extraction (pure function, perf équivalente).
- [ ] `flutter analyze --no-fatal-infos` et `flutter test` verts.
