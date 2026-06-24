#ifndef FF7_CD_H
#define FF7_CD_H

// CD variables
extern int g_cd_task_index;
extern void (*g_cd_task_callbacks[])(void);
extern int g_cd_current_disk;

// CD DISKINFO
extern char g_cd_diskinfo_buffer;
extern unsigned char g_cd_diskinfo_number_char;
extern const char s_cd_diskinfo_path[];

// CD MOVIEID
extern char g_cd_movie_id_buffer;
extern const char s_cd_movie_id_path[];

// CD functions
extern int cd_process_task(void);
extern int cd_get_disk_number(void);
extern void cd_load_movie_id(void);

#endif // FF7_CD_H
