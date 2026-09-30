# Issue #4 : Configuration de GoRouter (routes déclaratives, injection des paramètres dans Riverpod)

## 📌 Contexte & Objectif
Mettre en place une navigation fluide, moderne et découplée avec `go_router` en liaison directe avec l'injection de dépendances de `Riverpod 3`. Respecter le principe de responsabilité unique : aucune logique métier ni traitement asynchrone ne doit résider dans les définitions de routes.

---

## 🛠 Spécifications Techniques

1. **Architecture de Routage (`lib/src/routing/app_router.dart`)** :
   - Déclaration via un `Provider<GoRouter>` exposé au conteneur Riverpod.
   - Routes déclaratives :
     - `/` : `DashboardScreen` (tableau de bord, statistiques des cartes dues/neuves, sélection de mode et CTA de lancement).
     - `/vocabulary` : `CategoryScreen` (liste filtrable par thématique et recherche de termes).
     - `/session` : `SessionScreen` (écran unifié d'apprentissage géré par la machine à états `SessionController`).

2. **Intégration Riverpod 3 & Cycle de vie** :
   - Liaison avec `MaterialApp.router` dans `lib/src/app.dart`.
   - Utilisation de `Notifier` et `NotifierProvider` pour assurer la pérennité de l'état lors des changements de page.
   - Initialisation préalable du conteneur dans `main.dart` avec déclenchement asynchrone du seed SQLite sans bloquer le rendu graphique.

---

## ✅ Critères d'Acceptation
- [x] Les routes sont déclarées de manière immuable et sans effet de bord.
- [x] La transition entre le tableau de bord, la séance active et le catalogue de vocabulaire fonctionne instantanément.
- [x] L'état de la séance active est préservé lors des redimensionnements ou changements d'orientation.
- [x] Zéro logique métier présente dans le fichier de routage.

---

## 🧪 Plan de Test
- `widget_test.dart` : vérification du chargement de l'arbre de widgets avec `MaterialApp.router` et injection d'un conteneur avec base de données SQLite en mémoire.

---
**Auteur : Corentin Chiodo**
