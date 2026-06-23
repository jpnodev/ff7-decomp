#include "common.h"

extern int g_video_mode;

int SetVideoMode(int mode) {
	int previous_mode = g_video_mode;
	g_video_mode = mode;
	return previous_mode;
}
