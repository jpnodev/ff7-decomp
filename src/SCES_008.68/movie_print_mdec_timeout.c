#include "common.h"

extern int printf(const char *, ...);

extern volatile unsigned int *ptr_MDEC_REG0;
extern volatile unsigned int *ptr_MDEC_REG1;
extern volatile unsigned int *ptr_DMA_DPCR;
extern volatile unsigned int *ptr_DMA_MDEC_IN_CHCR;
extern volatile unsigned int *ptr_DMA_MDEC_OUT_CHCR;
extern volatile unsigned int *ptr_DMA_MDEC_IN_MADR;
extern volatile unsigned int *ptr_DMA_MDEC_IN_BCR;
extern volatile unsigned int *ptr_DMA_MDEC_OUT_MADR;

extern const char s_timeout[];
extern const char s_dma_status[];
extern const char s_fifo_status[];

int movie_print_mdec_timeout(const char *operation_name) {
	unsigned int mdec_status;

	printf(s_timeout, operation_name);
	mdec_status = *ptr_MDEC_REG1;
	printf(s_dma_status, (*ptr_DMA_MDEC_IN_CHCR >> 0x18) & 1,
		   (*ptr_DMA_MDEC_OUT_CHCR >> 0x18) & 1, *ptr_DMA_MDEC_IN_MADR,
		   *ptr_DMA_MDEC_OUT_MADR);
	printf(s_fifo_status, (~mdec_status) >> 31, (mdec_status >> 0x1e) & 1,
		   (mdec_status >> 0x1d) & 1, (mdec_status >> 0x1c) & 1,
		   (mdec_status >> 0x1b) & 1, (mdec_status >> 0x19) & 1,
		   (mdec_status >> 0x17) & 1);

	*ptr_MDEC_REG1 = 0x80000000;
	*ptr_DMA_MDEC_IN_CHCR = 0;
	*ptr_DMA_MDEC_OUT_CHCR = 0;
	*ptr_DMA_MDEC_OUT_CHCR;
	*ptr_MDEC_REG1 = 0x60000000;
	return 0;
}
