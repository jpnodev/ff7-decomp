#!/usr/bin/env bash
INPUT="$(realpath "$1")"
OUTPUT="$(realpath "$3")"
cd /mnt/c/Users/clive/ff7-decomp
python3 tools/compile_psyq_c.py --cc1 tools/compilers/cc1-psx-272 --cflags '-quiet -O2 -G8 -g0 -funsigned-char -fno-builtin' --cpp mipsel-linux-gnu-cpp --cppflags '-nostdinc -I include' --maspsx tools/maspsx/maspsx.py --as_bin mipsel-linux-gnu-as --input "$INPUT" -o "$OUTPUT"