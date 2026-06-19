extern volatile unsigned int *D_80062C94;
extern volatile unsigned int *D_80062CA4;
extern volatile unsigned int *D_80062C88;
extern volatile unsigned int *D_80062C84;

extern volatile unsigned int D_80062CBC;
extern volatile unsigned int D_80062CC8;
extern volatile unsigned int D_80062CB8;

extern char D_800706BC[];
extern char D_8009AE54[];

extern unsigned int SetIntrMask(unsigned int);
extern unsigned int FUN_8004634c(unsigned int);
extern void ff7_memset(void *, unsigned char, int);

unsigned int FUN_80045f28(unsigned int param_1) {
    unsigned int old_mask = SetIntrMask(0);
    unsigned int temp;
    D_80062CBC = 0;
    temp = D_80062CBC;
    D_80062CC8 = old_mask;
    D_80062CB8 = temp;
    
    switch (param_1 & 7) {
        case 0:
            *D_80062C94 = 0x401;
            *D_80062CA4 |= 0x800;
            *D_80062C88 = 0;
            ff7_memset(D_800706BC, 0, 0x100);
            ff7_memset(D_8009AE54, 0, 0x1800);
            break;
        case 1:
            *D_80062C94 = 0x401;
            *D_80062CA4 |= 0x800;
            *D_80062C88 = 0x02000000;
            *D_80062C88 = 0x01000000;
            break;
    }
    
    SetIntrMask(D_80062CC8);
    
    if ((param_1 & 7) == 0) {
        return FUN_8004634c(param_1);
    }
    
    return 0;
}
