nonmatching func_8004642C, 0x2C

glabel func_8004642C
    /* 36C2C 8004642C F8FFBD27 */  addiu      $sp, $sp, -0x8
    /* 36C30 80046430 0600C010 */  beqz       $a2, .L8004644C
    /* 36C34 80046434 FFFFC224 */   addiu     $v0, $a2, -0x1
    /* 36C38 80046438 FFFF0324 */  addiu      $v1, $zero, -0x1
  .L8004643C:
    /* 36C3C 8004643C 000085A0 */  sb         $a1, 0x0($a0)
    /* 36C40 80046440 FFFF4224 */  addiu      $v0, $v0, -0x1
    /* 36C44 80046444 FDFF4314 */  bne        $v0, $v1, .L8004643C
    /* 36C48 80046448 01008424 */   addiu     $a0, $a0, 0x1
  .L8004644C:
    /* 36C4C 8004644C 0800BD27 */  addiu      $sp, $sp, 0x8
    /* 36C50 80046450 0800E003 */  jr         $ra
    /* 36C54 80046454 00000000 */   nop
endlabel func_8004642C
