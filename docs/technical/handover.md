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

## 3. Current State: First C Function Matched!
We have successfully achieved a **perfect byte-for-byte match** of the main executable, and we have just decompiled our first C function!
- The `config/splat/SCES_008.68.yaml` is properly configured, separating code (`asm`) and data (`bin`).
- The `Makefile` links all generic `.bin` files and compiles `.c` files using the original 1997 PsyQ toolchain (`cc1-psx-272` with `-O2 -G8`).
- `tools/iso/build_iso.zsh` successfully packages the rebuilt binary into a bootable `.cue`/`.bin` format.
- **First Matched Function**: `FUN_8004642c` is 100% matched! We resolved a compiler quirk where PsyQ unexpectedly allocated 8 bytes on the stack for a leaf function by introducing a `volatile char dummy[8];` in the C code to force the stack allocation.
- **Workflow Automation**: All complex commands have been wrapped in `aliases.zsh`. Sourcing this file provides `ff7-split` (which purges old `asm/` files to prevent ghost files), `ff7-build`, `ff7-check`, and `ff7-diff`.

## 4. Next Steps for the Decompilation Expert
You are taking over right as we dive deep into **Phase D (C-Matching)**. 

The environment is stable, automated, and strictly verified. Your immediate priorities are:

1. **Continue Decompiling Small Leaf Functions**:
   - Focus on small "leaf" functions (5-20 instructions) without complex SDK calls.
   - Change their type to `c` in `config/splat/SCES_008.68.yaml`, run `ff7-split`, and write the C code in `src/`.
   - **asm-differ Tutorial**: Use the custom alias to get a side-by-side diff of the instructions:
     `ff7-diff <nom_de_la_fonction>`
     *Note: Since we do not yet generate `.o` files from the original assembly, we perform binary diffing (`-s`). If your function has multiple early returns (`jr ra`), you must append `-ss` or `-sss` to the command line to prevent `asm-differ` from truncating the output too early.*

2. **Ghidra Integration (Crucial Workflow Rule)**:
   - **The human user acts as the Ghidra operator.** Ask the user to search for small leaf functions or provide pseudo-code.
   - When the user provides you with the Ghidra pseudocode, address, or context, it is your job to:
     1. Isolate the function in `splat.yaml`.
     2. Write the C code in `src/`.
     3. Iterate on the C code until it matches the assembly perfectly, leveraging `mips2c` output if needed to get closer to the MIPS structure before tweaking it for `-O2` optimizations.
   - The user will use the `ExportSplatSymbols.java` script to export named symbols from Ghidra into `ghidra_exports/splat/` for you.

3. **Tackle the Overlays (`.X` files)**:
   - FF7 uses multiple overlays (`BATTLE.X`, `FIELD.TDB`/`DSCHANGE.X`, etc.) due to the PSX's 2MB RAM limit.
   - You will need to determine their load addresses, identify the functions that load them, and create new splat YAML profiles for each overlay (documented in `docs/technical/overlays.md`).

## 5. Key References
- Please read `docs/workflow/splat_workflow.md` to understand the iterative split/make/compare loop.
- Please read `docs/workflow/naming_conventions.md` to adhere to the established project conventions (e.g., retaining addresses in function names until their roles are 100% understood: `ff7_unknown_80012340`).

Good luck! The foundation is solid, and the path to a full C decompilation is now wide open.
