#!/usr/bin/env zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
PROJECT_ROOT="${SCRIPT_DIR}/.."
GAME_DUMP_DIR="${PROJECT_ROOT}/game_dump"
BUILD_DIR="${PROJECT_ROOT}/build"

# Charger la config
source "${SCRIPT_DIR}/ff7_paths.config.zsh"
XML_PATH="${GAME_DUMP_DIR}/metadata/ff7_disc1.xml"

echo "=== Copie du binaire compilé dans le dossier d'extraction ==="
cp "${BUILD_DIR}/SCES_008.68.bin" "${GAME_DUMP_DIR}/extracted/SCES_008.68"

echo "=== Reconstruction de l'ISO avec mkpsxiso ==="
if command -v mkpsxiso >/dev/null 2>&1; then
    mkpsxiso -y "${XML_PATH}" -o "${BUILD_DIR}/ff7_custom.bin" -c "${BUILD_DIR}/ff7_custom.cue"
    
    echo "=== Copie vers ROM_OUTPUT_DIR ==="
    mkdir -p "${ROM_OUTPUT_DIR}"
    cp "${BUILD_DIR}/ff7_custom.bin" "${ROM_OUTPUT_DIR}/"
    cp "${BUILD_DIR}/ff7_custom.cue" "${ROM_OUTPUT_DIR}/"
    
    echo "=== Terminé ! ==="
    echo "Tu peux maintenant charger '${ROM_OUTPUT_DIR}/ff7_custom.cue' dans DuckStation."
else
    echo "Erreur: mkpsxiso n'est pas installé ou introuvable dans le PATH."
    exit 1
fi
