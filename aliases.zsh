# FF7 Decompilation Workflow Aliases
# Source this file in your zshrc: source /mnt/c/Users/clive/ff7-decomp/aliases.zsh

# 1. Extraction (Splat)
# Sépare le binaire en assembleur et intègre les nouveaux fichiers C selon le yaml
alias ff7-split='py -m splat split config/splat/SCES_008.68.yaml'

# 2. Nettoyage des exports Ghidra
# Retire les doublons des symboles exportés de Ghidra avant le split
alias ff7-clean-syms='py tools/ghidra/clean_ghidra_exports.py ghidra_exports/splat/SCES_008.68.symbols.from_ghidra.txt'

# 3. Compilation complète
# Nettoie et recompile tout le projet (C et Assembleur)
alias ff7-build='make clean && make'

# 4. Vérification Locale (Asm-Differ)
# Lance asm-differ avec recompilation automatique (-m) et watch (-w)
# Utilisation: ff7-diff FUN_8004642c
ff7-diff() {
    py tools/asm-differ/diff.py -mw "$1" --no-pager
}

# 5. Vérification Globale
# Compare le binaire final produit avec le binaire d'origine
alias ff7-check='py tools/compare_binaries.py baserom/SCES_008.68 build/SCES_008.68.bin'

# 6. Workflow Combiné (Split + Build)
# Applique le yaml, puis compile le projet
alias ff7-sync='ff7-split && ff7-build'

# ==========================================
# ISO Extraction & Repacking
# ==========================================

# 7. Unpack ISO
# Extrait l'ISO original (défini dans ff7_paths.config.zsh)
alias ff7-unpack='zsh tools/iso/dump_psx_disc.zsh'

# 8. Pack ISO
# Reconstruit l'ISO modifié pour être testé dans l'émulateur
alias ff7-pack='zsh tools/iso/build_iso.zsh'

# 9. Workflow Complet (Sync + Pack ISO)
alias ff7-build-all='ff7-sync && ff7-pack'

# ==========================================
# Outils & Helpers (Préfixe: ff7-tool-)
# ==========================================

# Vérifie le header d'un exécutable PSX
alias ff7-tool-check-header='py tools/check_header.py'

# Lit et parse le header d'un overlay
alias ff7-tool-read-overlay='py tools/read_overlay_header.py'

# Convertit une adresse VRAM en offset dans le fichier binaire
alias ff7-tool-vram-to-fileoff='py tools/vram_to_fileoff.py'

# Test de compilation C vers objet MIPS (wrapper PsyQ)
alias ff7-tool-compile-c='py tools/compile_psyq_c.py'
