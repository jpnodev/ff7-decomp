# Script References

This document explains the purpose and usage of the utility scripts located in the `scripts/` directory.

## `clean_ghidra_exports.py`

### Purpose
When exporting symbols from Ghidra using the `ExportSplatSymbols.java` script, it often exports numerous auto-generated switch and case labels (e.g., `switchD`, `caseD_1`, `default`). These duplicate labels across different functions cause `splat` to fail during the split phase due to symbol collisions.

This script cleans the exported symbol file (`ghidra_exports/splat/SCES_008.68.symbols.from_ghidra.txt`) by removing all lines containing `switchD`, `caseD_`, and `default =`.

### Usage
Run the script manually whenever you re-export symbols from Ghidra:

```bash
python3 scripts/clean_ghidra_exports.py
```
