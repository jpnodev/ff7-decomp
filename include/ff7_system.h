#ifndef FF7_SYSTEM_H
#define FF7_SYSTEM_H

// FF7 Types and memory
extern void ff7_memset(unsigned char *dst, int val, int size);

// FF7 initialization and vsync
extern void ff7_init_graphics(int mode);
extern void ff7_vsync_handler(void);
extern volatile short g_vsync_counter;

// Global pointers
extern int (*g_printf_ptr)(const char *fmt, ...);

// ResetGraph / System internal variables
extern volatile unsigned int s_resetgraph_unknown_80062CBC;
extern volatile unsigned int s_resetgraph_intr_mask;
extern volatile unsigned int s_resetgraph_temp;

#endif // FF7_SYSTEM_H
