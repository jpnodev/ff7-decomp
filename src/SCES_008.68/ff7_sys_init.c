#include "common.h"

extern int StopCallback(void);
extern int ResetCallback(void);
extern void ff7_init_graphics(int);
extern void SpuInit(void);
extern volatile short g_vsync_counter;
extern int VSyncCallback(void (*f)(void));
extern void ff7_vsync_handler(void);
extern void SetGraphDebug(int);
extern void SetDispMask(int);
extern void InitGeom(void);
extern int SetVideoMode(int);

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
