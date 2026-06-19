#include "common.h"

extern char D_80010CCC[];
extern unsigned int D_80062B6C;
extern volatile unsigned char D_80062BB4[];
extern unsigned int D_80062BAC;
extern unsigned char D_80062BB6;

extern int printf(const char * fmt, ...);
extern void ff7_memset(void *, int, int);
extern int ResetCallback(void);
extern void GPU_cw(unsigned int);
extern unsigned int FUN_80045f28(unsigned int);
extern char D_80010CEC[];

extern unsigned short D_80062C34[][2];
extern unsigned short D_80062C48[][2];

unsigned int FUN_80043834(unsigned int param_1) {
    if ((param_1 & 7) == 0) {
        printf(D_80010CCC, &D_80062B6C, D_80062BB4);
        ff7_memset((void*)D_80062BB4, 0, 0x80);
        ResetCallback();
        GPU_cw(*(unsigned int *)D_80062BAC & 0x00FFFFFF);
        D_80062BB4[0] = FUN_80045f28(param_1);
        {
        D_80062BB4[1] = 1;

        *(unsigned short *)&D_80062BB4[4] = D_80062C34[*(volatile unsigned char *)&D_80062BB4[0]][0];
        *(unsigned short *)&D_80062BB4[6] = D_80062C48[*(volatile unsigned char *)&D_80062BB4[0]][0];

        ff7_memset((void*)&D_80062BB4[0x10], 0xFF, 0x5C);
        ff7_memset((void*)&D_80062BB4[0x6C], 0xFF, 0x14);
        }
        return D_80062BB4[0];
    } else {
        if (D_80062BB6 > 1) {
            (*(int (**)(const char*, ...))0x80062BB0)(D_80010CEC, param_1);
        }
        return (*(unsigned int (**)(unsigned int))(*(unsigned char**)0x80062BAC + 0x34))(1);
    }
}
