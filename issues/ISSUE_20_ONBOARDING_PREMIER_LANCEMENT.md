# Issue 20 : Onboarding au premier lancement — choix de la langue apprise et du niveau de départ

Épique : #Issue 19 (UX v2)

## Problème
Au premier lancement, l'utilisateur arrive directement sur le dashboard :
- `lib/src/routing/app_router.dart` démarre sur `/init` qui n'attend que l'initialisation du modèle ML Kit Digital Ink avant de rediriger vers `/`.
- Aucune question n'est posée : la langue apprise est codée en dur (`LearningLanguage.english`, `lib/src/features/settings/domain/voice_settings.dart`) et le niveau par défaut est A1 sans confirmation.
- `isLevelOnboardedProvider` (`lib/src/features/settings/application/user_level_controller.dart`) a été prévu pour ça mais **n'est jamais consulté**.

Par ailleurs, la langue « apprise » n'est qu'un réglage TTS caché dans Paramètres, pas un choix pédagogique.

## Solution proposée
Créer un écran d'onboarding (`/onboarding`) affiché **uniquement au premier lancement** :

1. **Bienvenue** : présentation courte de Motio (2–3 écrans max ou une seule carte d'intro).
2. **Choix de la langue apprise** : carte sélectionnable par langue (pour l'instant Anglais ; la structure `LearningLanguage` est déjà extensible). Bouton « Plus tard » ou « Autre langue bientôt disponible » pour les langues non supportées.
3. **Choix du niveau de départ** : radios A1 / A2 / B1 / B2 avec description (réutiliser `CefrLevel` et ses descriptions de `lib/src/features/settings/domain/cefr_level.dart`), pré-sélection A1. Option : mini-quiz de positionnement (renvoyé vers Issue 22).
4. **Confirmation** : résumé (« Tu apprends l'anglais · niveau A1 ») puis entrée dans l'app.

## Critères d'acceptation
- [ ] Route `/onboarding` enregistrée dans `app_router.dart`, avec redirection automatique au lancement si aucun onboarding n'a été complété (consommer `isLevelOnboardedProvider`).
- [ ] Une fois complété, l'onboarding ne réapparaît plus aux lancements suivants.
- [ ] Les choix (langue, niveau) sont persistés via `SharedPreferences` (même clés que `UserLevelNotifier` / `VoiceSettings`).
- [ ] Le style suit le thème Bauhaus existant (`lib/src/core/theme/bauhaus_theme.dart`).
- [ ] Skippable : « Je ne sais pas » → niveau A1 par défaut.
