#include "common.h"


void movie_set_mdec_decode_mode(unsigned int *mdec_cmd, unsigned int flags) {
    if (flags & 1) {
        *mdec_cmd &= 0xF7FFFFFF;
    } else {
        *mdec_cmd |= 0x08000000;
    }

    if (flags & 2) {
        *mdec_cmd |= 0x02000000;
    } else {
        *mdec_cmd &= 0xFDFFFFFF;
    }

    movie_start_mdec_dma_in(mdec_cmd, *(unsigned short*)mdec_cmd);
}
