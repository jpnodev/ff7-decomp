#include "common.h"


void movie_init_mdec(int mode) {
    if (mode == 0) {
        ResetCallback();
    }
    movie_reset_mdec(mode);
}
