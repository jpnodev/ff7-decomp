#include "common.h"

extern unsigned char D_80062BB4;
extern unsigned char D_80062BB6;
extern unsigned char D_80062BB7;
extern int (*D_80062BB0)(const char *fmt, ...);
extern const char D_80010D18[];

unsigned char FUN_80043aa4(unsigned char param_1) {
    unsigned char *p = &D_80062BB6;
    unsigned char cVar1 = *p;
    *p = param_1;
    if (param_1 != 0) {
        D_80062BB0(D_80010D18, *p, D_80062BB4, D_80062BB7);
    }
    return cVar1;
}
