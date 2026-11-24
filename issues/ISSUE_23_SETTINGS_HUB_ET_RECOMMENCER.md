# Issue 23 : Refonte de l'écran Paramètres en hub complet + bouton « Recommencer »

Épique : #Issue 19 (UX v2) — dépend de Issue 20 (onboarding) et Issue 21 (verrouillage)

## Problème
L'écran actuel (`lib/src/features/settings/presentation/settings_screen.dart`) est centré TTS :
- niveau CECRL changeable d'un clic, sans confirmation ni garde-fou (cohérence avec le verrouillage, Issue 21) ;
- la « langue apprise » n'est qu'un réglage de voix TTS ;
- **aucun bouton ni mécanisme pour recommencer** (reset de progression, re-choix de la langue/niveau via l'onboarding) ;
- pas de section données/performance/à propos.

## Solution proposée — structure en sections
1. **Apprentissage**
   - Langue apprise (source de vérité unique, consommée par le TTS et le contenu) + accès direct à « Rechoisir via l'onboarding ».
   - Niveau CECRL actif avec état de déblocage des niveaux suivants (réutilise la logique de Issues 21/22) ; changement manuel derrière confirmation.
2. **Voix & lecture (TTS)** — regrouper tout l'existant : lecture automatique, voix, vitesse, tonalité, volume, exemple.
3. **Données**
   - **Bouton « Recommencer »** : dialogue de confirmation à double étape avec cases à cocher explicites :
     - reset de la progression SRS (`word_progress` etc.) ;
     - suppression des mots ajoutés depuis Tatoeba (optionnel) ;
     - relancer l'onboarding (choisir une nouvelle langue/niveau).
     - L'opération doit être annulable jusqu'à l'étape finale et ne jamais toucher aux données système (référentiel embarqué).
4. **À propos** : version de l'app, liens (dépôt, licences des sources Wiktionnaire/Tatoeba/UniMorph).

## Critères d'acceptation
- [ ] Les Paramètres couvrent langue, niveau, TTS, données, à propos, dans cet ordre.
- [ ] Le bouton « Recommencer » existe, est protégé par une confirmation explicite, et relance l'onboarding complet.
- [ ] Après « Recommencer », la progression SRS repart de zéro et le contenu corresponde à la nouvelle langue/niveau.
- [ ] Le changement manuel de niveau dans Paramètres confirme l'action (cohérence avec le verrouillage).
- [ ] Aucune régression sur les réglages TTS existants.
