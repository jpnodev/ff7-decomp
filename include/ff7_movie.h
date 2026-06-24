#ifndef FF7_MOVIE_H
#define FF7_MOVIE_H

// Registers
extern volatile unsigned int *ptr_MDEC_REG0;
extern volatile unsigned int *ptr_MDEC_REG1;
extern volatile unsigned int *ptr_DMA_DPCR;
extern volatile unsigned int *ptr_DMA_MDEC_IN_CHCR;
extern volatile unsigned int *ptr_DMA_MDEC_OUT_CHCR;
extern volatile unsigned int *ptr_DMA_MDEC_IN_MADR;
extern volatile unsigned int *ptr_DMA_MDEC_IN_BCR;
extern volatile unsigned int *ptr_DMA_MDEC_OUT_MADR;

// Tables and constants
extern unsigned int s_mdec_quantization_table_1;
extern unsigned int s_mdec_quantization_table_2;

// Strings
extern const char s_timeout[];
extern const char s_dma_status[];
extern const char s_fifo_status[];
extern const char D_80010B10[];
extern const char s_mdec_rest_timeout[];

// Functions
extern void movie_sys_init_mdec(void);
extern void movie_init_mdec(int param);
extern void movie_reset_mdec(unsigned int mode);
extern void movie_start_mdec_dma_in(unsigned int *mdec_cmd, unsigned int flags);
extern int movie_wait_mdec_dma_ready(void);
extern int movie_print_mdec_timeout(const char*);

#endif // FF7_MOVIE_H
