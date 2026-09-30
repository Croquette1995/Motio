# Issue #2 : Implémentation du module vocabulary (Domain, Data, Mappers, Repositories)

## 📌 Contexte & Objectif
Structurer le domaine métier du vocabulaire selon les principes de Clean Architecture (Feature-First). Isoler l'entité pure `Word` de tout framework de persistance, fournir les interfaces de repository (`IWordRepository`), implémenter la couche d'accès aux données Drift avec des mappers bidirectionnels, et exposer l'état réactif via Riverpod 3.

---

## 🛠 Spécifications Techniques

1. **Couche Domain (`lib/src/features/vocabulary/domain/`)** :
   - `Word` : entité pure immuable (`id`, `term`, `translation`, `contextSentence`, `category`, `level`, `createdAt`).
   - Méthodes `copyWith`, égalité basée sur l'identifiant et le terme.
   - `IWordRepository` (contrat abstrait) :
     - `Future<List<Word>> getAllWords()`
     - `Future<Word?> getWordById(int id)`
     - `Future<List<Word>> getWordsByCategory(String category)`
     - `Future<List<String>> getCategories()`

2. **Couche Data (`lib/src/features/vocabulary/data/`)** :
   - `word_mapper.dart` : extension `WordEntryMapper` convertissant les DTOs générés Drift (`WordEntry`) en entités pures `Word`.
   - `DriftWordRepository` : implémentation concrète de `IWordRepository` exploitant les requêtes typées de `AppDatabase`.

3. **Couche Presentation & State (`lib/src/features/vocabulary/presentation/`)** :
   - `allWordsProvider` : `FutureProvider<List<Word>>`.
   - `categoriesProvider` : `FutureProvider<List<String>>`.
   - `selectedCategoryProvider` : `NotifierProvider` pour le filtrage actif par catégorie.
   - `vocabularySearchQueryProvider` : `NotifierProvider` pour la recherche textuelle dynamique (terme ou traduction).
   - `filteredWordsProvider` : combinaison réactive filtrant la liste en mémoire avec recherche instantanée.
   - `CategoryScreen` : écran de navigation avec puces de sélection de catégorie (ChoiceChips) et affichage des fiches B1-B2.

---

## ✅ Critères d'Acceptation
- [x] Découplage strict : le domaine `Word` ne dépend d'aucun package tiers ni de Drift.
- [x] `DriftWordRepository` implémente rigoureusement l'ensemble des méthodes de `IWordRepository`.
- [x] Recherche et filtrage réactifs opérationnels sans latence sur l'ensemble du vocabulaire.
- [x] Les catégories ("Work & Tech", "Daily Life & Travel", "Social & Abstract") sont correctement extraites et filtrées.

---

## 🧪 Plan de Test
- Validation des requêtes du repository sur base SQLite en mémoire.
- Test de transformation du mapper assurant qu'aucun champ n'est tronqué ni altéré.

---
**Auteur : Corentin Chiodo**
