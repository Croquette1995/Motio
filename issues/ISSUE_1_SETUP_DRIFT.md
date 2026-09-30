# Issue #1 : Setup du projet multiplateforme (Mobile, Linux, Web) et configuration Drift ORM (tables Words et WordProgress + seed B1-B2)

## 📌 Contexte & Objectif
Initialiser le projet Flutter `lexiflow` avec un support multiplateforme complet (Android, iOS, Linux Desktop, Web) et mettre en place la couche de persistance relationnelle locale via l'ORM Drift. Cette étape pose les fondations du stockage hors-ligne, garantit l'intégrité référentielle entre le dictionnaire et le suivi d'apprentissage, et amorce la base de données avec un jeu initial de 30 mots calibrés B1-B2.

---

## 🛠 Spécifications Techniques

1. **Structure de projet & Dépendances** :
   - Flutter 3.47+ / Dart SDK 3.13+.
   - `drift: ^2.35.0` et `drift_flutter: ^0.3.1` pour l'abstraction cross-platform (SQLite FFI sur Mobile/Desktop, SQLite Wasm / IndexedDB sur Web via `driftDatabase(name: 'lexiflow')`).
   - `sqlite3_flutter_libs: ^0.6.0+eol`, `path_provider`, `path`.
   - `build_runner` et `drift_dev` en dépendances de développement.

2. **Schéma de base de données (`AppDatabase`)** :
   - **Table `WordsTable`** :
     - `id` : `integer().autoIncrement()()`
     - `term` : `text().withLength(min: 1, max: 100)()`
     - `translation` : `text().withLength(min: 1, max: 200)()`
     - `contextSentence` : `text()()`
     - `category` : `text().withLength(min: 1, max: 100)()`
     - `level` : `text().withLength(min: 2, max: 10)()` ('B1' ou 'B2')
     - `createdAt` : `dateTime().withDefault(currentDateAndTime)()`
   - **Table `WordProgressTable`** :
     - `id` : `integer().autoIncrement()()`
     - `wordId` : `integer().unique().references(WordsTable, #id, onDelete: KeyAction.cascade)()`
     - `status` : `text()` ('new', 'learning', 'review', 'mastered')
     - `step` : `integer().withDefault(const Constant(0))()`
     - `easeFactor` : `real().withDefault(const Constant(2.5))()`
     - `intervalDays` : `integer().withDefault(const Constant(0))()`
     - `lastReviewedAt` : `dateTime().nullable()()`
     - `nextReviewAt` : `dateTime().nullable()()`
     - `consecutiveSuccesses` : `integer().withDefault(const Constant(0))()`

3. **Seeding automatique (`initial_words_seed.dart`)** :
   - Insertion transactionnelle au premier lancement (`onCreate`) de 30 mots réalistes équilibrés sur 3 thématiques :
     - *Work & Tech* (10 mots : deadline, troubleshoot, brainstorm, etc.)
     - *Daily Life & Travel* (10 mots : commute, itinerary, grocery, etc.)
     - *Social & Abstract* (10 mots : empathy, resilience, compromise, etc.)
   - Initialisation synchronisée des enregistrements `WordProgressTable` avec statut `'new'` et step `0`.

---

## ✅ Critères d'Acceptation
- [x] Le projet compile sans erreur d'analyse statique (`flutter analyze` -> 0 avertissement).
- [x] Les tables `words_table.dart` et `word_progress_table.dart` sont compilées et typées par Drift.
- [x] Le fichier `app_database.g.dart` est généré avec succès par `build_runner`.
- [x] L'instanciation de `AppDatabase` initialise la base et injecte les 30 entrées avec leurs entrées de progression associées.
- [x] Le support Linux Desktop et Mobile fonctionne de manière transparente avec SQLite natif.

---

## 🧪 Plan de Test
- Test d'intégration unitaire en mémoire (`NativeDatabase.memory()`) validant l'insertion et la lecture du seed.
- Vérification de l'intégrité de la contrainte de clé étrangère `wordId -> words(id)`.

---
**Auteur : Corentin Chiodo**
