# Issue #12 : Correction du statut « À réviser » (SRS), fiabilisation de l'API Wiktionnaire et intégration du pont linguistique français

## 📌 Contexte & Problématique

1. **Échec d'un mot non marqué comme « À réviser »** :
   - Lorsqu'un apprenant échouait sur un mot au cours d'une séance d'apprentissage, la carte était revalidée en fin de session pour vider la file d'attente active (`remainingQueue`).
   - Le moteur SRS reprogrammait alors l'échéance à J+1 (`now + 1 jour`), annulant immédiatement la condition `isDue(now)`.
   - Le mot n'apparaissait donc plus dans les mots à réviser, le compteur du tableau de bord retombait à 0 et le badge passait à « En révision » (jaune) au lieu de « À réviser » (rouge).
   - De plus, le provider d'état Riverpod (`wordProgressMapProvider`) n'était pas invalidé lors de la soumission de réponses, et l'upsert SQLite présentait une fragilité en cas de conflit sur `wordId`.

2. **Échec de l'enrichissement linguistique Wiktionnaire (définitions, étymologie, synonymes)** :
   - `baseRestUrl` contenait un slash terminal (`https://en.wiktionary.org/api/rest_v1/`), ce qui générait une URL avec double slash (`.../rest_v1//page/definition/...`) systématiquement rejetée par le proxy Envoy de Wikimédia avec un code **HTTP 404**.
   - La permission `<uses-permission android:name="android.permission.INTERNET"/>` était absente du `AndroidManifest.xml`, bloquant toutes les requêtes réseau sur Android.
   - Le paramètre CORS `origin=*` était absent de l'API Action (`api.php`), provoquant des blocages sous Flutter Web.

3. **Demande d'une corrélation avec le français** :
   - Besoin d'ancrer le vocabulaire anglais B1-B2 avec le français (décorticage littéral des mots composés, cognats et racines communes latines/françaises).

---

## 🛠 Solutions Implémentées

1. **Cycle de Révision SRS & Persistance SQLite** :
   - Dans `SrsService.submitAnswer()`, lorsqu'une carte ré-essayée suite à un échec (`hasFailedOnce == true`) est validée, son échéance est maintenue à `referenceTime` avec `status = WordStatus.review`. Elle reste donc immédiatement disponible dans `getDueProgresses()` et étiquetée « À réviser ».
   - Invalidation immédiate de `wordProgressMapProvider` dans `SessionNotifier.submitAnswer()`.
   - Écoute du provider dans `DashboardScreen` pour actualiser dynamiquement le compteur « À réviser ».
   - Sécurisation de l'upsert dans `DriftProgressRepository.saveProgress()` par recherche préalable sur `wordId`.

2. **API Wiktionnaire & Réseau** :
   - Suppression du slash terminal dans `baseRestUrl = 'https://en.wiktionary.org/api/rest_v1'`.
   - Ajout de la permission Internet dans `android/app/src/main/AndroidManifest.xml`.
   - Ajout du paramètre `origin: '*'` sur l'Action API.
   - Protection du cache mémoire pour ne stocker que les réponses valides.

3. **Pont Linguistique & Ancrage Français** :
   - Création de `french_linguistic_bridges.dart` contenant un dictionnaire d'ancrage cognitif et de ponts linguistiques pour les termes du catalogue B1-B2 (ex: *deadline* = « ligne de mort », *troubleshoot* = « tirer sur les ennuis », *breakthrough* = « briser à travers », *streamline* = « profilé / rationaliser », *collaborate*, *resilience*, *deployment*, etc.).
   - Ajout de l'heuristique `extractFrenchBridge()` dans `WiktionaryService` pour détecter les emprunts et racines françaises dans le wikitexte.
   - Ajout du champ `frenchBridge` dans `WordDetails`.
   - Affichage d'un bloc dédié pastel **« PONT LINGUISTIQUE (FRANÇAIS) »** dans `WiktionaryEnrichmentWidget`.

---

## ✅ Critères d'Acceptation & Tests
- [x] Un mot échoué reste dû pour révision même s'il est revalidé en fin de séance (`isDue == true`, `status == review`).
- [x] Le mot apparaît dans le compteur « À réviser » et dans le catalogue avec le badge « À RÉVISER ».
- [x] L'API REST Wiktionnaire remonte correctement les définitions sans erreur 404.
- [x] L'étymologie, les synonymes et les traductions françaises sont extraits avec succès.
- [x] La permission Internet est présente sur Android.
- [x] Le bloc d'ancrage cognitif français est affiché dans la tuile d'enrichissement.
- [x] 27 / 27 tests passent avec succès (`flutter test`).
- [x] L'analyse statique ne remonte aucune erreur (`flutter analyze`).

---
**Auteur : Corentin Chiodo**
