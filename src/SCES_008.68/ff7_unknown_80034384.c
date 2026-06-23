extern int func_80034B50(void);
extern int func_8003FAB0(char*, const char*);
extern void CdControlB(int, char*, int);
extern void func_80041C4C(int, void*, int);
extern int func_80041D54(int, int);

extern char D_80069A3C;
extern unsigned char D_80069A43;

extern const char D_80010438[];

int ff7_unknown_80034384(void) {
    int iVar1;
    char auStack_20[24];
    
    do {
        iVar1 = func_80034B50();
    } while (iVar1 != 0);

    do {
        iVar1 = func_8003FAB0(auStack_20, D_80010438);
        if (iVar1 <= 0) {
            if (iVar1 >= -1) {
                return -1;
            }
        }
        CdControlB(2, auStack_20, 0);
        func_80041C4C(1, &D_80069A3C, 0x80);
        do {
            iVar1 = func_80041D54(1, 0);
        } while (0 < iVar1);
    } while (iVar1 != 0);

    return D_80069A43 - 0x30;
}
