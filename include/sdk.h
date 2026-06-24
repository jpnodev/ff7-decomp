#ifndef SDK_H
#define SDK_H

// stdio / stdlib
extern int printf(const char *fmt, ...);
extern void exit(void);

// libapi
extern int StopCallback(void);
extern int ResetCallback(void);

// libetc
extern void VSync(int mode);
extern int VSyncCallback(void (*f)(void));
extern int SetVideoMode(int mode);

// libcd
extern int CdInit(void);
extern int CdSearchFile(char *file, const char *name);
extern void CdControlB();
extern void CdRead(int sectors, void *buf, int mode);
extern int CdReadSync(int mode, int *result);

// libgpu
extern unsigned char SetGraphDebug(unsigned char level);
extern void SetDispMask(int mask);
extern unsigned int GetGraphType(unsigned int);

// libgs
extern void *GsSetWorkBase(void *base);

// libgte
extern void InitGeom(void);

// libspu
extern void SpuInit(void);
extern void _SpuInit(int);

// Hardware specific interrupt
extern unsigned int SetIntrMask(unsigned int mask);

#endif // SDK_H
