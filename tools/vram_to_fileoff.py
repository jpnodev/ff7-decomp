#!/usr/bin/env python3
import sys

BASE_VRAM = 0x80010000
HEADER_SIZE = 0x800

if len(sys.argv) != 2:
    print("Usage: vram_to_fileoff.py <vram_hex>")
    sys.exit(1)

vram = int(sys.argv[1], 16)
off = HEADER_SIZE + (vram - BASE_VRAM)

print(f"VRAM:        0x{vram:08X}")
print(f"File offset: 0x{off:X}")
