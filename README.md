# FF7 PSX EU Decompilation Workspace

Ce dépôt documente et automatise les premières étapes d’un projet de reverse engineering de **Final Fantasy VII PSX Europe / PAL**, à partir du disque 1.

L’objectif long terme est de **décompiler complètement FF7 PSX EU**, comprendre le moteur, les overlays, les structures de données et le runtime, pour obtenir un code source C "matching" (qui recompile bit-à-bit vers l'exécutable original).

L’objectif court terme actuel est d'isoler l'exécutable principal, documenter le code dans Ghidra, et utiliser `splat` pour extraire progressivement le code assembleur en code C.

## Version cible

```text
Final Fantasy VII Disc 1 - Europe / PAL
Boot executable: SCES_008.68
Volume ID: FINALFANTASY7
```

## Structure du Projet et Documentation

Pour ne pas alourdir ce fichier d'introduction, la documentation a été scindée en sous-répertoires dans `docs/` :

- **`docs/workflow/`** : Contient tous les guides méthodologiques. C'est ici qu'il faut aller pour comprendre le fonctionnement du projet.
  - [docs/workflow/splat_workflow.md](docs/workflow/splat_workflow.md) : Le workflow pas-à-pas de la décompilation.
  - [docs/workflow/tools_and_scripts.md](docs/workflow/tools_and_scripts.md) : Le rôle et le fonctionnement de chaque outil et script du dossier `tools/`.
  - [docs/workflow/naming_conventions.md](docs/workflow/naming_conventions.md) : Les règles de nommage à suivre pour le C et Ghidra.

- **`docs/technical/`** : Contient la documentation technique du code décompilé.
  - [docs/technical/SCES_008.68.md](docs/technical/SCES_008.68.md) : Informations techniques sur l'exécutable principal.
  - [docs/technical/overlays.md](docs/technical/overlays.md) : Liste et fonctionnement des exécutables secondaires (les modules chargés à chaud).
  - [docs/technical/handover.md](docs/technical/handover.md) : Historique des notes de transfert entre agents.

## Prérequis
- `python 3.14.4` (via `pyenv` recommandé)
- `splat64[mips]` (via `pip install -r requirements.txt`)
- `mkpsxiso` / `dumpsxiso`
- `mipsel-linux-gnu-*` (gcc, binutils)
- `DuckStation` (pour tester les ISOs recompilées)
- `Ghidra` (pour l'analyse avec l'extension `ghidra_psx_ldr`)

## Installation & Extraction

1. Configure le fichier `tools/iso/ff7_paths.config.zsh` avec le chemin de tes ROMs.
2. Lance l'extraction globale (une seule fois) :
   ```bash
   ./tools/iso/dump_psx_disc.zsh
   ```
3. Suis le guide de décompilation : [`docs/workflow/splat_workflow.md`](docs/workflow/splat_workflow.md)
