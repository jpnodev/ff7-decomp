#!/usr/bin/env zsh
set -euo pipefail

# ============================================================
# dump_psx_disc.zsh
#
# Extrait un disque PSX BIN/CUE selon un fichier de config zsh.
#
# Usage :
#   ./scripts/dump_psx_disc.zsh
#   ./scripts/dump_psx_disc.zsh ./scripts/ff7_paths.config.zsh
#
# Le fichier de config doit définir au minimum :
#   BIN_PATH
#   CUE_PATH
#   OUT_DIR
#   DUMPSXISO_BIN
# ============================================================

SCRIPT_DIR="${0:A:h}"
DEFAULT_CONFIG="$SCRIPT_DIR/ff7_paths.config.zsh"
CONFIG_PATH="${1:-$DEFAULT_CONFIG}"

# -----------------------------
# Helpers
# -----------------------------

die() {
    print -u2 "ERROR: $*"
    exit 1
}

need_var() {
    local name="$1"
    local value="${(P)name:-}"

    [[ -n "$value" ]] || die "Variable de config manquante: $name"
}

need_file() {
    [[ -f "$1" ]] || die "Fichier introuvable: $1"
}

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || die "Commande introuvable: $1"
}

to_win_path() {
    if command -v wslpath >/dev/null 2>&1; then
        wslpath -w "$1"
    else
        print "$1"
    fi
}

is_psx_exe() {
    local f="$1"

    [[ -f "$f" ]] || return 1
    [[ "$(LC_ALL=C head -c 8 "$f" 2>/dev/null || true)" == "PS-X EXE" ]]
}

copy_relative() {
    local src="$1"
    local base_dir="$2"
    local dst_dir="$3"
    local rel="${src#$base_dir/}"
    local dst="$dst_dir/$rel"

    [[ -f "$src" ]] || return 0

    mkdir -p "$(dirname "$dst")"
    cp -f "$src" "$dst"
}

find_extracted_path_case_insensitive() {
    local rel="$1"

    python3 - "$EXTRACTED_DIR" "$rel" <<'PY'
import os
import sys

root = sys.argv[1]
wanted = sys.argv[2].replace("\\", "/").strip("/").lower()

for dirpath, _, filenames in os.walk(root):
    for name in filenames:
        full = os.path.join(dirpath, name)
        rel = os.path.relpath(full, root).replace("\\", "/").lower()
        if rel == wanted:
            print(full)
            raise SystemExit(0)

raise SystemExit(1)
PY
}

parse_boot_target_from_system_cnf() {
    local system_cnf="$1"

    python3 - "$system_cnf" <<'PY'
import re
import sys

path = sys.argv[1]
data = open(path, "rb").read().decode("latin-1", errors="replace")
data = data.replace("\r", "")

for line in data.split("\n"):
    line = line.strip()

    if not line or line.startswith("#"):
        continue

    m = re.match(r"(?i)^BOOT\s*=\s*cdrom:\\?(.+?)\s*(?:;[0-9]+)?\s*$", line)

    if m:
        target = m.group(1)
        target = target.replace("\\", "/").strip("/")
        target = re.sub(r";[0-9]+$", "", target)
        print(target)
        raise SystemExit(0)

raise SystemExit(1)
PY
}

# -----------------------------
# Lecture config
# -----------------------------

[[ -f "$CONFIG_PATH" ]] || die "Fichier de config introuvable: $CONFIG_PATH"

# Important : ce fichier est exécuté comme du zsh.
# Ne source jamais un fichier de config non fiable.
source "$CONFIG_PATH"

# -----------------------------
# Valeurs dérivées par défaut
# -----------------------------

: "${PROJECT_ROOT:=${OUT_DIR:h}}"
: "${GHIDRA_PROJECT_NAME:=psx-disc}"
: "${GHIDRA_WIN_DIR:=C:/Tools/ghidra}"
: "${DUCKSTATION_WIN_DIR:=C:/Tools/DuckStation}"

: "${EXTRACTED_DIR:=$OUT_DIR/extracted}"
: "${META_DIR:=$OUT_DIR/metadata}"
: "${EXEC_DIR:=$OUT_DIR/executables}"
: "${GHIDRA_IMPORT_DIR:=$OUT_DIR/ghidra_import}"
: "${ORIGINAL_DIR:=$OUT_DIR/original}"

: "${XML_PATH:=$META_DIR/disc.xml}"
: "${SYSTEM_CNF_COPY:=$META_DIR/SYSTEM.CNF}"
: "${SUMMARY_PATH:=$META_DIR/summary.txt}"
: "${FILELIST_PATH:=$META_DIR/filelist.tsv}"
: "${HASHES_PATH:=$META_DIR/original_hashes.sha1}"
: "${EXEC_LIST_PATH:=$META_DIR/executables_detected.tsv}"
: "${GHIDRA_NOTES_PATH:=$META_DIR/ghidra_import_notes.txt}"

