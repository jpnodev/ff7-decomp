# ============================================================
# ff7_paths.config.zsh
#
# Configuration locale pour l'extraction FF7 PSX Disc 1.
# Ce fichier est lu par scripts/dump_psx_disc.zsh.
# ============================================================

# -----------------------------
# Jeu source
# -----------------------------

ROM_DIR="/mnt/c/Users/clive/PSX Roms/Final Fantasy VII"

DISC_NAME="Final Fantasy VII Disc 1"
BIN_PATH="$ROM_DIR/$DISC_NAME.bin"
CUE_PATH="$ROM_DIR/$DISC_NAME.cue"
ROM_OUTPUT_DIR="/mnt/c/Users/clive/PSX Roms/ff7-disc1"

# -----------------------------
# Projet
# -----------------------------

PROJECT_ROOT="/mnt/c/Users/clive/ff7-decomp"

# Dossier de destination principal
OUT_DIR="$PROJECT_ROOT/game_dump"

# Nom du projet Ghidra, informatif seulement
GHIDRA_PROJECT_NAME="ff7-disc1"

# -----------------------------
# Outils Windows, informatif seulement
# -----------------------------

GHIDRA_WIN_DIR="C:/Tools/ghidra"
DUCKSTATION_WIN_DIR="C:/Tools/DuckStation"

# -----------------------------
# Outils WSL
# -----------------------------

# DUMPSXISO_BIN="dumpsxiso"
DUMPSXISO_BIN="$HOME/opt/psx-tools/mkpsxiso/extracted/usr/bin/dumpsxiso"

# -----------------------------
# Sous-dossiers générés
# -----------------------------

EXTRACTED_DIR="$OUT_DIR/extracted"
META_DIR="$OUT_DIR/metadata"
EXEC_DIR="$OUT_DIR/executables"
GHIDRA_IMPORT_DIR="$OUT_DIR/ghidra_import"
ORIGINAL_DIR="$OUT_DIR/original"

# -----------------------------
# Fichiers générés
# -----------------------------

XML_PATH="$META_DIR/ff7_disc1.xml"
SYSTEM_CNF_COPY="$META_DIR/SYSTEM.CNF"
SUMMARY_PATH="$META_DIR/summary.txt"
FILELIST_PATH="$META_DIR/filelist.tsv"
HASHES_PATH="$META_DIR/original_hashes.sha1"
EXEC_LIST_PATH="$META_DIR/executables_detected.tsv"
GHIDRA_NOTES_PATH="$META_DIR/ghidra_import_notes.txt"
