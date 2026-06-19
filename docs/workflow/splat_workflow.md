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
3. Exécute le split :
   ```bash
   python -m splat split config/splat/SCES_008.68.yaml
   ```
   Splat découpera le binaire et générera un script de lien (`ld/SCES_008.68.ld`).

## Phase C : Rebuild Assembleur-Only
**Objectif :** Valider que le code assembleur généré compile et produit le binaire exact.
1. **Étape cruciale** à faire *avant* d'écrire la moindre ligne de code C.
2. Compile le projet :
   ```bash
   make
   ```
3. Compare le binaire reconstruit avec la ROM d'origine :
   ```bash
   python tools/compare_binaries.py baserom/SCES_008.68 build/SCES_008.68.bin
   ```
4. Si le code assembleur diffère de la ROM originale (erreurs de macro-expansion, mauvais type de segment, etc.), corrige le YAML.

## Phase D : Découpage fin et C-ification (C Matching)
**Objectif :** Remplacer une fonction assembleur par son équivalent C.
1. Choisis une "leaf function" bien isolée.
2. Dans le YAML, change son type de `asm` vers `c`.
3. Re-split : un fichier `.c` vide (ou contenant le désassemblage en commentaire) sera créé dans `src/`.
4. Écris le code C.
5. Compile et compare (Phase C). Ajuste ton code C, les types, et les variables globales jusqu'à ce que les instructions CPU générées soient 100% identiques au binaire original.

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
