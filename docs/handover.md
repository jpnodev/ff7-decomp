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
- **`scripts/`**: Project-specific automation scripts (e.g., `build_iso.zsh`, `dump_psx_disc.zsh`).
- **`tools/`**: Reusable generic utilities (e.g., `compare_binaries.py`, `vram_to_fileoff.py`).
- **`workflow/` & `docs/`**: Comprehensive guides detailing the naming conventions, the splat workflow, and reverse engineering notes.

## 3. Current State: 100% Assembly Byte-Match Achieved
We have successfully achieved a **perfect byte-for-byte match** of the main executable in pure assembly.
- The `config/splat/SCES_008.68.yaml` is properly configured. We successfully bypassed a major assembler issue ("branch relaxation" altering binary size by misinterpreting raw data as code) by explicitly splitting the file into a code segment (`asm`) up to offset `0x3B890`, and a raw data segment (`bin`) afterwards.
- The `Makefile` has been customized to automatically link all `splat`-extracted generic `.bin` files into the final ELF.
- `scripts/build_iso.zsh` successfully packages the rebuilt binary into a bootable `.cue`/`.bin` format using `mkpsxiso` and copies it to the emulator directory. 
- **Validation**: The rebuilt ISO boots perfectly in DuckStation. The intro video plays, and the main menu is fully functional.

## 4. Next Steps for the Decompilation Expert
You are taking over at the most exciting phase: **Phase D (C-Matching)**. 

The environment is stable, automated, and strictly verified. Your immediate priorities are:

1. **Identify and Decompile Small Leaf Functions**:
   - The PsyQ toolchain (`cc1-psx-272` with `-G8`) has been successfully integrated via `tools/compile_psyq_c.py`.
   - **DO NOT** begin by decompiling large, complex functions like `_start`, `main`, or PsyQ SDK initializations.
   - Start by isolating a very small "leaf" function (5-20 instructions, no SDK calls, no complex switches).
   - Change its type to `c` in `config/splat/SCES_008.68.yaml`, generate the C file, and use the `INCLUDE_ASM` macro for the surrounding un-decompiled code.
   - Compile and compare using `tools/compile_psyq_c.py` and `tools/compare_binaries.py` (or locally generated assembly diffs) until you achieve a 100% byte match.

2. **Ghidra Integration (Crucial Workflow Rule)**:
   - **The human user acts as the Ghidra operator.** Ask the user to search for small leaf functions or provide pseudo-code.
   - When the user provides you with the Ghidra pseudocode, address, or context, it is your job to:
     1. Isolate the function in `splat.yaml`.
     2. Write the C code in `src/`.
     3. Iterate on the C code until it matches the assembly perfectly, leveraging `mips2c` output if needed to get closer to the MIPS structure before tweaking it for `-O2` optimizations.
   - The user will use the `ExportSplatSymbols.java` script to export named symbols from Ghidra into `ghidra_exports/splat/` for you.

3. **Tackle the Overlays (`.X` files)**:
   - FF7 uses multiple overlays (`BATTLE.X`, `FIELD.TDB`/`DSCHANGE.X`, etc.) due to the PSX's 2MB RAM limit.
   - You will need to determine their load addresses, identify the functions that load them, and create new splat YAML profiles for each overlay (documented in `docs/overlays.md`).

## 5. Key References
- Please read `workflow/splat_workflow.md` to understand the iterative split/make/compare loop.
- Please read `workflow/naming_conventions.md` to adhere to the established project conventions (e.g., retaining addresses in function names until their roles are 100% understood: `ff7_unknown_80012340`).

Good luck! The foundation is solid, and the path to a full C decompilation is now wide open.
