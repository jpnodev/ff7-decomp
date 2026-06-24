#include "common.h"


int SetVideoMode(int mode) {
	int previous_mode = g_video_mode;
	g_video_mode = mode;
	return previous_mode;
}
