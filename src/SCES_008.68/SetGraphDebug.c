#include "common.h"

extern unsigned char GraphDebugType;
extern unsigned char GraphDebugLevel;
extern unsigned char GraphDebugReverse;
extern int (*printf_ptr)(const char *fmt, ...);
extern const char s_SetGraphDebug[];

unsigned char SetGraphDebug(unsigned char param_1) {
    unsigned char *p = &GraphDebugLevel;
    unsigned char cVar1 = *p;
    *p = param_1;
    if (param_1 != 0) {
        printf_ptr(s_SetGraphDebug, *p, GraphDebugType, GraphDebugReverse);
    }
    return cVar1;
}
