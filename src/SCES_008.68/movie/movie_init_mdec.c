#include "common.h"

extern int ResetCallback(void);
extern void movie_reset_mdec(int);

void movie_init_mdec(int mode) {
    if (mode == 0) {
        ResetCallback();
    }
    movie_reset_mdec(mode);
}
