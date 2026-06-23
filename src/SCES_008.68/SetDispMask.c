#include "common.h"

extern unsigned char g_graph_debug_level;
extern int (*g_printf_ptr)(const char *fmt, ...);
extern const char s_SetDispMask[];
extern void ff7_memset(unsigned char *dst, int val, int size);
extern void (**g_gp1_command_handlers_ptr)(unsigned int);

void SetDispMask(int mask) {
  unsigned int gp1_command;
  unsigned char *debug_level_ptr = &g_graph_debug_level;
  unsigned char *dst;

  if (1 < *debug_level_ptr) {
    g_printf_ptr(s_SetDispMask, mask);
  }

  dst = debug_level_ptr + 0x6A;
  if (mask == 0) {
    ff7_memset(dst, -1, 0x14);
  }

  {
    void (**funcs)(unsigned int) = g_gp1_command_handlers_ptr;
    gp1_command = 0x3000001;
    if (mask != 0) {
      gp1_command = 0x3000000;
    }

    funcs[4](gp1_command);
  }
}
