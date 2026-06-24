#ifndef FF7_GPU_H
#define FF7_GPU_H

// GPU Control Pointers
extern volatile unsigned int *ptr_GPU_GP1;
extern volatile unsigned int *ptr_GPU_GP0;
extern volatile unsigned int *ptr_DPCR;
extern volatile unsigned int *ptr_DICR;

// FF7 Graph settings
extern unsigned char g_graph_debug_level;
extern unsigned char g_graph_debug_type;
extern unsigned char g_graph_debug_reverse;
extern int g_video_mode;

extern char g_gpu_gp1_command_args_mirror[];
extern char g_gpu_graph_env_buffer[];
extern void *s_gs_work_base;
extern void (**g_gp1_command_handlers_ptr)(unsigned int);

// SetDispMask string
extern const char s_SetDispMask[];
extern const char s_SetGraphDebug[];

#endif // FF7_GPU_H
