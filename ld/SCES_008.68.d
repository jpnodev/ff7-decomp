build/SCES_008.68.elf: \
    build/assets/SCES_008.68/psx_header.bin.o \
    build/asm/SCES_008.68/before_start.s.o \
    build/asm/SCES_008.68/start.s.o \
    build/asm/SCES_008.68/before_main.s.o \
    build/asm/SCES_008.68/main.s.o \
    build/asm/SCES_008.68/after_main.s.o \
    build/assets/SCES_008.68/main_data.bin.o
build/assets/SCES_008.68/psx_header.bin.o:
build/asm/SCES_008.68/before_start.s.o:
build/asm/SCES_008.68/start.s.o:
build/asm/SCES_008.68/before_main.s.o:
build/asm/SCES_008.68/main.s.o:
build/asm/SCES_008.68/after_main.s.o:
build/assets/SCES_008.68/main_data.bin.o:
-include build/assets/SCES_008.68/psx_header.bin.d build/asm/SCES_008.68/before_start.s.d build/asm/SCES_008.68/start.s.d build/asm/SCES_008.68/before_main.s.d build/asm/SCES_008.68/main.s.d build/asm/SCES_008.68/after_main.s.d build/assets/SCES_008.68/main_data.bin.d
