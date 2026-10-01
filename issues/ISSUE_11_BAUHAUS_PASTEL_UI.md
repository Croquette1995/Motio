# Issue #11 : Refonte intégrale de l'interface utilisateur en style Bauhaus Pastel

## 📌 Contexte & Objectif
Moderniser l'intégralité de l'interface de l'application Motio (LexiFlow) selon une charte graphique et une identité visuelle **Bauhaus Pastel**.
L'objectif est d'offrir une ergonomie épurée, fonctionnelle et contrastée, sans fioritures superflues, en capitalisant directement sur le moteur de thème natif de Flutter (`ThemeData` et `ThemeExtension`).

---

## 🛠 Spécifications Techniques

1. **Palette chromatique Bauhaus Pastel & Extension de Thème** :
   - Fond `chalk` (`#F7F8FA`) blanc cassé / craie
   - Surfaces `cardSurface` (`#FFFFFF`) blanc pur
   - Encre neutre `slate` (`#1E242B`) pour textes, bordures et actions
   - Primaires pastel : `pastelBlue` (`#7BA4D5`), `pastelRed` (`#E98877`), `pastelYellow` (`#F6CC70`), `pastelMint` (`#8DCBB5`)
   - Filets neutres : `lineGrey` (`#E2E5EA`)
   - `BauhausColors extends ThemeExtension<BauhausColors>` avec extension `context.bauhaus`.

2. **Typographie & Micro-interactions** :
   - Typographie géométrique sans-serif pure : police **Jost** (Futura-like) via `google_fonts`.
   - Suppression des halos et ondulations floues (`NoSplash.splashFactory`, `highlightColor: transparent`).
   - Bordures nettes de 1.5px en `slate` avec rayon géométrique contenu de 8 à 12px (`bauhausBorder`).
   - Ombres portées dures et nettes à 45° sans flou (`Offset(2, 2)` / `Offset(3, 3)`).

3. **Éléments graphiques et composants modulaires** :
   - `BauhausProgress` : barre d'avancement modulaire en blocs géométriques rythmés.
   - `BauhausRule` : filet séparateur géométrique (carré rouge, pastille bleue, filet gris).
   - `BauhausCircleThumb` : curseur de slider géométrique (double cercle épuré avec point focal central).

4. **Harmonisation complète des écrans & ateliers** :
   - **Dashboard** : bloc Hero Bauhaus, cartes métriques à décalage franc, sélection de mode et bouton CTA ardoise.
   - **Séance d'apprentissage** : suivi modulaire par blocs et écran de fin de séance avec médaillon et récapitulatif pastel.
   - **Catalogue de vocabulaire** : champ de recherche épuré, puces de filtres et cartes de mots avec badges pastel.
   - **Ateliers** : Canvas de tracé manuscrit, phrases à trous (Cloze), grille d'association (Matching) et accordéon Wiktionnaire.

---

## ✅ Critères d'Acceptation
- [x] Thème global Bauhaus intégré dans `ThemeData` (M3).
- [x] Tous les widgets existants reflètent l'identité visuelle Bauhaus Pastel.
- [x] L'ensemble des tests unitaires et widgets passent avec succès (`flutter test`).
- [x] Analyse statique sans erreur ni avertissement (`flutter analyze`).

---

## 🧪 Plan de Test
- `test/core/theme/bauhaus_theme_test.dart` : vérification des tokens `BauhausColors`, de `BauhausProgress` et `BauhausRule`.
- `test/widget_test.dart` : smoke test du dashboard.
- Suite complète existante (`srs_calculator_test.dart`, `session_scheduler_test.dart`, `wiktionary_service_test.dart`, `wiktionary_enrichment_widget_test.dart`).

---
**Auteur : Corentin Chiodo**
