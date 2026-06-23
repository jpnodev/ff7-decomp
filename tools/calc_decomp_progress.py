#!/usr/bin/env python3
import re
import os

yaml_path = "config/splat/SCES_008.68.yaml"

if not os.path.exists(yaml_path):
    print(f"Error: Splat config not found at {yaml_path}")
    exit(1)

# Regex to parse subsegments like: - [0x1F1C, c, ff7_sys_init]
pattern = re.compile(r"^\s*-\s*\[\s*(0x[0-9a-fA-F]+)\s*,\s*([a-zA-Z0-9_]+)\s*,\s*([^\]\s]+)")
end_pattern = re.compile(r"^\s*-\s*\[\s*(0x[0-9a-fA-F]+)\s*\]")

segments = []
with open(yaml_path, "r") as f:
    for line in f:
        m = pattern.match(line)
        if m:
            offset = int(m.group(1), 16)
            seg_type = m.group(2)
            name = m.group(3)
            segments.append((offset, seg_type, name))
        else:
            m = end_pattern.match(line)
            if m:
                offset = int(m.group(1), 16)
                segments.append((offset, None, None))

# Sort segments by offset
segments.sort(key=lambda x: x[0])

# The executable code starts at 0x800 and ends at 0x3B890 (start of main_data bin section)
code_start = 0x800
code_end = 0x3B890

stats = {
    "c": 0,
    "hasm": 0,
    "asm": 0,
}

for i in range(len(segments) - 1):
    curr_off, seg_type, name = segments[i]
    next_off = segments[i+1][0]
    
    # Only calculate stats within the executable code area
    if curr_off >= code_end:
        continue
    if next_off > code_end:
        next_off = code_end
        
    size = next_off - curr_off
    if seg_type in stats:
        stats[seg_type] += size
    else:
        # Default unknown segment types count as raw ASM
        stats["asm"] += size

total_code = code_end - code_start
c_bytes = stats["c"]
hasm_bytes = stats["hasm"]
asm_bytes = stats["asm"]

c_pct = (c_bytes / total_code) * 100
hasm_pct = (hasm_bytes / total_code) * 100
asm_pct = (asm_bytes / total_code) * 100

print("=== Decompilation Progress (SCES_008.68) ===")
print(f"Total Code Section: {total_code:,} bytes")
print(f"Decompiled (C):     {c_bytes:,} bytes ({c_pct:.2f}%)")
print(f"Hand-written ASM:   {hasm_bytes:,} bytes ({hasm_pct:.2f}%)")
print(f"Remaining ASM:      {asm_bytes:,} bytes ({asm_pct:.2f}%)")
