#include "common.h"

void FUN_8004642c(unsigned char *dst, unsigned char val, int count) {
    int i = count - 1;
    if (count != 0) {
        do {
            *dst = val;
            i--;
            dst++;
        } while (i != -1);
    }
}
