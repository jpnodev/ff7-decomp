extern unsigned char D_80062BB4;
extern unsigned char D_80062BB5;
extern unsigned char D_80062BB6;
extern unsigned short D_80062BB8;
extern unsigned short D_80062BBA;
extern unsigned char D_80062C34[];
extern unsigned char D_80062C48[];
extern unsigned char D_80062C20[];
extern void* D_80062BAC;
extern void ResetCallback(void);
extern void GPU_cw(int);
extern unsigned int FUN_80045f28(unsigned int);
extern int printf(const char * fmt, ...);
extern void ff7_memset(void * dst, unsigned char val, int size);
unsigned int FUN_80043834(unsigned int param_1) {
    unsigned int uVar1;
    if ((param_1 & 7) == 0) {
        printf("ResetGraph:jtb=%08x,env=%08x\n", D_80062BAC, &D_80062BB4);
        ff7_memset(&D_80062BB4, 0, 0x80);
        ResetCallback();
        GPU_cw(0x80062b6c & 0xffffffff);
        D_80062BB4 = FUN_80045f28(param_1);
        D_80062BB5 = 1;
        D_80062BB8 = *(unsigned short *)(&D_80062C34[0] + (unsigned int)D_80062BB4 * 4);
        D_80062BBA = *(unsigned short *)(&D_80062C48[0] + (unsigned int)D_80062BB4 * 4);
        ff7_memset(&D_80062C20, 0xff, 0x5c);
        ff7_memset(&D_80062BB4, 0xff, 0x14);
        uVar1 = D_80062BB4;
    }
    else {
        if (D_80062BB6 >= 2) {
            printf("ResetGraph(%d)...\n", param_1);
        }
        uVar1 = FUN_80045f28(1);
    }
    return uVar1;
}
