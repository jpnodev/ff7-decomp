# Référence des Scripts

Ce document documente l'ensemble des scripts et outils utilisés dans le projet pour automatiser le workflow d'extraction, d'analyse et de build.

### Quelle est la différence entre `scripts/` et `tools/` ?
- **`scripts/` (Les Scripts)** : Ce sont des automatisations liées spécifiquement à **notre projet et notre environnement** (ex: configuration locale, création de l'ISO, extraction du jeu). Ils orchestrent souvent plusieurs actions et sont fortement couplés à l'arborescence du projet.
- **`tools/` (Les Outils)** : Ce sont des petits programmes utilitaires génériques et réutilisables. Ils prennent une entrée, font un calcul ou une analyse, et renvoient un résultat (ex: convertir une adresse, lire un en-tête, comparer des binaires). Ils pourraient être copiés tels quels dans un autre projet de décompilation PSX.

Tous les scripts et outils sont conçus pour être lancés depuis la racine du projet (ex: `./scripts/build_iso.zsh` ou `python tools/check_header.py`).

## Scripts Shell (ZSH)

### `ff7_paths.config.zsh`
- **Rôle :** Fichier de configuration central.
- **Fonctionnement :** Il définit de manière dynamique toutes les variables d'environnement cruciales : chemins d'accès au jeu original (`ROM_DIR`, `BIN_PATH`, `CUE_PATH`), destination des extractions (`OUT_DIR`, `EXTRACTED_DIR`), et chemins vers les outils (`DUMPSXISO_BIN`).
- **Utilisation :** Il n'est pas conçu pour être exécuté directement, mais il est "sourcé" (`source`) par les autres scripts shell pour garantir la cohérence des chemins.

### `dump_psx_disc.zsh`
- **Rôle :** Extraction du disque original PSX.
- **Fonctionnement :**
  1. Lit `ff7_paths.config.zsh`.
  2. Extrait le contenu de l'ISO originale via l'outil `dumpsxiso`.
  3. Trie et organise les fichiers extraits dans `game_dump/extracted/`.
  4. Génère le fichier `game_dump/metadata/ff7_disc1.xml` (requis plus tard pour reconstruire l'ISO).
  5. Copie l'exécutable principal `SCES_008.68` vers les dossiers `baserom/` et `expected/`.
- **Utilisation :** `./scripts/dump_psx_disc.zsh` (à lancer une seule fois au début du projet).

### `build_iso.zsh`
- **Rôle :** Reconstruire une ISO jouable après modification.
- **Fonctionnement :**
  1. Lit `ff7_paths.config.zsh`.
  2. Copie le binaire nouvellement recompilé (`build/SCES_008.68.bin`) par dessus le fichier extrait dans `game_dump/extracted/SCES_008.68`.
  3. Utilise `mkpsxiso` avec le fichier `ff7_disc1.xml` généré précédemment pour packager une nouvelle ISO.
  4. Copie l'ISO et le `.cue` final vers le dossier de destination défini par `ROM_OUTPUT_DIR`.
- **Utilisation :** `./scripts/build_iso.zsh` (à lancer après un `make` réussi pour tester sur DuckStation).



## Scripts Java (Ghidra)

### `ExportSplatSymbols.java`
- **Rôle :** Faire le pont entre Ghidra et Splat.
- **Fonctionnement :** Script Ghidra "Headless" qui parcourt la base de données interne de Ghidra. Il identifie toutes les fonctions et étiquettes de données nommées par l'utilisateur, puis exporte ces symboles au format YAML / texte compréhensible par `splat`. Il génère aussi divers `.csv` pour une analyse externe.
- **Utilisation :** S'exécute directement dans le *Script Manager* de l'interface graphique de Ghidra, ou en ligne de commande via `analyzeHeadless`.

## Outils d'Analyse (`tools/`)

### `compare_binaries.py`
- **Rôle :** Vérifier que le binaire recompilé correspond parfaitement au binaire d'origine (matching decompilation).
- **Fonctionnement :** Compare deux fichiers bit à bit et reporte la première différence trouvée (avec son offset) ainsi qu'un calcul de hash (SHA1) pour garantir que le build est 100% fidèle au jeu d'origine.
- **Utilisation :** `python tools/compare_binaries.py baserom/SCES_008.68 build/SCES_008.68.bin`

### `vram_to_fileoff.py`
- **Rôle :** Convertir une adresse mémoire (VRAM) lue dans Ghidra en offset de fichier physique.
- **Fonctionnement :** Prends une adresse mémoire en argument (ex: `0x80012340`) et soustrait l'adresse de base du bloc texte pour indiquer à quel offset dans le fichier binaire se trouve cette adresse. Indispensable pour éditer la configuration YAML de `splat`.
- **Utilisation :** `python tools/vram_to_fileoff.py 0x80012340`
### `check_header.py`
- **Rôle :** Vérifier l'en-tête PS-X EXE d'un binaire.
- **Fonctionnement :** Lit les 2048 premiers octets d'un exécutable PSX et décode les informations clés (Magic, PC d'entrée, GP, adresses Text et Stack).
- **Utilisation :** `python tools/check_header.py <chemin_vers_executable>`

### `read_overlay_header.py`
- **Rôle :** Analyser les en-têtes des overlays de FF7.
- **Fonctionnement :** Les fichiers `.X` de FF7 (comme `BATTLE.X`) peuvent être compressés via GZIP. Ce script lit l'en-tête pour déterminer s'il s'agit d'un GZIP standard et affiche la taille décompressée.
- **Utilisation :** `python tools/read_overlay_header.py <chemin_vers_fichier.X>`
