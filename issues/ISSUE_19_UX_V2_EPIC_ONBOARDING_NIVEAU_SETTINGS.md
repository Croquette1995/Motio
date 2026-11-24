# Issue 19 : UX v2 — Onboarding, progression par niveau CECRL & Paramètres (épique)

## Description
Rendre l'application cohérente du premier lancement jusqu'au niveau B2. Aujourd'hui, tout est exposé d'emblée : toutes les langues, tous les niveaux CECRL (A1 → B2), sans guidage ni progression. Un débutant A1 se retrouve devant du contenu B2, ce qui casse la courbe d'apprentissage.

## Vision cible
1. **Premier lancement** : un onboarding propose de choisir la **langue apprise** et le **niveau de départ** avant d'arriver sur le dashboard.
2. **Pendant l'apprentissage** : l'utilisateur ne voit que le contenu de son niveau actif. Les niveaux supérieurs se **débloquent sur critères** (maîtrise mesurée par le SRS), jamais d'un coup. Les niveaux déjà couverts restent **consultables** (mode révision).
3. **Paramètres** : un vrai hub de réglages utile, avec notamment un bouton **« Recommencer »** pour réinitialiser la progression et re-choisir une langue / un niveau.

## Sous-issues
- [ ] Issue 20 — Onboarding premier lancement (langue + niveau de départ)
- [ ] Issue 21 — Verrouillage du contenu par niveau CECRL + déblocage progressif
- [ ] Issue 22 — Test de positionnement & suggestion de montée en niveau
- [ ] Issue 23 — Refonte de l'écran Paramètres en hub complet + bouton « Recommencer »

## État du code concerné
- `lib/src/routing/app_router.dart` : `initialLocation: '/init'` n'initialise que le modèle ML Kit, puis redirige vers `/` sans aucun onboarding.
- `lib/src/features/settings/application/user_level_controller.dart` : `isLevelOnboardedProvider` existe mais **n'est jamais utilisé**.
- `lib/src/features/vocabulary/presentation/level_domains_screen.dart` : onglets montrant les 4 niveaux A1→B2 sans distinction du niveau actif.
- `lib/src/features/settings/domain/voice_settings.dart` : `LearningLanguage.all` — la sélection de langue n'est qu'un paramètre TTS, pas un choix d'apprentissage.
