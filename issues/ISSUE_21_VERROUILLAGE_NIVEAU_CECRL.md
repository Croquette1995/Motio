# Issue 21 : Verrouillage du contenu par niveau CECRL — voir son niveau, débloquer les suivants

Épique : #Issue 19 (UX v2)

## Problème
Tout le contenu A1 → B2 est visible dès le départ, ce qui noie un débutant :
- `lib/src/features/vocabulary/presentation/level_domains_screen.dart` affiche des onglets pour les 4 niveaux (`CefrLevel.values`) sans distinction du niveau actif de l'utilisateur.
- Le catalogue (`category_screen.dart` / `vocabulary_controller.dart`) permet de filtrer sur n'importe quel niveau.
- Les séances SRS filtrent déjà par niveau actif (`SessionSchedulerService`), mais la consultation n'est pas guidée.

## Solution proposée
1. **Contenu par défaut = niveau actif** : dashboard, domaines et catalogue s'ouvrent sur le niveau de l'utilisateur (`userLevelProvider`).
2. **Niveaux supérieurs verrouillés** : onglet visible mais cadenassé avec le critère de déblocage affiché (ex. « Maîtrise 70 % de l'A1 pour débloquer l'A2 »). Déblocage basé sur des critères mesurés (statut SRS `Maîtrisé`, taux de réussite, % du corpus cible `targetWordCount`).
3. **Niveaux inférieurs toujours consultables** : mode « révision » explicitement libellé (badges « Révision A1 »), sans décompte dans la progression du niveau actif.
4. **Déverrouillage manuel possible mais explicite** : option « Je suis certain de mon niveau → débloquer » avec dialogue de confirmation, pour ne pas piéger un utilisateur avancé venant d'une autre appli.

## Critères d'acceptation
- [ ] Un utilisateur A1 ne voit par défaut que du contenu A1 dans les domaines et le vocabulaire.
- [ ] Les onglets des niveaux supérieurs affichent un état verrouillé avec le critère de déblocage.
- [ ] Les niveaux déjà couverts restent consultables avec un marqueur visuel « révision ».
- [ ] Le déblocage d'un niveau supérieur est persisté (`SharedPreferences`) et ne redemande jamais de refaire le critère.
- [ ] Les séances SRS ne mélangent jamais de mots d'un niveau verrouillé.
