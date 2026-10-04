# Issue 16 : Exploration Tatoeba, calcul de fréquence Zipf et anti-doublon Drift (100% Zéro Clé API)

## Description
Mettre en place un pipeline d'exploration et d'ingestion de vocabulaire gratuit et autonome sans clé API : récupération de phrases bilingues sur l'API publique Tatoeba, découpage en mots et filtre de mots vides (stopwords), calcul de difficulté via la fréquence de Zipf, déduplication contre SQLite, et écran interactif d'exploration.

## Fonctionnalités
- [x] Service `WordFrequencyService` : calcul du score de fréquence Zipf et déduction du niveau CECRL.
- [x] Service `TatoebaService` : client API Tatoeba public, tokenisation avec exclusion des stopwords anglais (*the, is, at, of...*).
- [x] Vérification déterministe anti-doublon dans SQLite via Drift (`isAlreadyInDb`).
- [x] Contrôleur Riverpod `TatoebaExplorerController` pour gérer le flux de recherche et d'ajout.
- [x] Écran `TatoebaExplorerScreen` (`/tatoeba`) avec design Bauhaus Pastel, tirage aléatoire, affichage des phrases bilingues, badges de niveau et bouton d'ajout au deck en 1 clic.
- [x] Suite complète de tests unitaires validant l'ensemble du flux.