# -----------------------------
# Vérifications config
# -----------------------------

need_var BIN_PATH
need_var CUE_PATH
need_var OUT_DIR
need_var DUMPSXISO_BIN

need_file "$BIN_PATH"
need_file "$CUE_PATH"
need_cmd python3
need_cmd sha1sum

if ! command -v "$DUMPSXISO_BIN" >/dev/null 2>&1; then
    die "dumpsxiso introuvable: $DUMPSXISO_BIN"
fi

# -----------------------------
# Vérification CUE
# -----------------------------

cue_file_count="$(grep -iE '^[[:space:]]*FILE[[:space:]]+' "$CUE_PATH" | wc -l | tr -d ' ')"

if [[ "$cue_file_count" -gt 1 ]]; then
    print -u2 "WARNING: le .cue référence $cue_file_count fichiers."
    print -u2 "Ce script extrait le .bin principal indiqué par BIN_PATH."
fi

# -----------------------------
# Préparation destination
# -----------------------------

if [[ -e "$OUT_DIR" ]]; then
    BACKUP_DIR="${OUT_DIR}.bak-$(date +%Y%m%d-%H%M%S)"
    print "Ancien dossier de dump trouvé."
    print "Déplacement vers:"
    print "  $BACKUP_DIR"
    mv "$OUT_DIR" "$BACKUP_DIR"
fi

mkdir -p \
    "$EXTRACTED_DIR" \
    "$META_DIR" \
    "$EXEC_DIR" \
    "$GHIDRA_IMPORT_DIR" \
    "$ORIGINAL_DIR"

# -----------------------------
# Copie originaux + hashes
# -----------------------------

cp -f "$BIN_PATH" "$ORIGINAL_DIR/"
cp -f "$CUE_PATH" "$ORIGINAL_DIR/"

sha1sum "$BIN_PATH" "$CUE_PATH" > "$HASHES_PATH"

# -----------------------------
# Extraction filesystem PSX
# -----------------------------

print "Extraction PSX ISO avec dumpsxiso..."
print "  Config : $CONFIG_PATH"
print "  BIN    : $BIN_PATH"
print "  CUE    : $CUE_PATH"
print "  OUT    : $EXTRACTED_DIR"
print "  XML    : $XML_PATH"

"$DUMPSXISO_BIN" -x "$EXTRACTED_DIR" -s "$XML_PATH" "$BIN_PATH"

# -----------------------------
# Liste des fichiers extraits
# -----------------------------

find "$EXTRACTED_DIR" -type f -printf "%P\t%s\n" | sort > "$FILELIST_PATH"

# -----------------------------
# SYSTEM.CNF + boot executable
# -----------------------------

SYSTEM_CNF_FOUND="$(find "$EXTRACTED_DIR" -type f -iname 'SYSTEM.CNF' -print -quit || true)"
[[ -n "$SYSTEM_CNF_FOUND" ]] || die "SYSTEM.CNF introuvable dans le dump extrait."

cp -f "$SYSTEM_CNF_FOUND" "$SYSTEM_CNF_COPY"

BOOT_TARGET="$(parse_boot_target_from_system_cnf "$SYSTEM_CNF_FOUND" || true)"
BOOT_EXE_PATH=""

if [[ -n "$BOOT_TARGET" ]]; then
    BOOT_EXE_PATH="$(find_extracted_path_case_insensitive "$BOOT_TARGET" || true)"
fi

if [[ -n "$BOOT_EXE_PATH" && -f "$BOOT_EXE_PATH" ]]; then
    print "Exécutable de boot détecté:"
    print "  Target : $BOOT_TARGET"
    print "  Path   : $BOOT_EXE_PATH"

    mkdir -p "$GHIDRA_IMPORT_DIR/boot"
    cp -f "$BOOT_EXE_PATH" "$GHIDRA_IMPORT_DIR/boot/"
    copy_relative "$BOOT_EXE_PATH" "$EXTRACTED_DIR" "$EXEC_DIR"

    # Copie automatique vers baserom et expected pour splat
    mkdir -p "$PROJECT_ROOT/baserom" "$PROJECT_ROOT/expected"
    cp -f "$BOOT_EXE_PATH" "$PROJECT_ROOT/baserom/"
    cp -f "$BOOT_EXE_PATH" "$PROJECT_ROOT/expected/"
else
    print -u2 "WARNING: impossible de résoudre l'exécutable de boot depuis SYSTEM.CNF."
fi

# -----------------------------
# Détection PS-X EXE
# -----------------------------

: > "$EXEC_LIST_PATH"

print "Détection des fichiers PS-X EXE..."

