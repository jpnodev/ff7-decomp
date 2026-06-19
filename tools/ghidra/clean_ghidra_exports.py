import sys

input_file = 'ghidra_exports/splat/SCES_008.68.symbols.from_ghidra.txt'
output_file = input_file

with open(input_file, 'r') as f:
    lines = f.readlines()

seen_symbols = set()
output_lines = []

for line in lines:
    if 'switchD' in line or 'caseD_' in line or 'default =' in line:
        continue
        
    parts = line.split('=')
    if len(parts) > 1:
        sym_name = parts[0].strip()
        if sym_name in seen_symbols or sym_name[0].isdigit():
            continue
        seen_symbols.add(sym_name)
        
    output_lines.append(line)

with open(output_file, 'w') as f:
    f.writelines(output_lines)
