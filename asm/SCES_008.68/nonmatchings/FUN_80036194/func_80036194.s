nonmatching func_80036194, 0x20

glabel func_80036194
    /* 26994 80036194 E8FFBD27 */  addiu      $sp, $sp, -0x18
    /* 26998 80036198 1000BFAF */  sw         $ra, 0x10($sp)
    /* 2699C 8003619C 6DD8000C */  jal        _SpuInit
    /* 269A0 800361A0 21200000 */   addu      $a0, $zero, $zero
    /* 269A4 800361A4 1000BF8F */  lw         $ra, 0x10($sp)
    /* 269A8 800361A8 1800BD27 */  addiu      $sp, $sp, 0x18
    /* 269AC 800361AC 0800E003 */  jr         $ra
    /* 269B0 800361B0 00000000 */   nop
endlabel func_80036194
