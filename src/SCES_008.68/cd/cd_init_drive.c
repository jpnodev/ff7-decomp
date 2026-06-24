#include "common.h"




void cd_init_drive(void) {
    int iVar1;
    
    do {
        iVar1 = CdInit();
    } while (iVar1 == 0);
    g_cd_task_index = 0;
    GsSetWorkBase(0);
    movie_sys_init_mdec();
    CdControlB(14, 128, 0);
    VSync(3);
    g_cd_current_disk = cd_get_disk_number();
    cd_load_movie_id();
}
