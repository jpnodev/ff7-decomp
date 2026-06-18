build/SCES_008.68.elf: \
    build/assets/SCES_008.68/psx_header.bin.o \
    build/asm/SCES_008.68/main_raw.s.o
build/assets/SCES_008.68/psx_header.bin.o:
build/asm/SCES_008.68/main_raw.s.o:
-include build/assets/SCES_008.68/psx_header.bin.d build/asm/SCES_008.68/main_raw.s.d
