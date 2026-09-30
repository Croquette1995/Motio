# Issue #7 : Feature Practice Cloze (phrase en contexte avec mot manquant)

## 📌 Contexte & Objectif
Développer la troisième modalité d'apprentissage de LexiFlow : le rappel en contexte par texte à trou (Cloze Test). Ce mode confronte l'utilisateur à des phrases d'exemple authentiques de niveau B1-B2 pour vérifier sa capacité à identifier le mot adéquat selon la syntaxe et le sens général de la phrase.

---

## 🛠 Spécifications Techniques

1. **Génération Contextuelle (`ClozePracticeView`)** :
   - Masquage dynamique du mot cible dans `contextSentence` via une expression régulière insensible à la casse (`RegExp.escape(term)` remplacé par `__________`).
   - Présentation de la traduction française comme indice de rappel.
   - Génération de 3 distracteurs crédibles issus du catalogue de mots de même catégorie ou de la séance.
   - Mélange aléatoire (shuffle) des options proposées pour chaque question.

2. **Validation & Rétroaction Immédiate** :
   - Clic sur une proposition :
     - Si correct : mise en valeur verte (`Colors.green`), apparition de l'icône de succès et affichage d'un message d'ancrage positif.
     - Si incorrect : mise en valeur rouge sur le choix sélectionné, révélation de la bonne réponse en vert, et message de rappel explicite de la traduction.
   - Blocage des clics ultérieurs une fois la réponse soumise (`_isAnswered = true`).
   - Notification asynchrone du résultat (`onAnswerSubmitted(isCorrect)`) après une courte temporisation de lecture (900ms) pour permettre la prise de conscience de la réponse.

---

## ✅ Critères d'Acceptation
- [x] La phrase originale est fidèlement masquée au niveau du mot d'apprentissage cible.
- [x] Les 4 choix proposés comprennent le mot exact et 3 distracteurs distincts.
- [x] La rétroaction visuelle (vert/rouge) indique clairement l'exactitude de la réponse.
- [x] Le résultat alimente le moteur de répétition espacée via le contrôleur de séance.

---

## 🧪 Plan de Test
- Test de détection et masquage du terme dans la phrase exemple.
- Vérification du déclenchement du callback avec `true` en cas de sélection correcte et `false` en cas d'erreur.

---
**Auteur : Corentin Chiodo**
