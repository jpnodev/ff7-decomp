def apply(config, args):
    config["arch"] = "mipsel"
    # Base directory for the original extracted assembly
    config["baseimg"] = "baserom/SCES_008.68"
    config["myimg"] = "build/SCES_008.68.bin"
    config["mapfile"] = "build/SCES_008.68.map"
    config["source_directories"] = ["src", "asm", "include"]
    
    # Toolchain configuration
    config["objdump_executable"] = "mipsel-linux-gnu-objdump"
    config["make_command"] = ["make"]
    
    # We compare object files, not the whole binary, for leaf functions
    # asm-differ expects object files to compare against base.
    # In a typical splat setup, splat generates assembly in asm/
    # make builds both src/ and asm/ into build/src/ and build/asm/
    config["build_dir"] = "."
    config["expected_dir"] = "."
