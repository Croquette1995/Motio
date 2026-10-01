# Issue #8 : Correction du flux de révision SRS et visibilité immédiate des mots échoués (reprogrammation due, filtre catalogue et accès direct)

## 📌 Contexte & Objectif
Lors de l'utilisation de LexiFlow, lorsqu'un apprenant échoue sur un mot au cours d'une séance d'apprentissage, ce mot n'apparaissait pas dans la liste des mots à réviser. L'algorithme SRS reportait systématiquement l'échéance à J+1 (`now + 1 jour`) avec le statut `learning`. Par conséquent, le prédicat `isDue(now)` restait faux, la métrique *"À réviser (Due)"* sur le tableau de bord restait à 0, et relancer une séance ne sélectionnait que de nouveaux mots. L'utilisateur était donc dans l'impossibilité de constater et d'évaluer le bon fonctionnement de l'algorithme d'espacement.

Cette issue a pour objectif de rendre immédiatement dues les cartes échouées, de leur assigner le statut `review`, d'afficher un badge explicite *"À réviser"* dans le catalogue, de permettre le filtrage des mots à réviser et de rendre cliquable la carte métrique du tableau de bord.

---

## 🛠 Spécifications Techniques

1. **Reprogrammation sur échec (`SrsCalculator`)** :
   - Lorsqu'un mot est échoué (`isSuccess == false`) :
     - `step = 1`, `intervalDays = 1`.
     - `easeFactor = max(1.3, easeFactor - 0.2)`.
     - `consecutiveSuccesses = 0`.
     - `status = WordStatus.review` (le mot requiert une révision explicite).
     - `nextReviewAt = referenceTime` (le mot est immédiatement dû pour révision).

2. **Orchestration de séance (`SrsService`)** :
   - L'enregistrement en base de données dès l'échec garantit la présence immédiate de la carte dans `dueProgresses`.
   - Si la carte est revalidée au cours de la même session (phase de renforcement actif), sa prochaine échéance est alors projetée à `now + 1 jour` afin de respecter la règle d'exclusion de réapparition intempestive le même jour une fois validée.

3. **Catalogue de Vocabulaire (`vocabulary_controller.dart` & `category_screen.dart`)** :
   - Mise à jour de `wordProgressMapProvider` : si `prog.isDue(now)`, le libellé attribué est `'À réviser'`.
   - Ajout d'un filtre dédié de statut dans le contrôleur (`selectedStatusFilterProvider`) permettant d'isoler les mots à réviser.
   - Ajout du style visuel dédié pour le badge `'À réviser'` (couleur d'avertissement ambre/rouge).

4. **Tableau de Bord (`dashboard_screen.dart`)** :
   - Rendre la carte métrique `"À réviser (Due)"` cliquable pour naviguer directement vers le catalogue avec le filtre des mots à réviser activé.

---

## ✅ Critères d'Acceptation
- [x] Un mot échoué dans `SrsCalculator` ressort avec `isDue(now) == true` et `status == WordStatus.review`.
- [x] Le mot échoué apparaît immédiatement dans `getDueProgresses(asOf: now)` et incrémente le compteur *"À réviser (Due)"*.
- [x] Lancer une nouvelle séance intègre en priorité ce mot dû par rapport aux nouveaux mots.
- [x] Le catalogue de vocabulaire affiche le badge distinctif *"À réviser"* et offre un filtre pour afficher uniquement les mots en attente de révision.
- [x] Tous les tests unitaires existants et nouveaux passent avec succès (`flutter test`).

---

## 🧪 Plan de Test
- `srs_calculator_test.dart` : vérification qu'un échec produit `status == WordStatus.review` et `nextReviewAt == now`.
- `session_scheduler_test.dart` : vérification que les mots échoués / dus sont prioritaires lors de la création d'une session.

---
**Auteur : Corentin Chiodo**
