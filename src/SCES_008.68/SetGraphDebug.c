#include "common.h"

extern unsigned char g_graph_debug_type;
extern unsigned char g_graph_debug_level;
extern unsigned char g_graph_debug_reverse;
extern int (*g_printf_ptr)(const char *fmt, ...);
extern const char s_SetGraphDebug[];

unsigned char SetGraphDebug(unsigned char level) {
	unsigned char *debug_level_ptr = &g_graph_debug_level;
	unsigned char old_level = *debug_level_ptr;
	*debug_level_ptr = level;
	if (level != 0) {
		g_printf_ptr(s_SetGraphDebug, *debug_level_ptr, g_graph_debug_type, g_graph_debug_reverse);
	}
	return old_level;
}
