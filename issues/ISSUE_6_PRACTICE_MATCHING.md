# Issue #6 : Feature Practice Matching (grille de 4/6/8 paires réactives)

## 📌 Contexte & Objectif
Développer la deuxième modalité d'apprentissage de LexiFlow : le mode d'association rapide sous forme de cartes mémoires interactives (Matching Cards). Ce mode sollicite la reconnaissance visuelle immédiate en confrontant le vocabulaire anglais (niveaux B1-B2) à ses équivalents français dans une grille dynamique.

---

## 🛠 Spécifications Techniques

1. **Génération & Modélisation des Cartes (`MatchingPracticeView`)** :
   - Sélection paramétrable de 4, 6 ou 8 paires à partir du dictionnaire actif.
   - Dédoublement automatique de chaque mot en 2 entités `MatchingCardItem` :
     - `MatchingCardType.term` (mot anglais)
     - `MatchingCardType.translation` (traduction française)
   - Mélange aléatoire (shuffle) complet de l'ensemble de la grille.

2. **Mécanique d'Interaction & Animations Réactives** :
   - Sélection du premier élément : mise en valeur visuelle immédiate (fond coloré, bordure primaire).
   - Sélection du second élément :
     - **Paire correcte** : validation visuelle verte (`Colors.green`), texte barré, verrouillage des deux cartes (`isMatched = true`), incrémentation du compteur de paires.
     - **Paire erronée** : bref retour visuel avec temporisation (800ms) pour mémorisation avant désélection automatique.
   - Protection contre le double-clic ou les clics concurrents pendant l'animation via un verrou booléen `_isProcessing`.
   - Bouton de réinitialisation rapide pour recommencer la grille avec un nouveau tirage aléatoire.
   - Callback `onComplete` déclenché dès que l'intégralité des paires a été résolue.

---

## ✅ Critères d'Acceptation
- [x] La grille s'adapte responsivement en 2 colonnes avec ratio d'aspect équilibré (`childAspectRatio: 2.2`).
- [x] L'appariement terme <-> traduction fonctionne dans les deux sens de sélection.
- [x] Deux termes anglais ou deux traductions ne peuvent en aucun cas s'apparier, même par accident.
- [x] Le décompte des paires trouvées est mis à jour en temps réel en haut de l'écran.
- [x] La résolution de toutes les cartes déclenche le passage de la séance.

---

## 🧪 Plan de Test
- Vérification unitaire de l'algorithme d'appariement et de la génération des 2 cartes par mot.
- Test d'intégration de l'état réactif et de l'inhibition des clics pendant la phase de temporisation.

---
**Auteur : Corentin Chiodo**
