#include "common.h"


void ff7_sys_init(void) {
    StopCallback();
    ResetCallback();
    ff7_init_graphics(0);
    SpuInit();
    g_vsync_counter = 0;
    VSyncCallback(ff7_vsync_handler);
    SetGraphDebug(0);
    SetDispMask(0);
    InitGeom();
    SetVideoMode(1);
}
