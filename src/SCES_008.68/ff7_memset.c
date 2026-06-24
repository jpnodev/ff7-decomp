#include "common.h"

void ff7_memset(unsigned char *dst, int val, int count) {
    volatile char dummy[8]; // @todo: only to match binary, useless
    int i = count - 1;
    if (count != 0) {
        do {
            *dst = val;
            i--;
            dst++;
        } while (i != -1);
    }
}
