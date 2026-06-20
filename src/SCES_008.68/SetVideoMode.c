#include "common.h"

extern int VideoMode;

int SetVideoMode(int mode) {
    int previous_mode = VideoMode;
    VideoMode = mode;
    return previous_mode;
}
