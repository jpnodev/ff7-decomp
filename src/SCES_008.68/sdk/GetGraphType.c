#include "common.h"


unsigned int GetGraphType(unsigned int mode) {
    *ptr_GPU_GP1 = 0x10000007;
    if ((*ptr_GPU_GP0 & 0xffffff) != 2) {
        *ptr_GPU_GP0 = (*ptr_GPU_GP1 & 0x3fff) | 0xe1001000;
        (void)*ptr_GPU_GP0;
        
        if ((*ptr_GPU_GP1 & 0x1000) == 0) {
            return 0;
        }
        
        if ((mode & 8) == 0) {
            return 1;
        }
        *ptr_GPU_GP1 = 0x20000504;
        return 2;
    }

    if ((mode & 8) == 0) {
        return 3;
    }
    *ptr_GPU_GP1 = 0x09000001;
    return 4;
}
