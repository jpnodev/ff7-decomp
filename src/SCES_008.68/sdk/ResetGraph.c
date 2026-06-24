#include "common.h"




unsigned int ResetGraph(unsigned int mode) {
	unsigned int old_mask = SetIntrMask(0);
	unsigned int temp;
	s_resetgraph_unknown_80062CBC = 0;
	temp = s_resetgraph_unknown_80062CBC;
	s_resetgraph_intr_mask = old_mask;
	s_resetgraph_temp = temp;

	switch (mode & 7) {
	case 0:
		*ptr_DPCR = 0x401;
		*ptr_DICR |= 0x800;
		*ptr_GPU_GP1 = 0;
		ff7_memset(g_gpu_gp1_command_args_mirror, 0, 0x100);
		ff7_memset(g_gpu_graph_env_buffer, 0, 0x1800);
		break;
	case 1:
		*ptr_DPCR = 0x401;
		*ptr_DICR |= 0x800;
		*ptr_GPU_GP1 = 0x02000000;
		*ptr_GPU_GP1 = 0x01000000;
		break;
	}

	SetIntrMask(s_resetgraph_intr_mask);

	if ((mode & 7) == 0) {
		return GetGraphType(mode);
	}

	return 0;
}
