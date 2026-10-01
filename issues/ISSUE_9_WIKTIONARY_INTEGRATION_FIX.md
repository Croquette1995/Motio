# Issue #9 : Correction et fiabilisation de l'intégration Wiktionnaire (parsing des définitions, étymologie et synonymes)

## 📌 Contexte & Objectif
L'intégration de l'API Wiktionnaire pour enrichir les fiches de vocabulaire (définitions, étymologie, synonymes et traductions) présentait des dysfonctionnements critiques :
- **Pollution linguistique** : Le wikitexte complet de la page Wiktionnaire était scanné sans isolation de la section anglaise (`==English==`), ce qui provoquait l'extraction de synonymes en langues étrangères (par exemple des synonymes finnois comme `kalmanviiva` pour le mot `deadline`).
- **Échec des pages multi-étymologies** : De nombreux mots anglais possèdent des sections d'étymologie numérotées (`===Etymology 1===`, `===Etymology 2===`, par exemple pour `commute`). L'expression régulière `===Etymology===` les ignorait totalement.
- **Nettoyage destructeur du wikitexte** : Les modèles modernes de Wiktionnaire (`{{ety|...}}`, `{{compound|...}}`, `{{surf|...}}`, `{{back-formation|...}}`) étaient supprimés sans extraction de contenu, aboutissant à des champs d'étymologie vides ou réduits à de la ponctuation résiduelle comme `"; ."` ou `"From . Compare and ."`. De plus, les balises `<ref>` n'étaient pas correctement nettoyées.
- **Omission des synonymes** : Les synonymes déclarés sous forme de modèles inline (`{{syn|en|...}}` ou `{{nearsyn|en|...}}`) dans les définitions ou dans des sous-sections `=====Synonyms=====` étaient ignorés, tout comme les arguments multiples (`{{syn|en|mot1|mot2}}`).

Cette issue a pour objectif de fiabiliser totalement le service Wiktionnaire afin de garantir l'extraction fidèle et lisible des définitions, de l'étymologie et des synonymes anglais.

---

## 🛠 Spécifications Techniques

1. **Isolation stricte de la section `==English==`** :
   - Découper le wikitexte pour n'analyser que la portion comprise entre `==English==` et la section de langue suivante `\n==[A-Z]` (ou fin de document).

2. **Extraction et nettoyage de l'étymologie** :
   - Supporter `===Etymology===`, `===Etymology 1===`, etc.
   - Supprimer proprement les balises `<ref>...</ref>` et auto-fermantes `<ref ... />`.
   - Traiter les modèles lexicaux usuels :
     - `{{compound|en|A|B}}` -> `A + B`
     - `{{back-formation|en|A}}` -> `back-formation from A`
     - `{{surf|en|A|B}}` -> `A + B`
     - `{{ety|en|...}}` -> extraction des composants lexicaux réels (en filtrant les paramètres techniques `tree=`, `text=`, `id=`, etc.)
     - `{{der|en|lang|word}}`, `{{bor|...}}`, `{{inh|...}}`, `{{cog|...}}` -> conservation du mot source
   - Nettoyer les balises HTML, crochets de liens `[[...]]` et espacements.

3. **Extraction exhaustive des synonymes anglais** :
   - Extraire tous les termes issus des modèles `{{syn|en|...}}` et `{{nearsyn|en|...}}` dans la section anglaise, en découpant les arguments multiples et en éliminant les qualificatifs techniques (`#Verb`, `qq:`, `<...>`).
   - Supporter les sous-sections de synonymes de niveau 3 à 5 (`={3,5}Synonyms={3,5}`) et leurs listes à puces.
   - Dédupliquer les résultats.

4. **Résilience et fallback** :
   - En cas de nom au pluriel ou forme fléchie (ex: `accommodations`), détecter le modèle `{{plural of|en|...}}` pour récupérer les détails de la forme canonique si nécessaire.

---

## ✅ Critères d'Acceptation
- [x] L'étymologie de mots comme `troubleshoot`, `breakthrough`, `streamline`, `commute`, `resilience` et `deadline` est lisible, non vide et exempte de balises `<ref>` ou ponctuation orpheline.
- [x] Les synonymes sont systématiquement en anglais et ne proviennent jamais d'autres langues présentes sur la page.
- [x] Les sections `===Etymology 1===` sont correctement détectées et analysées.
- [x] Tous les tests unitaires et widget passent avec succès (`flutter test`).

---

## 🧪 Plan de Test
- `wiktionary_service_test.dart` : tests exhaustifs sur le nettoyage wikitexte, l'isolation de langue anglaise, l'extraction de `===Etymology 1===`, et les modèles inline `{{syn|en|...}}`.
- Vérification manuelle dans le catalogue de vocabulaire.

---
**Auteur : Corentin Chiodo**
