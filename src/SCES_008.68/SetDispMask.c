#include "common.h"

extern unsigned char GraphDebugLevel;
extern int (*printf_ptr)(const char *fmt, ...);
extern const char s_SetDispMask[];
extern void ff7_memset(unsigned char *dst, int val, int size);
extern void (**Gp1CommandHandlersPtr)(unsigned int);

void SetDispMask(int mask) {
    unsigned int gp1_command;
    unsigned char *p = &GraphDebugLevel;
    unsigned char *dst;

    if (1 < *p) {
        printf_ptr(s_SetDispMask, mask);
    }
    
    dst = p + 0x6A;
    if (mask == 0) {
        ff7_memset(dst, -1, 0x14);
    }
    
    {
        void (**funcs)(unsigned int) = Gp1CommandHandlersPtr;
        gp1_command = 0x3000001;
        if (mask != 0) {
            gp1_command = 0x3000000;
        }
        
        funcs[4](gp1_command);
    }
}
