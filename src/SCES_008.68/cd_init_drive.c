#include "common.h"

extern int CdInit(void);
extern void GsSetWorkBase(void*);
extern void movie_sys_init_mdec(void);
extern void CdControlB(int, int, int);
extern int VSync(int);
extern int ff7_unknown_80034384(void);
extern void ff7_unknown_80034F68(void);

extern int g_cd_unknown_80071B8C;
extern int g_cd_unknown_80071B90;

void cd_init_drive(void) {
    while (CdInit() == 0);
    g_cd_unknown_80071B8C = 0;
    GsSetWorkBase(0);
    movie_sys_init_mdec();
    CdControlB(0xe, 0x80, 0);
    VSync(3);
    g_cd_unknown_80071B90 = ff7_unknown_80034384();
    ff7_unknown_80034F68();
}
