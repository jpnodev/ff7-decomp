#!/usr/bin/env python3
import sys
import hashlib
import os

def get_hash(filepath):
    h = hashlib.sha1()
    with open(filepath, 'rb') as f:
        h.update(f.read())
    return h.hexdigest()

def get_file_content(filepath):
    with open(filepath, 'rb') as f:
        return f.read()

def main():
    if len(sys.argv) != 3:
        print("Usage: compare_binaries.py <expected_bin> <built_bin>")
        sys.exit(1)
        
    expected_path = sys.argv[1]
    built_path = sys.argv[2]
    
    if not os.path.exists(expected_path):
        print(f"Error: {expected_path} not found.")
        sys.exit(1)
        
    if not os.path.exists(built_path):
        print(f"Error: {built_path} not found.")
        sys.exit(1)
        
    expected_hash = get_hash(expected_path)
    built_hash = get_hash(built_path)
    
    if expected_hash == built_hash:
        print(f"\033[92mOK: Both binaries match perfectly! (SHA1: {expected_hash})\033[0m")
        sys.exit(0)
    else:
        print(f"\033[91mFAIL: Binaries do not match.\033[0m")
        print(f"Expected: {expected_hash} ({expected_path})")
        print(f"Built:    {built_hash} ({built_path})")
        
        # Output first different byte offset
        expected_data = get_file_content(expected_path)
        built_data = get_file_content(built_path)
        
        min_len = min(len(expected_data), len(built_data))
        for i in range(min_len):
            if expected_data[i] != built_data[i]:
                print(f"First diff at offset 0x{i:X}: Expected {expected_data[i]:02X}, Built {built_data[i]:02X}")
                break
                
        if len(expected_data) != len(built_data):
            print(f"File sizes differ: Expected {len(expected_data)} bytes, Built {len(built_data)} bytes")
            
        sys.exit(1)

if __name__ == "__main__":
    main()
