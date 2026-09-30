# Issue #3 : Moteur algorithmique de répétition espacée (SRS) et gestionnaire de session (SrsService, calcul d'intervalles, sélection de mots dus vs nouveaux, exclusion des mots vus)

## 📌 Contexte & Objectif
Implémenter le cœur algorithmique de LexiFlow assurant un apprentissage espacé optimal et scientifiquement calibré. Le moteur doit calculer précisément les échéances de rappel (J+1, J+3, J+7, progression exponentielle modulée par la facilité), ordonner les séances de travail avec un plafond strict (15 à 20 cartes max), prioriser les mots en retard (`DUE`), injecter un quota maîtrisé de nouveautés (`NEW`), et appliquer une règle stricte d'exclusion évitant la répétition superflue le même jour.

---

## 🛠 Spécifications Techniques

1. **Entité de Domaine `WordProgress`** :
   - `wordId`, `status` (`new`, `learning`, `review`, `mastered`).
   - `step` (int, 0 à 5+).
   - `easeFactor` (double, plancher = 1.3, défaut = 2.5).
   - `intervalDays` (int), `consecutiveSuccesses` (int).
   - `lastReviewedAt`, `nextReviewAt` (DateTime).
   - Prédicats : `isDue(DateTime now)`, `isNew`.

2. **Règles de Calcul Pur (`SrsCalculator`)** :
   - **Succès** :
     - `step == 0` (Nouveau) -> `step = 1`, `intervalDays = 1`, `status = learning`.
     - `step == 1` -> `step = 2`, `intervalDays = 3`, `status = learning`.
     - `step == 2` -> `step = 3`, `intervalDays = 7`, `status = review`.
     - `step >= 3` -> `step += 1`, `intervalDays = round(intervalDays * easeFactor)`, `status = review` (ou `mastered` si `step >= 5`).
     - Mise à jour temporelle : `nextReviewAt = now + intervalDays`, `lastReviewedAt = now`.
   - **Échec** :
     - Réinitialisation : `step = 1`, `intervalDays = 1`.
     - Ajustement de facilité : `easeFactor = max(1.3, easeFactor - 0.2)`.
     - Réinitialisation des séries : `consecutiveSuccesses = 0`, `status = learning`.
     - Reprogrammation immédiate à J+1 : `nextReviewAt = now + Duration(days: 1)`.

3. **Orchestration de Séance (`SessionSchedulerService` & `SrsService`)** :
   - **Plafond paramétrable** : 15 à 20 cartes maximum par séance.
   - **Ordre de priorité** :
     1. Mots `DUE` (`nextReviewAt <= now`), triés par date d'échéance croissante.
     2. Mots `NEW` pour compléter les créneaux disponibles (plafond configurable, défaut : 5 nouveaux mots max).
   - **Gestion d'échec en cours de séance** :
     - La carte échouée est immédiatement réinjectée en queue de file active (`remainingQueue.addLast(card.copyWith(hasFailedOnce: true))`).
     - L'apprenant doit la revalider avant la fin de la séance (renforcement actif).
     - La persistance en base conserve l'intervalle d'échec fixé à J+1.
   - **Règle d'exclusion même jour** :
     - Dès qu'un mot est validé, son `nextReviewAt` est projeté au minimum à $J+1$ (ou plus).
     - Il ne peut en aucun cas réapparaître dans une nouvelle séance lancée le jour même.

---

## ✅ Critères d'Acceptation
- [x] La classe pure `SrsCalculator` est totalement découplée de Flutter et testable à 100%.
- [x] Les formules mathématiques (intervalles 1, 3, 7, puis exponentiels) respectent fidèlement la spécification.
- [x] Le seuil minimal de facilité (`easeFactor >= 1.3`) est rigoureusement garanti.
- [x] Les mots échoués sont replacés en fin de file dans la session active.
- [x] Les mots validés ont leur révision projetée dans le futur et sont exclus des sessions suivantes du même jour.
- [x] Tous les tests unitaires associés passent avec succès (`flutter test`).

---

## 🧪 Plan de Test
- `srs_calculator_test.dart` : vérification des calculs de paliers (step 0 à 5), dépréciation de l'easeFactor et plancher minimal.
- `session_scheduler_test.dart` : vérification du respect des plafonds de session, de la priorité DUE/NEW et de la rotation FIFO dynamique.

---
**Auteur : Corentin Chiodo**
