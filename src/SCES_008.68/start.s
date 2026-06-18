.include "macro.inc"

.set noat
.set noreorder

.section .text, "ax"

/*
 * =========================================================================
 *  ENTRY POINT: start
 * =========================================================================
 * Equivalent to:
 *   void start(void)
 *   {
 *     undefined4 *puVar1;
 *     undefined4 unaff_retaddr;
 * 
 *     // Clear BSS memory region
 *     puVar1 = &DAT_80062dc0; // _bss
 *     do {
 *       *puVar1 = 0;
 *       puVar1 = puVar1 + 1;
 *     } while (puVar1 < &UNK_8009ffa8); // _bss_end
 */
glabel start
    lui        $v0, %hi(_bss)
    addiu      $v0, $v0, %lo(_bss)
    lui        $v1, %hi(_bss_end)
    addiu      $v1, $v1, %lo(_bss_end)
  .L800110D0:
    sw         $zero, 0x0($v0)
    addiu      $v0, $v0, 0x4
    sltu       $at, $v0, $v1
    bnez       $at, .L800110D0
     nop
endlabel start

/*
 *     // Set up stack pointer and prepare registers for heap initialization
 */
glabel stup1
    addiu      $v0, $zero, 0x4
    nop
    nop
    nop
    nop
    lui        $a0, %hi(D_8001116C)
    addiu      $a0, $a0, %lo(D_8001116C)
    addu       $a0, $a0, $v0
    lw         $v0, 0x0($a0)
    lui        $t0, %hi(D_80000004)
    or         $sp, $v0, $t0
    lui        $a0, %hi(_bss_end)
    addiu      $a0, $a0, %lo(_bss_end)
    sll        $a0, $a0, 3
    srl        $a0, $a0, 3
    lui        $v1, %hi(D_80062CE8)
    lw         $v1, %lo(D_80062CE8)($v1)
    nop
    subu       $a1, $v0, $v1
    subu       $a1, $a1, $a0
    or         $a0, $a0, $t0
    
    /* DAT_80062dc0 = unaff_retaddr; (Save Return Address to BSS start) */
    lui        $at, %hi(_bss)
    sw         $ra, %lo(_bss)($at)
    
    /* Set Global Pointer (gp) and Frame Pointer (fp) */
    lui        $gp, %hi(_gp)
    addiu      $gp, $gp, %lo(_gp)
    addu       $fp, $sp, $zero
    
    /* InitHeap((ulong *)&DAT_8009ffac, 0x158058); */
    jal        InitHeap
     addi      $a0, $a0, %lo(D_80000004) # Delay slot handwritten instruction
    
    /* Restore Return Address from BSS start */
    lui        $ra, %hi(_bss)
    lw         $ra, %lo(_bss)($ra)
endlabel stup1
    nop

/*
 *     // Call main() and trigger a trap/break
 *     main();
 *     trap(1);
 *     halt_baddata();
 *   }
 */
glabel stup0
    jal        main
     nop
    .word      0x0000004D
endlabel stup0

dlabel D_8001116C
    /* Stack base address pointer and padding */
    .word      0x00200000
    .word      0x00200000
    .word      0x00200000
    .word      0x00200000
enddlabel D_8001116C
