#include "common.h"

extern volatile unsigned int *D_80062C88;
extern volatile unsigned int *D_80062C84;

unsigned int FUN_8004634c(unsigned int param_1) {
    *D_80062C88 = 0x10000007;
    if ((*D_80062C84 & 0xffffff) != 2) {
        *D_80062C84 = (*D_80062C88 & 0x3fff) | 0xe1001000;
        (void)*D_80062C84;
        
        if ((*D_80062C88 & 0x1000) == 0) {
            return 0;
        }
        
        if ((param_1 & 8) == 0) {
            return 1;
        }
        *D_80062C88 = 0x20000504;
        return 2;
    }

    if ((param_1 & 8) == 0) {
        return 3;
    }
    *D_80062C88 = 0x09000001;
    return 4;
}
