#include "common.h"

extern volatile unsigned int *D_80062C88;
extern unsigned char D_800706BC[];

void FUN_800457ec(unsigned int param_1) {
    *D_80062C88 = param_1;
    D_800706BC[param_1 >> 0x18] = param_1;
}
