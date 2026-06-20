#!/bin/bash
FUNC=$1
if [ -z "$FUNC" ]; then
    echo "Usage: ff7-perm-import <function_name>"
    exit 1
fi

ASM_FILE=$(ls asm/SCES_008.68/nonmatchings/$FUNC/*.s | head -n 1)
if [ -z "$ASM_FILE" ]; then
    echo "Error: Could not find assembly file in asm/SCES_008.68/nonmatchings/$FUNC/"
    exit 1
fi

echo "Cleaning up old permuter directories..."
rm -rf nonmatchings/$FUNC

echo "Importing $FUNC into decomp-permuter using $ASM_FILE..."

# Create a temporary C file with the renamed function to satisfy import.py
TEMP_C="src/SCES_008.68/${FUNC}_temp.c"
# Replace FUN_ with func_ for the function definition
sed "s/unsigned int ${FUNC}/unsigned int func_${FUNC#FUN_}/g" src/SCES_008.68/$FUNC.c > "$TEMP_C"

OUTPUT=$(python3 tools/decomp-permuter/import.py "$TEMP_C" "$ASM_FILE" 2>&1)
echo "$OUTPUT"

rm -f "$TEMP_C"

# Extract the directory name from "Done. Imported into nonmatchings/..."
IMPORT_DIR=$(echo "$OUTPUT" | grep -oP "Imported into \K.*")

if [ -n "$IMPORT_DIR" ] && [ -d "$IMPORT_DIR" ]; then
    if [ "$IMPORT_DIR" != "nonmatchings/$FUNC" ]; then
        # Rename the directory to our standard name
        mv "$IMPORT_DIR" "nonmatchings/$FUNC"
    fi
    # If it has a -number suffix, remove it to get the func name
    OLD_FUNC=${OLD_FUNC%-*}
fi
echo "Done! You can now run 'ff7-perm $FUNC' to start permuting."
