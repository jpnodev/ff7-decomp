// Force gcc to map pointer to s0 to match original byte-for-byte
extern int g_cd_task_index;
extern void (*g_cd_task_callbacks[])(void);

int cd_process_task(void) {
    if ((unsigned int)g_cd_task_index >= 21) {
        while (1);
    }
    {
        register int *p asm("s0") = &g_cd_task_index;
        g_cd_task_callbacks[*p]();
        return *p;
    }
}
