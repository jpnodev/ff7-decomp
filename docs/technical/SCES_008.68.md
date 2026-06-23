# Final Fantasy VII PSX EU (SCES_008.68) - Main Executable

This document contains notes and reverse engineering progress for the main game executable (`SCES_008.68`).

## General Information

- **Region**: Europe / PAL
- **Disc**: 1
- **Entry PC**: `0x800110C0`
- **Text Address**: `0x80010000`
- **Text Size**: `0x00060800`
- **Text End**: `0x800707FF`
- **Stack Pointer**: `0x801FFFF0`

## Structure

- **Startup**: `start` at `0x800110C0`. Clears BSS and initializes heap, then calls `main`.
- **Main Game Loop**: TBD

## Symbol Map

### Functions

| Address | Name | Module | Status | Notes |
|---|---|---|---|---|
| 0x800110C0 | start | crt/psyq | identified | PsyQ startup / 2MBYTE.OBJ |
| TBD | main | ff7 | pending | Main entry after runtime startup |
| 0x8001155C | ff7_vsync_handler | ff7/sys | identified | VSync interrupt handler |
| 0x80011F1C | ff7_sys_init | ff7/sys | matched | High-level system initialization |
| 0x800343C8 | cd_init_drive | ff7/cd | matched | CD drive initialization |
| 0x80034F48 | movie_sys_init_mdec | ff7/mdec | matched | High-level system init for MDEC |
| 0x8003E024 | ff7_unknown_8003E024 | ff7 | unknown | Unknown |
| 0x8003E29C | SetVideoMode | ff7/gpu | matched | GPU Video Mode setup |
| 0x8003E4C8 | GsSetWorkBase | ff7/gpu | matched | Sets active workbase for GS |
| 0x80041E38 | movie_init_mdec | ff7/mdec | matched | Conditionally calls ResetCallback, resets MDEC |
| 0x80041F68 | movie_set_mdec_decode_mode | ff7/mdec | matched | Modifies MDEC command word and starts DMA |
| 0x8004208C | movie_reset_mdec | ff7/mdec | matched | Resets DMA channels, sends soft reset, loads tables |
| 0x80042194 | movie_start_mdec_dma_in | ff7/mdec | matched | Hardware config to start incoming DMA to MDEC |
| 0x800422B8 | movie_unknown_800422B8 | ff7/mdec | unknown | Called from movie loop |
| 0x80042BE8 | movie_print_mdec_timeout | ff7/mdec | matched | Error handling/logging for MDEC timeout |
| 0x80042AB8 | movie_wait_mdec_dma_ready | ff7/mdec | matched | Wait loop for DMA completion |
| 0x80043834 | ff7_init_graphics | ff7/gpu | identified | Graphics initialization logic |
| 0x800442A4 | SetGraphDebug | ff7/gpu | matched | GPU Graph Debug setup |
| 0x80044438 | SetDispMask | ff7/gpu | matched | Display Mask configuration |
| 0x80045FEC | gpu_send_gp1_command | ff7/gpu | matched | Wrapper to send GP1 commands to GPU and mirror |
| 0x80046728 | ResetGraph | ff7/gpu | matched | GPU reset logic |

### Global Variables (g_)

| Address | Name | Module | Type | Notes |
|---|---|---|---|---|
| 0x8005154C | g_video_mode | gpu | int | 0=NTSC, 1=PAL |
| 0x80062BAC | g_gp1_command_handlers_ptr | gpu | void* | Pointer to GP1 command functions |
| 0x80062BB0 | g_printf_ptr | sys | void* | Function pointer for logging |
| 0x80062BB4 | g_graph_debug_type | gpu | int | PsyQ Graph Debug |
| 0x80062BB5 | g_is_graph_initialized | gpu | byte | Flag |
| 0x80062BB6 | g_graph_debug_level | gpu | int | PsyQ Graph Debug Level |
| 0x80062BB7 | g_graph_debug_reverse | gpu | byte | PsyQ Graph Debug reverse |
| 0x80062BB8 | g_active_buffer_width | gpu | short | Current draw buffer width |
| 0x80062BBA | g_active_buffer_height | gpu | short | Current draw buffer height |
| 0x80062C34 | g_resolution_width_array | gpu | short[] | Look-up table for resolutions |
| 0x80062C48 | g_resolution_height_array | gpu | short[] | Look-up table for resolutions |
| 0x800706BC | g_gpu_gp1_command_args_mirror | gpu | int[] | Mirror of sent GP1 commands |
| 0x80071B8C | g_cd_unknown_80071B8C | cd | int | Unknown CD flag |
| 0x80071B90 | g_cd_unknown_80071B90 | cd | int | Unknown CD flag |
| 0x80095EF0 | g_vsync_counter | sys | int | VSync frame counter |
| 0x8009AE54 | g_gpu_graph_env_buffer | gpu | DRAWENV | Double buffered DRAWENV |

### Static/Internal Variables (s_)

| Address | Name | Module | Notes |
|---|---|---|---|
| 0x80010B2C | s_mdec_rest_timeout | mdec | Used in wait loops |
| 0x80010B4C | s_dma_status | mdec | Formatting string |
| 0x80010B74 | s_fifo_status | mdec | Formatting string |
| 0x80010BAC | s_timeout | mdec | Formatting string |
| 0x800515EC | s_gs_work_base | gpu | Current active GS workbase |
| 0x80051A04 | s_mdec_quantization_table_1 | mdec | Pre-defined quantization matrix |
| 0x80051A88 | s_mdec_quantization_table_2 | mdec | Pre-defined quantization matrix |
| 0x80062CB8 | s_resetgraph_temp | gpu | Temp variable during reset |
| 0x80062CBC | s_resetgraph_unknown_80062CBC | gpu | Unknown |
| 0x80062CC8 | s_resetgraph_intr_mask | gpu | Temp interrupt mask |

### Hardware Registers & Pointers (ptr_)

| Address | Name | Description |
|---|---|---|
| 0x80051B0C | ptr_DMA_MMADR | DMA MDEC IN Block Address |
| 0x80051B10 | ptr_DMA_MBCR | DMA MDEC IN Block Control |
| 0x80051B14 | ptr_DMA_MCHCR | DMA MDEC IN Channel Control |
| 0x80051B18 | ptr_DMA_OUT_MADR | DMA MDEC OUT Block Address |
| 0x80051B20 | ptr_DMA_OUT_CHCR | DMA MDEC OUT Channel Control |
| 0x80051B3C | ptr_MDEC_REG0 | MDEC Data/Command Register |
| 0x80051B40 | ptr_MDEC_REG1 | MDEC Control Register |
| 0x80051B44 | ptr_DMA_DPCR | DMA Control Register |
| 0x80062C84 | ptr_GPU_GP0 | GPU GP0 Command Register |
| 0x80062C88 | ptr_GPU_GP1 | GPU GP1 Command Register |
| 0x80062C94 | ptr_DPCR | DMA Control Register (duplicate ptr) |
| 0x80062CA4 | ptr_DICR | DMA Interrupt Control Register |

