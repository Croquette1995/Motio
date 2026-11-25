# Issue 24 : Identité visuelle — intégration du logo (icônes launcher + asset in-app)

## Problème
L'application utilise encore les icônes launcher par défaut de Flutter (`ic_launcher.png` Android, `Icon-App-*.png` iOS, favicon/icons web). Aucun logo ne représente l'app. Un logo validé est disponible : cartes superposées bleu/jaune style Bauhaus avec « M » encre et trait corail, palette alignée sur le thème (`bauhaus_theme.dart`) — encre `#1E252D`, bleu `#82ACDC`, jaune `#F9CE73`, corail `#E97E6B`, fond `#F5F6F9`.

## Solution proposée
- Ajouter le logo source comme asset in-app (`assets/images/motio_logo.png`, déclaré dans `pubspec.yaml`).
- Générer et remplacer les icônes launcher Android : `ic_launcher` legacy (mdpi→xxxhdpi) + icônes adaptatives (API 26+, `mipmap-anydpi-v26`, foreground calé dans la zone sûre ~66 %, background couleur pleine `#F5F6F9`).
- Remplacer toutes les tailles d'`AppIcon.appiconset` iOS (de 20×20 à 1024×1024, fond opaque).
- Remplacer les icônes web : `favicon.png`, `Icon-192.png`, `Icon-512.png` et variantes maskables (contenu en zone sûre).
- Aucun changement applicatif (Dart) requis : les icônes remplacent les fichiers existants référencés par les manifestes actuels.

## Critères d'acceptation
- [ ] `pubspec.yaml` reste valide (assets correctement déclarés) et CI Android verte.
- [ ] Le logo apparaît comme icône d'application sur Android (legacy + adaptatif), iOS et web (favicon + PWA).
- [ ] L'asset in-app `assets/images/motio_logo.png` est déclaré et utilisable par les écrans.
- [ ] Aucune palette hors-thème introduite.
