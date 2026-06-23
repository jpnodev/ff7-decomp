extern int func_8003FAB0(char*, const char*);
extern void CdControlB(int, char*, int);
extern void func_80041C4C(int, void*, int);
extern int func_80041D54(int, int);

extern const char D_8001049C[];
extern char D_8009A308;

void ff7_unknown_80034F68(void) {
    int iVar1;
    char auStack_20[24];
    
    do {
        do {
            iVar1 = func_8003FAB0(auStack_20, D_8001049C);
        } while (iVar1 == 0);
        
        CdControlB(2, auStack_20, 0);
        func_80041C4C(1, &D_8009A308, 0x80);
        do {
            iVar1 = func_80041D54(1, 0);
        } while (0 < iVar1);
    } while (iVar1 != 0);
}
