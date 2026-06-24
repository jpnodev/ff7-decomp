#include "common.h"


void gpu_send_gp1_command(unsigned int command) {
  *ptr_GPU_GP1 = command;
  g_gpu_gp1_command_args_mirror[command >> 0x18] = command;
}
