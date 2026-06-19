SECTIONS
{
    __romPos = 0;
    _gp = 0x80062CF8;
    psx_header_ROM_START = __romPos;
    psx_header_VRAM = ADDR(.psx_header);
    .psx_header : AT(psx_header_ROM_START) SUBALIGN(16)
    {
        FILL(0x00000000);
        psx_header_DATA_START = .;
        build/assets/SCES_008.68/psx_header.bin.o(.data);
        psx_header_DATA_END = .;
        psx_header_DATA_SIZE = ABSOLUTE(psx_header_DATA_END - psx_header_DATA_START);
    }
    __romPos += SIZEOF(.psx_header);
    psx_header_ROM_END = __romPos;
    psx_header_VRAM_END = .;

    main_ROM_START = __romPos;
    main_VRAM = ADDR(.main);
    .main 0x80010000 : AT(main_ROM_START) SUBALIGN(4)
    {
        FILL(0x00000000);
        main_TEXT_START = .;
        build/asm/SCES_008.68/before_start.s.o(.text);
        build/asm/SCES_008.68/start.s.o(.text);
        build/asm/SCES_008.68/before_main.s.o(.text);
        build/asm/SCES_008.68/main.s.o(.text);
        build/asm/SCES_008.68/after_main.s.o(.text);
        build/src/SCES_008.68/FUN_80043834.c.o(.text);
        build/asm/SCES_008.68/after_FUN_80043834.s.o(.text);
        build/src/SCES_008.68/FUN_80045f28.c.o(.text);
        build/asm/SCES_008.68/after_FUN_80045f28.s.o(.text);
        build/src/SCES_008.68/FUN_8004634c.c.o(.text);
        build/src/SCES_008.68/ff7_memset.c.o(.text);
        build/asm/SCES_008.68/after_ff7_memset.s.o(.text);
        . = ALIGN(., 16);
        main_TEXT_END = .;
        main_TEXT_SIZE = ABSOLUTE(main_TEXT_END - main_TEXT_START);
        main_DATA_START = .;
        build/asm/SCES_008.68/before_start.s.o(.data);
        build/asm/SCES_008.68/start.s.o(.data);
        build/asm/SCES_008.68/before_main.s.o(.data);
        build/asm/SCES_008.68/main.s.o(.data);
        build/asm/SCES_008.68/after_main.s.o(.data);
        build/src/SCES_008.68/FUN_80043834.c.o(.data);
        build/asm/SCES_008.68/after_FUN_80043834.s.o(.data);
        build/src/SCES_008.68/FUN_80045f28.c.o(.data);
        build/asm/SCES_008.68/after_FUN_80045f28.s.o(.data);
        build/src/SCES_008.68/FUN_8004634c.c.o(.data);
        build/src/SCES_008.68/ff7_memset.c.o(.data);
        build/asm/SCES_008.68/after_ff7_memset.s.o(.data);
        build/assets/SCES_008.68/main_data.bin.o(.data);
        . = ALIGN(., 16);
        main_DATA_END = .;
        main_DATA_SIZE = ABSOLUTE(main_DATA_END - main_DATA_START);
        main_RODATA_START = .;
        build/asm/SCES_008.68/before_start.s.o(.rodata);
        build/asm/SCES_008.68/start.s.o(.rodata);
        build/asm/SCES_008.68/before_main.s.o(.rodata);
        build/asm/SCES_008.68/main.s.o(.rodata);
        build/asm/SCES_008.68/after_main.s.o(.rodata);
        build/src/SCES_008.68/FUN_80043834.c.o(.rodata);
        build/asm/SCES_008.68/after_FUN_80043834.s.o(.rodata);
        build/src/SCES_008.68/FUN_80045f28.c.o(.rodata);
        build/asm/SCES_008.68/after_FUN_80045f28.s.o(.rodata);
        build/src/SCES_008.68/FUN_8004634c.c.o(.rodata);
        build/src/SCES_008.68/ff7_memset.c.o(.rodata);
        build/asm/SCES_008.68/after_ff7_memset.s.o(.rodata);
        . = ALIGN(., 16);
        main_RODATA_END = .;
        main_RODATA_SIZE = ABSOLUTE(main_RODATA_END - main_RODATA_START);
        main_BSS_START = .;
        build/asm/SCES_008.68/before_start.s.o(.bss);
        build/asm/SCES_008.68/start.s.o(.bss);
        build/asm/SCES_008.68/before_main.s.o(.bss);
        build/asm/SCES_008.68/main.s.o(.bss);
        build/asm/SCES_008.68/after_main.s.o(.bss);
        build/src/SCES_008.68/FUN_80043834.c.o(.bss);
        build/asm/SCES_008.68/after_FUN_80043834.s.o(.bss);
        build/src/SCES_008.68/FUN_80045f28.c.o(.bss);
        build/asm/SCES_008.68/after_FUN_80045f28.s.o(.bss);
        build/src/SCES_008.68/FUN_8004634c.c.o(.bss);
        build/src/SCES_008.68/ff7_memset.c.o(.bss);
        build/asm/SCES_008.68/after_ff7_memset.s.o(.bss);
        . = ALIGN(., 16);
        main_BSS_END = .;
        main_BSS_SIZE = ABSOLUTE(main_BSS_END - main_BSS_START);
    }
    __romPos += SIZEOF(.main);
    __romPos = ALIGN(__romPos, 16);
    . = ALIGN(., 16);
    main_ROM_END = __romPos;
    main_VRAM_END = .;

    /DISCARD/ :
    {
        *(*);
    }
}
