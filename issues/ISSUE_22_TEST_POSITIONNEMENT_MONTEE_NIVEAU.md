# Issue 22 : Test de positionnement et suggestion de montée en niveau

Épique : #Issue 19 (UX v2) — dépend de Issue 21 (verrouillage par niveau)

## Problème
Deux moments sont mal couverts :
- au premier lancement, l'utilisateur ne sait pas forcément quel niveau choisir ;
- une fois un niveau maîtrisé, l'application ne dit jamais « tu es prêt pour le niveau suivant » — l'utilisateur devrait deviner quand changer dans Paramètres.

## Solution proposée
1. **Test de positionnement (à l'onboarding)** : option « Je ne sais pas mon niveau » → quiz court (~10 mots extraits par niveau depuis le corpus existant, du plus courant au plus rare). Le niveau recommandé = dernier niveau où l'utilisateur reconnaît encore la majorité des mots. Pré-sélection à l'écran « confirmer le niveau » de l'onboarding (Issue 20).
2. **Suggestion de montée en niveau (en cours d'utilisation)** : quand les critères de maîtrise du niveau actif sont atteints (voir Issue 21), afficher une bannière sur le dashboard : « Bravo, tu maîtrises X % du niveau A1 → passer au A2 ? ». Accepter → déblocage du niveau suivant + onboarding Minimal (choix de rester consultable sur l'ancien niveau). Refuser → la bannière se replie et peut être rouverte depuis les Paramètres.
3. **Historique de niveau** : garder une trace des niveaux couverts pour l'affichage « révision » (Issue 21) et pour ne jamais reproposer la même bannière après un refus définitif.

## Critères d'acceptation
- [ ] Depuis l'onboarding, le quiz de positionnement recommande un niveau cohérent (empiriquement : reconnaît ≥ 60 % des mots du niveau).
- [ ] La bannière de montée en niveau n'apparaît que lorsque les critères sont remplis et disparaît après acceptation ou refus.
- [ ] Refuser ne bloque pas le réaffichage manuel depuis Paramètres.
- [ ] Le changement de niveau recommandé conserve l'accès en consultation aux niveaux précédents.
