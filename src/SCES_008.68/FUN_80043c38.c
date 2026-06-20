#include "common.h"

extern unsigned char GraphDebugLevel;
extern int (*printf_ptr)(const char *fmt, ...);
extern const char s_SetDispMask[];
extern void ff7_memset(unsigned char *dst, int val, int size);
extern void (**D_80062BAC)(unsigned int);

void FUN_80043c38(int param_1) {
    unsigned int uVar1;
    unsigned char *p = &GraphDebugLevel;
    unsigned char *dst;

    if (1 < *p) {
        printf_ptr(s_SetDispMask, param_1);
    }
    
    dst = p + 0x6A;
    if (param_1 == 0) {
        ff7_memset(dst, -1, 0x14);
    }
    
    {
        void (**funcs)(unsigned int) = D_80062BAC;
        uVar1 = 0x3000001;
        if (param_1 != 0) {
            uVar1 = 0x3000000;
        }
        
        funcs[4](uVar1);
    }
}
