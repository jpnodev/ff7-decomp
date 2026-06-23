#include "common.h"

extern void *s_gs_work_base;

void *GsSetWorkBase(void *base) {
	void *old_base;

	old_base = s_gs_work_base;
	s_gs_work_base = base;
	return old_base;
}
