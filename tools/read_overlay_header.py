#!/usr/bin/env python3
import sys
import struct
import gzip

def read_header(filepath):
    with open(filepath, 'rb') as f:
        data = f.read(16)
        
    if len(data) >= 8:
        decompressed_size = struct.unpack('<I', data[0:4])[0]
        unknown = struct.unpack('<I', data[4:8])[0]
        magic = data[8:10]
        
        print(f"File: {filepath}")
        if magic == b'\x1f\x8b':
            print("Type: GZIP compressed overlay")
            print(f"Decompressed Size: {decompressed_size} bytes")
            print(f"Unknown Field: 0x{unknown:08X}")
        else:
            print("Type: Unknown or uncompressed overlay")
            print(f"Raw hex start: {data.hex()}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: read_overlay_header.py <overlay.X>")
        sys.exit(1)
    read_header(sys.argv[1])
