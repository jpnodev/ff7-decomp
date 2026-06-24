#include "common.h"


void cd_load_movie_id(void) {
    int iVar1;
    char auStack_20[24];
    
    do {
        do {
            iVar1 = CdSearchFile(auStack_20, s_cd_movie_id_path);
        } while (iVar1 == 0);
        
        CdControlB(2, auStack_20, 0);
        CdRead(1, &g_cd_movie_id_buffer, 0x80);
        do {
            iVar1 = CdReadSync(1, 0);
        } while (0 < iVar1);
    } while (iVar1 != 0);
}
