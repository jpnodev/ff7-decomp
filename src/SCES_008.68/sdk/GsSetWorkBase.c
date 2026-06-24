#include "common.h"


void *GsSetWorkBase(void *base) {
	void *old_base;

	old_base = s_gs_work_base;
	s_gs_work_base = base;
	return old_base;
}
