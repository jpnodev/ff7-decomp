#include "common.h"
typedef unsigned int uint;
extern void printf(const char *fmt, ...);
extern void ff7_memset(void *dst, unsigned char value, unsigned int size);
extern void ResetCallback(void);
extern void GPU_cw(unsigned int mask);
extern unsigned int ResetGraph(unsigned int param);
extern unsigned char IsGraphInitialized;
extern unsigned short ActiveBufferWidth;
extern unsigned short ActiveBufferHeight;
extern unsigned char GraphDebugLevel;
extern unsigned char GraphDebugType;
extern const unsigned short ResolutionWidthArray[];
extern const unsigned short ResolutionHeightArray[];
extern unsigned int Gp1CommandHandlersPtr;

uint InitGraphics(uint param_1) {
    uint result;
    if ((param_1 & 7) == 0) {
        // ResetGraph path (full reset)
        printf("ResetGraph:jtb=%08x,env=%08x\n", (unsigned int)0x80010c98, (unsigned int)GraphDebugType);
        ff7_memset(&GraphDebugType, 0, 0x80);
        ResetCallback();
        GPU_cw(0x62b6c);
        GraphDebugType = ResetGraph(param_1);
        IsGraphInitialized = 1;
        ActiveBufferWidth = ResolutionWidthArray[GraphDebugType * 2];
        ActiveBufferHeight = ResolutionHeightArray[GraphDebugType * 2];
        ff7_memset((void *)((char *)&GraphDebugType + 0x6C), 0xFF, 0x5C);
        ff7_memset((void *)((char *)&GraphDebugType + 0x6C), 0xFF, 0x14);
        result = (uint)GraphDebugType;
    } else {
        if (GraphDebugLevel > 1) {
            printf("ResetGraph(%d)...\n", param_1);
        }
        result = ResetGraph(1);
    }
    return result;
}
