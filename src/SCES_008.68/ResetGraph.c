extern volatile unsigned int *ptr_DPCR;
extern volatile unsigned int *ptr_DICR;
extern volatile unsigned int *ptr_GPU_GP1;
extern volatile unsigned int *ptr_GPU_GP0;

extern volatile unsigned int ResetGraph_D_80062CBC;
extern volatile unsigned int ResetGraph_D_80062CC8;
extern volatile unsigned int ResetGraph_D_80062CB8;

extern char Gp1CommandArgsMirror[];
extern char GraphEnvironmentBuffer[];

extern unsigned int SetIntrMask(unsigned int);
extern unsigned int GetGraphType(unsigned int);
extern void ff7_memset(void *, unsigned char, int);

unsigned int ResetGraph(unsigned int mode) {
    unsigned int old_mask = SetIntrMask(0);
    unsigned int temp;
    ResetGraph_D_80062CBC = 0;
    temp = ResetGraph_D_80062CBC;
    ResetGraph_D_80062CC8 = old_mask;
    ResetGraph_D_80062CB8 = temp;
    
    switch (mode & 7) {
        case 0:
            *ptr_DPCR = 0x401;
            *ptr_DICR |= 0x800;
            *ptr_GPU_GP1 = 0;
            ff7_memset(Gp1CommandArgsMirror, 0, 0x100);
            ff7_memset(GraphEnvironmentBuffer, 0, 0x1800);
            break;
        case 1:
            *ptr_DPCR = 0x401;
            *ptr_DICR |= 0x800;
            *ptr_GPU_GP1 = 0x02000000;
            *ptr_GPU_GP1 = 0x01000000;
            break;
    }
    
    SetIntrMask(ResetGraph_D_80062CC8);
    
    if ((mode & 7) == 0) {
        return GetGraphType(mode);
    }
    
    return 0;
}
