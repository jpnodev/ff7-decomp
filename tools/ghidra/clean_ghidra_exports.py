import sys

input_file = 'ghidra_exports/splat/SCES_008.68.symbols.from_ghidra.txt'
if len(sys.argv) > 1:
    input_file = sys.argv[1]

output_file = input_file

used_addrs = set()

def load_addrs(filename):
    try:
        with open(filename, "r") as f:
            for line in f:
                line = line.strip()
                if "=" in line:
                    addr_str = line.split("=")[1].split(";")[0].strip()
                    try:
                        addr = int(addr_str, 16)
                        used_addrs.add(addr)
                    except:
                        pass
    except FileNotFoundError:
        pass

# Load manually-defined / custom symbols to filter them out of Ghidra exports
load_addrs("config/symbols/SCES_008.68.manual_syms.txt")
load_addrs("config/symbols/SCES_008.68.user_syms.txt")

with open(input_file, 'r') as f:
    lines = f.readlines()

seen_symbols = set()
output_lines = []

for line in lines:
    # Filter out switch-case labels
    if 'switchD' in line or 'caseD_' in line or 'default =' in line:
        continue
        
    parts = line.split('=')
    if len(parts) > 1:
        sym_name = parts[0].strip()
        # Filter duplicates or malformed symbols
        if sym_name in seen_symbols or sym_name[0].isdigit():
            continue
        seen_symbols.add(sym_name)
        
        # Filter symbols that have a custom definition in manual/user syms
        addr_str = parts[1].split(';')[0].strip()
        try:
            addr = int(addr_str, 16)
            if addr in used_addrs:
                continue
        except ValueError:
            pass
        
    output_lines.append(line)

with open(output_file, 'w') as f:
    f.writelines(output_lines)
