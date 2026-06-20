#include "common.h"

extern int StopCallback(void);
extern int ResetCallback(void);
extern void InitGraphics(int);
extern void SpuInit(void);
extern volatile short VsyncCounter;
extern int VSyncCallback(void (*f)(void));
extern void VsyncHandler(void);
extern void SetGraphDebug(int);
extern void SetDispMask(int);
extern void InitGeom(void);
extern int SetVideoMode(int);

void SysInit(void) {
    StopCallback();
    ResetCallback();
    InitGraphics(0);
    SpuInit();
    VsyncCounter = 0;
    VSyncCallback(VsyncHandler);
    SetGraphDebug(0);
    SetDispMask(0);
    InitGeom();
    SetVideoMode(1);
}
