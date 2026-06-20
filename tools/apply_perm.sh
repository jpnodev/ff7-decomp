#!/bin/bash
FUNC=$1
NEW_NAME=$2

if [ -z "$FUNC" ]; then
    echo "Usage: ff7-perm-apply <function_name> [new_name]"
    echo "Example: ff7-perm-apply FUN_80043834 ResetGraph"
    exit 1
fi

TARGET_NAME=${NEW_NAME:-$FUNC}

if [ ! -d "nonmatchings/$FUNC" ]; then
    echo "Error: Directory nonmatchings/$FUNC does not exist."
    exit 1
fi

# Find the output directory with the lowest score
BEST_OUTPUT=$(ls -d nonmatchings/$FUNC/output-* 2>/dev/null | sort -t '-' -k 2 -n | head -n 1)

if [ -z "$BEST_OUTPUT" ]; then
    echo "Error: No permuter output found in nonmatchings/$FUNC/"
    exit 1
fi

echo "Found best permuter output: $BEST_OUTPUT"
SOURCE_FILE="$BEST_OUTPUT/source.c"

if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: $SOURCE_FILE not found."
    exit 1
fi

# We need to find the original C file in src/ to replace
# We assume it's in src/SCES_008.68/$FUNC.c (or we can search for it)
DEST_FILE=$(find src -name "$FUNC.c" | head -n 1)

if [ -z "$DEST_FILE" ]; then
    echo "Warning: Could not find $FUNC.c in src/. Creating a new file in src/SCES_008.68/$TARGET_NAME.c"
    DEST_FILE="src/SCES_008.68/$TARGET_NAME.c"
else
    # If a new name is provided, we should rename the file as well
    if [ "$FUNC" != "$TARGET_NAME" ]; then
        NEW_DEST_FILE="$(dirname "$DEST_FILE")/$TARGET_NAME.c"
        mv "$DEST_FILE" "$NEW_DEST_FILE"
        DEST_FILE="$NEW_DEST_FILE"
    fi
fi

# The permuter output has the function named as `func_...`. We need to rename it to TARGET_NAME
# The name in the permuter is usually func_ followed by the hex address (stripped from FUN_)
# But we can just use sed to replace func_${FUNC#FUN_} with $TARGET_NAME
FUNC_NAME_IN_PERM="func_${FUNC#FUN_}"

echo "Applying $SOURCE_FILE to $DEST_FILE and renaming $FUNC_NAME_IN_PERM to $TARGET_NAME..."
sed "s/$FUNC_NAME_IN_PERM/$TARGET_NAME/g" "$SOURCE_FILE" > "$DEST_FILE"

echo "Done! The new code is in $DEST_FILE."

# Ask user if they want to delete the nonmatchings directory
read -p "Do you want to delete the permuter working directory (nonmatchings/$FUNC)? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "nonmatchings/$FUNC"
    echo "Deleted nonmatchings/$FUNC"
    
    # Check if nonmatchings is empty and delete it if so
    if [ -d "nonmatchings" ] && [ -z "$(ls -A nonmatchings)" ]; then
        rmdir nonmatchings
        echo "Deleted empty nonmatchings/ directory"
    fi
fi
