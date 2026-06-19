#!/usr/bin/env python3
import argparse
import subprocess
import sys
import os

def main():
    parser = argparse.ArgumentParser(description="Compile C source using PsyQ CC1 and maspsx")
    parser.add_argument("--cc1", required=True, help="Path to cc1-psx executable")
    parser.add_argument("--cflags", required=True, help="CC1 flags (as a single string)")
    parser.add_argument("--cpp", default="mipsel-linux-gnu-cpp", help="Path to C preprocessor")
    parser.add_argument("--cppflags", default="-nostdinc -I include", help="CPP flags")
    parser.add_argument("--maspsx", required=True, help="Path to maspsx.py")
    parser.add_argument("--as_bin", required=True, dest="as_bin", help="Path to GNU assembler")
    parser.add_argument("--asflags", default="", help="GNU assembler flags")
    parser.add_argument("--input", required=True, help="Input C file")
    parser.add_argument("-o", "--output", required=True, help="Output object file")
    
    args = parser.parse_args()

    # Create build directory if it doesn't exist
    os.makedirs(os.path.dirname(args.output), exist_ok=True)

    # Temporary files
    base_out = os.path.splitext(args.output)[0]
    preprocessed_file = base_out + ".i"
    assembly_file = base_out + ".s"

    # Step 1: Preprocess (C -> .i)
    # We use -undef -Wall -lang-c to prevent modern GCC from injecting too many modern built-ins
    cpp_cmd = f"{args.cpp} {args.cppflags} -undef -Wall -lang-c {args.input} -o {preprocessed_file}"
    try:
        subprocess.run(cpp_cmd, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error during preprocessing: {e}", file=sys.stderr)
        sys.exit(1)

    # Step 2: Compile (cc1-psx: .i -> .s)
    cc1_cmd = f"{args.cc1} {args.cflags} {preprocessed_file} -o {assembly_file}"
    try:
        subprocess.run(cc1_cmd, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error during compilation (cc1): {e}", file=sys.stderr)
        sys.exit(1)

    # Step 3: Massage and Assemble (maspsx + as: .s -> .o)
    maspsx_cmd = f"python3 {args.maspsx} --run-assembler --gnu-as-path {args.as_bin} {args.asflags} -o {args.output} < {assembly_file}"
    try:
        subprocess.run(maspsx_cmd, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error during assembly (maspsx/as): {e}", file=sys.stderr)
        sys.exit(1)

    # Optional: Clean up .i file, but we keep .s for asm-differ
    try:
        os.remove(preprocessed_file)
    except OSError:
        pass

if __name__ == "__main__":
    main()
