extern int cd_process_task(void);
extern int CdSearchFile(char*, const char*);
extern void CdControlB(int, char*, int);
extern void CdRead(int, void*, int);
extern int CdReadSync(int, int);

extern char g_cd_diskinfo_buffer;
extern unsigned char g_cd_diskinfo_number_char;

extern const char s_cd_diskinfo_path[];

int cd_get_disk_number(void) {
    int iVar1;
    char auStack_20[24];
    
    do {
        iVar1 = cd_process_task();
    } while (iVar1 != 0);

    do {
        iVar1 = CdSearchFile(auStack_20, s_cd_diskinfo_path);
        if (iVar1 <= 0) {
            if (iVar1 >= -1) {
                return -1;
            }
        }
        CdControlB(2, auStack_20, 0);
        CdRead(1, &g_cd_diskinfo_buffer, 0x80);
        do {
            iVar1 = CdReadSync(1, 0);
        } while (0 < iVar1);
    } while (iVar1 != 0);

    return g_cd_diskinfo_number_char - '0';
}
