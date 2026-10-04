# Issue 15 : Évolution du schéma Drift v2 (Part of Speech, UniMorph & Grammaire universelle)

## Description
Faire évoluer le schéma de base de données Drift pour rendre l'architecture universelle (agnostique de la langue), distinguer la nature grammaticale des mots (POS : nom, verbe, adjectif, adverbe) et intégrer les structures de données pour le standard académique mondial UniMorph (conjugaisons et déclinaisons) et les règles de grammaire.

## Fonctionnalités
- [x] Ajout des colonnes `language`, `targetLanguage`, `pos` (Part of Speech), `frequencyScore` et `lemma` dans `WordsTable` et dans l'entité de domaine `Word`.
- [x] Création de la table `UnimorphFormsTable` pour stocker les formes fléchies associées aux lemmes avec les tags universels UniMorph (`V;PST`, `V;V.PTCP;PST`, `N;PL`...).
- [x] Création de la table `GrammarRulesTable` pour les formules et règles grammaticales par niveau CECRL.
- [x] Migration Drift v1 -> v2 (`schemaVersion = 2`) avec préservation des données existantes et ajout de la méthode de vérification `wordExists`.
- [x] Ajout de 30 mots semences fondamentaux pour les niveaux A1 et A2 (*water, bread, apple, house, travel, kitchen, station...*).
- [x] Affichage du badge grammatical (POS) sur chaque carte de vocabulaire.
