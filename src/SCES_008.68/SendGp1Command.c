#include "common.h"

extern volatile unsigned int *ptr_GPU_GP1;
extern unsigned char Gp1CommandArgsMirror[];

void SendGp1Command(unsigned int command) {
    *ptr_GPU_GP1 = command;
    Gp1CommandArgsMirror[command >> 0x18] = command;
}
