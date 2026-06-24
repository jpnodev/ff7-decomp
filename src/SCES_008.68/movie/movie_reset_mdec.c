#include "common.h"




void movie_reset_mdec(unsigned int mode) {
    switch (mode) {
    case 0:
        *ptr_MDEC_REG1 = 0x80000000;
        *ptr_DMA_MDEC_IN_CHCR = 0;
        *ptr_DMA_MDEC_OUT_CHCR = 0;
        *ptr_MDEC_REG1 = 0x60000000;
        movie_start_mdec_dma_in(&s_mdec_quantization_table_1, 0x20);
        movie_start_mdec_dma_in(&s_mdec_quantization_table_2, 0x20);
        break;
    case 1:
        *ptr_MDEC_REG1 = 0x80000000;
        *ptr_DMA_MDEC_IN_CHCR = 0;
        *ptr_DMA_MDEC_OUT_CHCR = 0;
        *ptr_DMA_MDEC_OUT_CHCR;
        *ptr_MDEC_REG1 = 0x60000000;
        break;
    default:
        printf(D_80010B10, mode);
        exit();
        break;
    }
}
