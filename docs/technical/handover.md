# Final Fantasy VII (SCES_008.68) - Decompilation Handover Brief

Welcome to the Final Fantasy VII (PSX, PAL Region) decompilation project. 

This document provides a comprehensive overview of the current project state, the established architecture, and the immediate next steps to ensure a smooth handover for the decompilation expert.

## 1. Project Context & Objectives
The goal of this project is to achieve a **100% byte-perfect decompilation** of Final Fantasy VII (Disc 1 - `SCES_008.68`). 
We are using a modern `splat` (spimdisasm) workflow combined with the original **PsyQ SDK toolchain (cc1-psx 2.7.2 and 2.6.3)**, wrapped by `maspsx` and assembled via GNU Binutils `mipsel-linux-gnu-as` / `ld` to ensure a byte-for-byte match with the original 1997 compiler's output.

## 2. Architecture & Toolchain
The repository is organized to separate the decompilation workflow from game assets and documentation:
- **`baserom/`**: Contains the original, unmodified binaries (e.g., `SCES_008.68`).
- **`config/splat/`**: Contains the YAML configuration files dictating how `splat` should split the binaries.
- **`asm/` & `assets/`**: Auto-generated directories where `splat` extracts assembly code (`.s`) and raw data (`.bin`).
- **`src/`**: Destination for the decompiled C code (`.c`).
- **`tools/`**: Project-specific automation scripts and generic utilities (e.g., `tools/iso/build_iso.zsh`, `tools/asm-differ/`, `compare_binaries.py`).
- **`docs/`**: Comprehensive guides detailing the methodology (`docs/workflow/`) and technical details (`docs/technical/`).

## 3. Current State: Decomp-Permuter Integration & Current Function
We have successfully achieved a **perfect byte-for-byte match** of the main executable, and we have decompiled several C functions!
- The `config/splat/SCES_008.68.yaml` is properly configured, separating code (`asm`) and data (`bin`).
- The `Makefile` links all generic `.bin` files and compiles `.c` files using the original 1997 PsyQ toolchain (`cc1-psx-272` with `-O2 -G8`).
- `tools/iso/build_iso.zsh` successfully packages the rebuilt binary into a bootable `.cue`/`.bin` format.
- **Workflow Automation**: All complex commands have been wrapped in `aliases.zsh`. Sourcing this file provides `ff7-split`, `ff7-build`, `ff7-check`, `ff7-diff`, and the permuter aliases.
- **Decomp-Permuter**: We have successfully integrated `decomp-permuter` to find exact assembly matches when the compiler makes arbitrary optimization choices. We use:
  - `ff7-perm-import <func>`: Safely copies the function to a working directory (`nonmatchings/<func>/base.c`) and configures it without polluting `src/`.
  - `ff7-perm <func>`: Runs the permuter to find a 0-score match.
  - `ff7-perm-apply <func> [new_name]`: Automatically copies the winning source back to `src/` and cleans up.

## 4. Next Steps

1. **Continue Decompiling Small Leaf Functions**:
   - Focus on small "leaf" functions (5-20 instructions) without complex SDK calls.
   - Change their type to `c` in `config/splat/SCES_008.68.yaml`, run `ff7-split`, and write the C code in `src/`.
   - **asm-differ Tutorial**: `ff7-diff <nom_de_la_fonction>`
     *Note: If your function has multiple early returns (`jr ra`), append `-ss` or `-sss` to prevent truncation.*

2. **Ghidra Integration (Crucial Workflow Rule)**:
   - **The human user acts as the Ghidra operator.** Ask the user to search for small leaf functions or provide pseudo-code.
   - When the user provides Ghidra pseudocode or addresses, your job is to:
     1. Isolate the function in `splat.yaml`.
     2. Write the C code in `src/`.
     3. Iterate until it matches the assembly, using `ff7-diff` and the permuter when stuck.
   - The user will use the `ExportSplatSymbols.java` script to export named symbols from Ghidra into `ghidra_exports/splat/`.

3. **Tackle the Overlays (`.X` files)**:
   - FF7 uses multiple overlays (`BATTLE.X`, `FIELD.TDB`/`DSCHANGE.X`, etc.) due to the PSX's 2MB RAM limit.
   - Determine their load addresses, identify the loader functions, and create new splat YAML profiles for each overlay (see `docs/technical/overlays.md`).

## 6. Key References
- Please read `docs/workflow/splat_workflow.md` to understand the iterative split/make/compare loop.
- Please read `docs/workflow/naming_conventions.md` to adhere to the established project conventions (e.g., retaining addresses in function names until their roles are 100% understood: `ff7_unknown_80012340`).

Good luck! The foundation is solid, and the path to a full C decompilation is now wide open.
