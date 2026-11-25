# AGENTS.md — Environnement sandbox (agents IA uniquement)

> Ce fichier s'adresse **exclusivement aux agents IA** (Claude, Codex, Copilot, Vibe, etc.) travaillant dans une sandbox vierge. Ce n'est pas de la documentation utilisateur.

## Clonage

Cloner le repo dans le répertoire conventionnel de la plateforme :

```bash
gh repo clone Croquette1995/Motio /workspace/github__Croquette1995__Motio -- --depth 1
```

## Installation du Flutter SDK (obligatoire)

`flutter` n'est **pas** préinstallé dans les sandboxes. `pubspec.yaml` exige Dart `>=3.11.0` : les vieilles versions de Flutter ne conviennent pas, il faut le SDK stable récent (**3.50.1-stable** ou plus récent de la même branche).

```bash
curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.50.1-stable.tar.xz
mkdir -p "$HOME/flutter_sdk"
```

⚠️ `xz` n'est **pas** disponible dans la sandbox : ne pas utiliser `tar -xf`. Extraire via `python3` (`lzma` + `tarfile`) :

```bash
python3 - <<'EOF'
import lzma, os, tarfile
with lzma.open('flutter_linux_3.50.1-stable.tar.xz') as xz:
    with tarfile.open(fileobj=xz) as tar:
        tar.extractall(path=os.path.expanduser('~/flutter_sdk'))
EOF
export PATH="$HOME/flutter_sdk/flutter/bin:$PATH"
```

Puis :

```bash
flutter --version        # vérifier Dart >= 3.11.0
flutter pub get
```

## Fix `libsqlite3.so` (requis avant tout `flutter test`)

La bibliothèque **non versionnée** `libsqlite3.so` est absente du système (seule `libsqlite3.so.0` existe). Sans fix, **tous** les tests utilisant Drift/SQLite échouent avec `Failed to load dynamic library 'libsqlite3.so'` : `widget_test.dart`, `migration_v3_test.dart`, SRS, référentiel, etc. échouent tous pour cette seule raison.

Contournement : symlink `libsqlite3.so` → `libsqlite3.so.0` dans un répertoire accessible, puis `LD_LIBRARY_PATH` :

```bash
mkdir -p "$HOME/.local/lib"
ln -sf /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 "$HOME/.local/lib/libsqlite3.so"
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
```

À faire **avant** de lancer les tests (rack à refaire si la sandbox recycle l'environnement).

## Règles de validation

Les checks de validation sont les mêmes que la CI (`.github/workflows/build-android.yml`) :

```bash
flutter analyze --no-fatal-infos
flutter test
```

Règles à respecter :

- **`pubspec.lock`** : ne **jamais committer** les modifications générées par le SDK local. Les restaurer avant le commit : `git checkout -- pubspec.lock`.
- **`flutter analyze`** : le SDK stable récent remonte des infos `deprecated_member_use` sur `package:flutter/material.dart` dans tout le repo. Elles sont **préexistantes et non fatales** (CI en `--no-fatal-infos`). Ne pas les corriger dans une PR qui n'a pas ce scope.
- **Tests widget** : la surface par défaut est 800×600. Pour tester des écrans plus hauts (ex. onboarding), redéfinir la surface dans le test :

  ```dart
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  ```

## Résumé quick-start (une session vierge fait un 100 % vert avec ça)

```bash
gh repo clone Croquette1995/Motio /workspace/github__Croquette1995__Motio -- --depth 1
cd /workspace/github__Croquette1995__Motio
curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.50.1-stable.tar.xz
mkdir -p "$HOME/flutter_sdk"
python3 -c "import os,lzma,tarfile; f=lzma.open('flutter_linux_3.50.1-stable.tar.xz'); tarfile.open(fileobj=f).extractall(path=os.path.expanduser('~/flutter_sdk'))"
export PATH="$HOME/flutter_sdk/flutter/bin:$PATH"
mkdir -p "$HOME/.local/lib" && ln -sf /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 "$HOME/.local/lib/libsqlite3.so"
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
flutter pub get
flutter analyze --no-fatal-infos && flutter test
```
