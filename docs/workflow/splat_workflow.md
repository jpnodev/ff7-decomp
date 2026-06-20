# Workflow de Décompilation avec Splat

Ce document synthétise la boucle de travail itérative pour décompiler le jeu bit à bit. L'objectif est de partir d'un exécutable binaire (ROM) et de retrouver un code source C équivalent qui, une fois compilé, génère un binaire identique à 100%.

## Phase A : Analyse Ghidra
**Objectif :** Comprendre, nommer, typer et documenter.
1. Ouvre Ghidra, repère une fonction ou une donnée non documentée dans `SCES_008.68`.
2. Renomme la fonction et identifie son rôle.
3. Exécute le script `ExportSplatSymbols.java` via le *Script Manager*.
   - Cela génère un fichier `SCES_008.68.symbols.from_ghidra.txt` dans `ghidra_exports/splat/` que Splat utilisera pour nommer les fonctions lors du découpage.

## Phase B : Découpage (Splat Split)
**Objectif :** Transformer le binaire en fichiers assembleurs (asm) organisés.
1. Le fichier YAML (`config/splat/SCES_008.68.yaml`) dicte à quels offsets on découpe le fichier. (Sers-toi de `./tools/vram_to_fileoff.py` pour convertir une adresse mémoire en offset fichier).
2. Pour isoler une fonction ou un groupe de données, déclare-les sous `subsegments` dans le YAML.
3. Exécute le split (assure-toi d'avoir sourcé `aliases.zsh`) :
   ```bash
   ff7-split
   ```
   Splat découpera le binaire et générera un script de lien (`ld/SCES_008.68.ld`).

## Phase C : Rebuild Assembleur-Only
**Objectif :** Valider que le code assembleur généré compile et produit le binaire exact.
1. **Étape cruciale** à faire *avant* d'écrire la moindre ligne de code C.
2. Compile le projet :
   ```bash
   ff7-build
   ```
3. Compare le binaire reconstruit avec la ROM d'origine :
   ```bash
   ff7-check
   ```
4. Si le code assembleur diffère de la ROM originale (erreurs de macro-expansion, mauvais type de segment, etc.), corrige le YAML.

## Phase D : Découpage fin et C-ification (C Matching)
**Objectif :** Remplacer une fonction assembleur par son équivalent C.
1. Choisis une "leaf function" bien isolée.
2. Dans le YAML, change son type de `asm` vers `c`.
3. Re-split : un fichier `.c` vide (ou contenant le désassemblage en commentaire) sera créé dans `src/`.
4. Écris le code C.
5. Lance la vérification ciblée et itérative avec `asm-differ` :
   ```bash
   ff7-diff <nom_de_la_fonction>
   ```
   *(Cet alias recompile automatiquement et se met à jour à chaque sauvegarde de fichier).*
   Ajuste ton code C, les types, et les variables globales jusqu'à ce que les instructions CPU affichées soient 100% identiques à celles de gauche (0 différences).
6. Si tu bloques sur les derniers registres ou instructions, utilise le **decomp-permuter** :
   - Assure-toi que ton code dans `src/` est propre, sans macros de permuteur.
   - Lance l'import : `ff7-perm-import <nom_de_la_fonction>`. (Cela va configurer le dossier `nonmatchings/<nom_de_la_fonction>`).
   - Édite **uniquement** `nonmatchings/<nom_de_la_fonction>/base.c` pour ajouter tes macros (`PERM_RANDOMIZE`, `PERM_LINESWAP`) et renommer la fonction avec un `func_` au lieu de `FUN_` pour correspondre à l'assembleur extrait.
   - Lance le permuteur : `ff7-perm <nom_de_la_fonction> --stop-on-zero`.
   - Copie la solution trouvée (dans `output/.../source.c`) vers ton vrai fichier dans `src/`, nettoie les macros et remets son nom d'origine.
7. Une fois la fonction parfaitement "matchée", lance une vérification globale pour confirmer que le binaire final complet n'est pas altéré :
   ```bash
   ff7-check
   ```

## Phase E : Test de non-régression en émulateur
**Objectif :** vérifier qu'une ISO reconstruite à partir du binaire matching démarre et se comporte comme l'original.

Cette phase ne remplace pas le matching byte-to-byte. Elle sert seulement à détecter des problèmes de packaging ISO, de header PS-X EXE, de reconstruction de disque ou de chargement runtime.

1. Reconstruis l'ISO complète :
   ```bash
   ./tools/iso/build_iso.zsh
   ```
2. Charge le fichier `.cue` généré dans `DuckStation` et teste que le jeu tourne.


## Phase F : Overlays
**Objectif :** Reproduire le processus pour les autres exécutables.
Une fois le binaire principal maîtrisé, crée de nouveaux profils YAML (ex: `config/splat/BATTLE.X.yaml`) pour décompiler les overlays.
