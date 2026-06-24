#include "common.h"


unsigned char SetGraphDebug(unsigned char level) {
	unsigned char *debug_level_ptr = &g_graph_debug_level;
	unsigned char old_level = *debug_level_ptr;
	*debug_level_ptr = level;
	if (level != 0) {
		g_printf_ptr(s_SetGraphDebug, *debug_level_ptr, g_graph_debug_type, g_graph_debug_reverse);
	}
	return old_level;
}
