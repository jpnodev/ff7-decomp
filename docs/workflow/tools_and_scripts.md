# Référence des Outils et Scripts

Ce document documente l'ensemble des scripts et outils utilisés dans le projet pour automatiser le workflow d'extraction, d'analyse et de build.

Toutes ces commandes sont encapsulées dans des raccourcis ZSH pratiques. (Voir `aliases.zsh` à la racine).

## Extraction & ISO (`tools/iso/`)

### `ff7_paths.config.zsh`
- **Rôle :** Fichier de configuration central.
- **Fonctionnement :** Définit dynamiquement toutes les variables d'environnement cruciales : chemins d'accès au jeu original, destination des extractions, et chemins vers les outils.
- **Utilisation :** Sourcé par les autres scripts shell.

### `dump_psx_disc.zsh`
- **Rôle :** Extraction du disque original PSX.
- **Fonctionnement :**
  1. Lit `ff7_paths.config.zsh`.
  2. Extrait l'ISO avec `dumpsxiso`.
  3. Trie et organise les fichiers extraits.
  4. Copie l'exécutable principal.
- **Utilisation :** Alias `ff7-unpack` (à lancer une seule fois au début).

### `build_iso.zsh`
- **Rôle :** Reconstruire une ISO jouable après modification.
- **Fonctionnement :**
  1. Lit `ff7_paths.config.zsh`.
  2. Copie le binaire recompilé.
  3. Utilise `mkpsxiso` pour packager une nouvelle ISO et la copie vers DuckStation.
- **Utilisation :** Alias `ff7-pack` (à lancer pour tester en émulateur).

## Scripts Ghidra (`tools/ghidra/`)

### `ExportSplatSymbols.java`
- **Rôle :** Faire le pont entre Ghidra et Splat.
- **Fonctionnement :** Exporte toutes les fonctions et étiquettes depuis Ghidra vers un format texte lisible par `splat`.
- **Utilisation :** Exécutable depuis le Script Manager de Ghidra.

### `clean_ghidra_exports.py`
- **Rôle :** Nettoyer l'export des symboles de Ghidra.
- **Fonctionnement :** Ghidra exporte souvent du bruit (ex: labels générés automatiquement comme `switchD`, `caseD_1`, `default`). Ce script purge ces labels pour éviter les collisions de symboles dans Splat.
- **Utilisation :** Alias `ff7-clean-syms`.

## Outils d'Analyse et Binaire (`tools/`)

### `compare_binaries.py`
- **Rôle :** Vérifier que le binaire recompilé match le binaire d'origine.
- **Utilisation :** Alias `ff7-check`.

### `vram_to_fileoff.py`
- **Rôle :** Convertir une adresse mémoire VRAM lue dans Ghidra en offset de fichier physique.
- **Utilisation :** Alias `ff7-tool-vram-to-fileoff 0x80012340`.

### `check_header.py`
- **Rôle :** Vérifier l'en-tête PS-X EXE d'un binaire.
- **Utilisation :** Alias `ff7-tool-check-header <executable>`.

### `read_overlay_header.py`
- **Rôle :** Analyser les en-têtes des overlays de FF7 (fichiers `.X` souvent GZIP).
- **Utilisation :** Alias `ff7-tool-read-overlay <chemin.X>`.

### `compile_psyq_c.py`
- **Rôle :** Wrapper python pour la compilation d'un fichier C vers un objet MIPS avec GCC 2.7.2 et le pipeline `maspsx`.
- **Utilisation :** Alias `ff7-tool-compile-c`.

### `asm-differ` (`tools/asm-differ/diff.py`)
- **Rôle :** Afficher et comparer le code assembleur d'une fonction du jeu original et de notre compilation C.
- **Utilisation :** Alias `ff7-diff <nom_fonction>`.

## Optimisation et Permutation (`tools/decomp-permuter/`)

### `import_perm.sh`
- **Rôle :** Importer une fonction C non-matching et son code assembleur cible dans l'environnement du permuteur, sans salir le dossier `src/`.
- **Fonctionnement :** Crée un dossier dans `nonmatchings/<fonction>/` avec le contexte, configure le nom de la fonction (remplace `FUN_` par `func_` dans une copie temporaire) et prépare le `settings.toml`.
- **Utilisation :** Alias `ff7-perm-import <nom_fonction>`. Ensuite, éditer `nonmatchings/<nom_fonction>/base.c` manuellement pour ajouter les macros de permuteur.

### `run_perm.sh`
- **Rôle :** Lancer le permuteur sur une fonction importée pour générer des variantes aléatoires et trouver la correspondance (100% match).
- **Utilisation :** Alias `ff7-perm <nom_fonction> [--stop-on-zero]` (ajoute `--stop-on-zero` pour l'arrêter dès que la bonne configuration est trouvée).

### `apply_perm.sh`
- **Rôle :** Appliquer le meilleur résultat trouvé par le permuteur vers le dossier `src/` d'origine.
- **Fonctionnement :** Cherche le score le plus bas dans `nonmatchings/<fonction>/output-*/`, copie le code source C sans les macros dans `src/`, renomme la fonction avec le nom cible, et propose de supprimer le dossier de travail du permuteur.
- **Utilisation :** Alias `ff7-perm-apply <nom_fonction> [nouveau_nom]` (ex: `ff7-perm-apply FUN_80043834 ResetGraph`).