while IFS= read -r -d '' f; do
    if is_psx_exe "$f"; then
        rel="${f#$EXTRACTED_DIR/}"
        size="$(stat -c '%s' "$f")"

        print "$rel\t$size\tPS-X EXE" >> "$EXEC_LIST_PATH"

        copy_relative "$f" "$EXTRACTED_DIR" "$EXEC_DIR"
        copy_relative "$f" "$EXTRACTED_DIR" "$GHIDRA_IMPORT_DIR"
    fi
done < <(find "$EXTRACTED_DIR" -type f -print0)

# -----------------------------
# Détection par noms probables
# -----------------------------

print "Détection des noms exécutables probables..."

while IFS= read -r -d '' f; do
    base="$(basename "$f")"

    if [[ "$base" =~ '^(SCUS|SLUS|SCES|SLES|SLPS|SCPS|SIPS|ESPM|PAPX|PCPX)_[0-9]{3}\.[0-9]{2}$' ]] \
       || [[ "$base" =~ '.*\.(EXE|X)$' ]]; then

        rel="${f#$EXTRACTED_DIR/}"
        size="$(stat -c '%s' "$f")"

        if ! grep -Fq "$rel"$'\t' "$EXEC_LIST_PATH" 2>/dev/null; then
            print "$rel\t$size\tname-match" >> "$EXEC_LIST_PATH"
        fi

        copy_relative "$f" "$EXTRACTED_DIR" "$EXEC_DIR"
        copy_relative "$f" "$EXTRACTED_DIR" "$GHIDRA_IMPORT_DIR"
    fi
done < <(find "$EXTRACTED_DIR" -type f -print0)

sort -u -o "$EXEC_LIST_PATH" "$EXEC_LIST_PATH"

# -----------------------------
# Notes Ghidra / DuckStation
# -----------------------------

EXTRACTED_WIN="$(to_win_path "$EXTRACTED_DIR")"
GHIDRA_IMPORT_WIN="$(to_win_path "$GHIDRA_IMPORT_DIR")"
XML_WIN="$(to_win_path "$XML_PATH")"
BOOT_EXE_WIN=""

if [[ -n "$BOOT_EXE_PATH" && -f "$BOOT_EXE_PATH" ]]; then
    BOOT_EXE_WIN="$(to_win_path "$BOOT_EXE_PATH")"
fi

cat > "$GHIDRA_NOTES_PATH" <<EOF
FF7 / PSX dump notes
====================

Config file:
  $CONFIG_PATH

Ghidra Windows:
  $GHIDRA_WIN_DIR

DuckStation Windows:
  $DUCKSTATION_WIN_DIR

Ghidra project name:
  $GHIDRA_PROJECT_NAME

Extracted filesystem:
  $EXTRACTED_WIN

Ghidra import staging folder:
  $GHIDRA_IMPORT_WIN

dumpsxiso XML:
  $XML_WIN

SYSTEM.CNF boot target:
  ${BOOT_TARGET:-UNKNOWN}

Boot executable, WSL:
  ${BOOT_EXE_PATH:-UNKNOWN}

Boot executable, Windows:
  ${BOOT_EXE_WIN:-UNKNOWN}

Recommended Ghidra import:
  Import the boot executable into project "$GHIDRA_PROJECT_NAME".
  Use ghidra_psx_ldr / PSX loader.
  Then run auto-analysis.
EOF

# -----------------------------
# Summary
# -----------------------------

file_count="$(find "$EXTRACTED_DIR" -type f | wc -l | tr -d ' ')"
exec_count="$(find "$EXEC_DIR" -type f | wc -l | tr -d ' ')"

cat > "$SUMMARY_PATH" <<EOF
PSX disc extraction summary
===========================

Config:
  $CONFIG_PATH

Input BIN:
  $BIN_PATH

Input CUE:
  $CUE_PATH

Output:
  $OUT_DIR

Extracted files:
  $file_count

Detected executable-like files:
  $exec_count

SYSTEM.CNF:
  $SYSTEM_CNF_FOUND

Boot target:
  ${BOOT_TARGET:-UNKNOWN}

Boot executable:
  ${BOOT_EXE_PATH:-UNKNOWN}

Important folders:
  extracted/       Full extracted CD filesystem
  metadata/        XML, filelist, hashes, notes
  executables/     PS-X EXE and executable-like files
  ghidra_import/   Files staged for Ghidra import
  original/        Copy of original BIN/CUE
EOF

print ""
print "Extraction terminée."
print ""
print "Résumé:"
print "  $SUMMARY_PATH"
print ""
print "Fichiers pour Ghidra:"
print "  $GHIDRA_IMPORT_DIR"
print ""
print "Notes Ghidra:"
print "  $GHIDRA_NOTES_PATH"