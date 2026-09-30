# Issue #5 : Feature Practice Canvas (CustomPainter tactile/souris multiplateforme, révélation, auto-évaluation)

## 📌 Contexte & Objectif
Développer la modalité d'apprentissage phare de LexiFlow : le mode kinesthésique d'écriture manuscrite. Permettre à l'apprenant d'ancrer le mot ciblé dans sa mémoire musculaire en le traçant sur une surface de dessin fluide et multiplateforme (tactile sur mobile, souris/stylet sur desktop et web), avec guidage estompé en option, masquage contextuel, révélation progressive et boucle d'auto-évaluation.

---

## 🛠 Spécifications Techniques

1. **Rendu Graphique (`TracingPainter extends CustomPainter`)** :
   - Tracé vectoriel lissé exploitant l'interpolation de courbes de Bézier quadratiques entre points d'échantillonnage consécutifs (`quadraticBezierTo`).
   - Finitions soignées : `StrokeCap.round`, `StrokeJoin.round`.
   - Lignes de cahier d'écolier dessinées en arrière-plan (ligne médiane en pointillés, ligne de base et ligne supérieure d'ascendante) pour guider le gabarit des lettres.
   - Calque d'aide en filigrane : affichage du mot cible avec typographie à espacement fixe (`monospace`, opacité douce) pour l'écriture guidée.

2. **Capture des Gestes (`GestureDetector` multiplateforme)** :
   - Gestion unifiée tactile / souris (`onPanStart`, `onPanUpdate`, `onPanEnd`).
   - Mémorisation sous forme de structures immuables `DrawingStroke` composées de `StrokePoint`.

3. **Contrôles & Interaction (`CanvasController` & `CanvasPracticeView`)** :
   - Affichage de la phrase de contexte avec le mot masqué sous forme de tirets (`_______`).
   - Affichage du rappel de traduction en français et des badges de catégorie et niveau CEFR (B1/B2).
   - Bouton **Effacer** : réinitialisation complète des tracés.
   - Bouton **Calque estompé / Masquer** : bascule de la visibilité du mot en filigrane.
   - Bouton **Révéler** : affiche le mot en clair et dévoile les boutons de décision.
   - Boutons d'auto-évaluation :
     - **Échec (À revoir)** : marque la carte comme non acquise, déclenche la pénalité SRS et la repositionne en fin de séance.
     - **Succès (Mémorisé)** : valide la mémorisation motrice et passe à la carte suivante.

---

## ✅ Critères d'Acceptation
- [x] Le canvas répond immédiatement sans saccade aux interactions tactiles et à la souris sous Linux Desktop, Mobile et Web.
- [x] Les tracés sont réguliers et anti-aliasés.
- [x] Le bouton effacer vide la zone de dessin instantanément.
- [x] La révélation dévoile la phrase complète et le mot correct.
- [x] L'auto-évaluation notifie le `SessionController` et met à jour les statistiques en temps réel.

---

## 🧪 Plan de Test
- Test de rendu du `CustomPainter` dans un composant de test unitaire Flutter.
- Vérification du déclenchement des callbacks de succès/échec vers le contrôleur de séance.

---
**Auteur : Corentin Chiodo**
