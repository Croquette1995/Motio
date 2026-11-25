# Releases et versions

## Flux de développement

- Les développements sont mergés dans la branche `dev` (analyze + tests à chaque push/PR).
- Les versions sortent de `dev` vers `main` (PR). Aucun APK n'est produit depuis `dev`.

## Build des APKs

Le workflow `Build Flutter Android` (`.github/workflows/build-android.yml`) :

- Sur `push` ou `pull_request` vers `main`, `master` ou `dev` : `flutter analyze` + `flutter test`.
- Sur `push` de `main` (ou `master`) et sur les tags `v*` : build des APKs
  (`--split-per-abi`), renommés d'après la version de `pubspec.yaml`
  (`version: 1.2.3+4` → `Motio-1.2.3-arm64-v8a.apk`, etc.).
  - Push sur `main` : les APKs sont publiés sur la release `latest`
    (titre `Motio 1.2.3 (latest)`).
  - Tag `v1.2.3` : publication sur une release dédiée `v1.2.3` (titre `Motio 1.2.3`).
- Rien n'est publié depuis `dev`, une PR, ou un `workflow_dispatch`.

## Sortir une version

1. merger `dev` → `main` ;
2. lancer `Bump Version` (`.github/workflows/bump-version.yml`) depuis
   l'onglet **Actions**, sur `main`, en choisissant `patch`, `minor` ou `major`.

Le workflow :

- modifie `version: X.Y.Z+N` dans `pubspec.yaml` ;
- committé sur `main` (`chore(release): bump version to X.Y.Z`) ;
- crée le tag `vX.Y.Z` ;
- déclenche `Build Flutter Android` sur ce tag, qui publie la release `vX.Y.Z`
  avec les APKs renommés.
