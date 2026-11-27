#!/usr/bin/env python3
"""Génère les wordlists de fréquence Zipf embarquées (Issue 31 / GitHub #60).

One-off, hors app : requiert Python 3 + le paquet `wordfreq` (pip install wordfreq==3.0.2).

    python3 tool/generate_wordlists.py

Exporte par langue `assets/wordlists/wordlist_<lang>.json` : un objet JSON
`word -> zipf` (2 décimales), formes de surface TELLES QUELLES (pas de
lemmatisation à la génération : le lemme est résolu au lookup, Issue 32),
top N ~10 000 entrées/langue, Zipf >= 2.0, triées par fréquence décroissante.

Attribution des données (obligatoire, CC BY-SA 4.0) :
  Word frequency data par Robyn Speer (2022), rspeer/wordfreq v3.0.2,
  Zenodo DOI 10.5281/zenodo.7199437 — redistribution CC BY-SA 4.0.
"""

import json
import os

from wordfreq import top_n_list, zipf_frequency

LANGS = ["en", "fr", "de", "es", "it", "pt", "nl", "sv", "pl", "ro"]
TOP_N = 10_000
MIN_ZIPF = 2.0
OUT_DIR = os.path.join(os.path.dirname(__file__), "..", "assets", "wordlists")


def main() -> None:
    os.makedirs(OUT_DIR, exist_ok=True)
    for lang in LANGS:
        entries = {}
        for word in top_n_list(lang, TOP_N):
            if len(word) < 2 or " " in word or any(c.isdigit() for c in word):
                continue
            zipf = zipf_frequency(word, lang)
            if zipf < MIN_ZIPF:
                continue
            entries[word] = round(zipf, 2)
        ordered = dict(sorted(entries.items(), key=lambda kv: kv[1], reverse=True))
        out_path = os.path.join(OUT_DIR, f"wordlist_{lang}.json")
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump(ordered, f, ensure_ascii=False, separators=(",", ":"))
        size_kb = os.path.getsize(out_path) / 1024
        print(f"{lang}: {len(ordered)} entrées, {size_kb:.0f} Ko")


if __name__ == "__main__":
    main()
