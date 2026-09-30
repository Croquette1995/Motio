#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$ROOT_DIR/.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "Erreur : fichier .env introuvable dans $ROOT_DIR"
  exit 1
fi

# Charger les variables depuis .env sans les afficher
export $(grep -v '^#' "$ENV_FILE" | xargs)

if [ -z "$GITHUB_TOKEN" ] || [ -z "$GITHUB_REPO" ]; then
  echo "Erreur : GITHUB_TOKEN ou GITHUB_REPO manquant dans .env"
  exit 1
fi

echo "Publication des 7 issues vers le dépôt GitHub: $GITHUB_REPO..."

for file in "$SCRIPT_DIR"/ISSUE_*.md; do
  [ -e "$file" ] || continue

  # Extraire le premier titre comme titre de l'issue
  TITLE=$(head -n 1 "$file" | sed 's/^# *//')
  # Le corps correspond au contenu complet
  BODY=$(cat "$file")

  # Création du payload JSON sécurisé avec python
  PAYLOAD=$(python3 -c "import json, sys; print(json.dumps({'title': sys.argv[1], 'body': sys.argv[2]}))" "$TITLE" "$BODY")

  echo "Création de : $TITLE"
  RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/$GITHUB_REPO/issues" \
    -d "$PAYLOAD")

  HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)
  if [ "$HTTP_CODE" -eq 201 ]; then
    ISSUE_URL=$(echo "$RESPONSE" | head -n -1 | python3 -c "import json, sys; print(json.load(sys.stdin).get('html_url', ''))")
    echo " -> Succès : $ISSUE_URL"
  else
    echo " -> Code HTTP $HTTP_CODE reçu pour $TITLE"
  fi
done

echo "Toutes les issues ont été traitées."
