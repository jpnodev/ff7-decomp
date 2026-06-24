#include "common.h"



void movie_start_mdec_dma_in(unsigned int *mdec_cmd_ptr, unsigned int block_count) {
    movie_wait_mdec_dma_ready();
    *ptr_DMA_DPCR |= 0x88;
    *ptr_DMA_MDEC_IN_MADR = (unsigned int)(mdec_cmd_ptr + 1);
    *ptr_DMA_MDEC_IN_BCR = ((block_count >> 5) << 0x10) | 0x20;
    *ptr_MDEC_REG0 = *mdec_cmd_ptr;
    *ptr_DMA_MDEC_IN_CHCR = 0x1000201;
}
