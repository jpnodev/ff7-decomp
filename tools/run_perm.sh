#!/bin/bash
FUNC=$1
shift
if [ -z "$FUNC" ]; then
    echo "Usage: ff7-perm <function_name> [permuter options...]"
    exit 1
fi

python3 tools/decomp-permuter/permuter.py nonmatchings/$FUNC/ "$@"
