#include "common.h"

extern int movie_print_mdec_timeout(const char*);

extern volatile unsigned int* volatile ptr_MDEC_REG1;

extern const char s_mdec_rest_timeout[];

int movie_wait_mdec_dma_ready(void) {
    register volatile unsigned int* p asm("v1") = ptr_MDEC_REG1;
    volatile int timeout = 0x100000;
    
    if ((*p & 0x20000000) != 0) {
        do {
            if (--timeout == -1) {
                movie_print_mdec_timeout(s_mdec_rest_timeout);
                return -1;
            }
        } while ((*ptr_MDEC_REG1 & 0x20000000) != 0);
    }
    
    return 0;
}
