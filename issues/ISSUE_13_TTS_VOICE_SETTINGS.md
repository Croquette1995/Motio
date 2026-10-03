# Issue #13 : Lecture vocale (TTS) des phrases en séance et nouvelle route Paramètres (voix, vitesse…)

## 📌 Contexte

Pour apprendre la prononciation correcte, l'apprenant doit pouvoir entendre la phrase contextuelle d'une carte. Il doit pouvoir activer/désactiver cette lecture, et régler la voix dans un écran de paramètres dédié.

## 🎯 Objectifs

1. **Lecture vocale en séance**
   - Bouton (haut-parleur) directement sur l'écran de carte pour activer/désactiver la lecture.
   - Si activé : la phrase n'est lue qu'une fois le mot validé (réussi **ou** échoué), avant de passer à la carte suivante.
   - Une lecture ne doit jamais bloquer la séance (erreurs TTS absorbées, délai de sécurité).

2. **Nouvelle route `/settings`**
   - Accessible depuis le tableau de bord.
   - Section « Voix » :
     - activation de la lecture automatique ;
     - langue apprise (anglais pour l'instant, extensible) ;
     - choix de la voix parmi celles du système pour la langue (indication voix féminine/masculine quand déductible), avec bouton d'écoute pour comparer ;
     - vitesse, tonalité et volume ;
     - bouton « Écouter un exemple ».
   - Réglages persistés (`shared_preferences`).

## 🛠 Implémentation prévue

- Dépendances : `flutter_tts`, `shared_preferences`.
- `features/settings/` : `domain/voice_settings.dart`, `application/tts_service.dart`, `application/voice_settings_controller.dart` (Riverpod), `presentation/settings_screen.dart`.
- `app_router.dart` : route `/settings`.
- `session_screen.dart` : bouton de bascule + lecture de `contextSentence` avant `submitAnswer` (modes canvas, cloze, matching).
- `dashboard_screen.dart` : icône d'accès aux paramètres.

## ✅ Critères d'acceptation

- [ ] La phrase est lue après validation du mot (réussite ou échec), jamais avant.
- [ ] Le bouton sur la carte désactive/réactive la lecture, et l'état est synchronisé avec les paramètres.
- [ ] La route `/settings` permet de choisir voix, vitesse, tonalité, volume, avec aperçu sonore.
- [ ] Les réglages survivent au redémarrage de l'app.
- [ ] Aucune lecture n'est lancée si l'option est désactivée ; la séance continue même si le TTS échoue.

## ⚠️ Limites connues

- Le genre de la voix dépend du moteur TTS de l'appareil ; il n'est pas toujours exposé et est déduit du nom de la voix.
