# Issue 14 : Segmentation par niveau CECRL (A1, A2, B1, B2) et persistance du profil utilisateur

## Description
Permettre à l'apprenant de segmenter son apprentissage selon le Cadre Européen Commun de Référence pour les Langues (CECRL) : A1 (Débutant, ~500 mots), A2 (Élémentaire, ~1200 mots), B1 (Intermédiaire, ~2200 mots) et B2 (Avancé, ~3500 mots).

## Fonctionnalités
- [x] Création de l'enum `CefrLevel` avec métadonnées linguistiques, seuils de fréquence Zipf et objectifs de volume de mots.
- [x] Contrôleur `UserLevelNotifier` persistant le niveau sélectionné dans `SharedPreferences`.
- [x] Sélecteur de niveau interactif intégré dans la bannière Hero du `DashboardScreen` et dans `SettingsScreen`.
- [x] Filtrage dynamique des cartes d'apprentissage et de révision SRS dans `SessionSchedulerService` selon le niveau actif de l'utilisateur.
- [x] Filtrage par niveau dans le catalogue de vocabulaire (`category_screen.dart` et `vocabulary_controller.dart`).
