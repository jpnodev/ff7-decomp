from pathlib import Path
import struct
import sys

if len(sys.argv) < 2:
    print("Usage: python check_header.py <SCES_008.68_file>")
    sys.exit(1)

p = Path(sys.argv[1])
data = p.read_bytes()

def u32(off):
    return struct.unpack_from("<I", data, off)[0]

magic = data[0:8]
pc     = u32(0x10)
gp     = u32(0x14)
t_addr = u32(0x18)
t_size = u32(0x1C)
sp     = u32(0x30)

print(f"Magic:      {magic!r}")
print(f"Entry PC:   0x{pc:08X}")
print(f"Header GP:  0x{gp:08X}")
print(f"Text addr:  0x{t_addr:08X}")
print(f"Text size:  0x{t_size:08X}")
print(f"Text end:   0x{t_addr + t_size - 1:08X}")
print(f"Stack:      0x{sp:08X}")
print(f"File size:  0x{len(data):X}")
print(f"Expected:   0x{0x800 + t_size:X} = header 0x800 + text size")
