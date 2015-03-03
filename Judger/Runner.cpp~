#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <unistd.h>
#include <time.h>
#include <stdarg.h>
#include <ctype.h>
#include <sys/wait.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/user.h>
#include <sys/syscall.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/signal.h>
#include <sys/stat.h>
#include <unistd.h>

#define STD_MB 1048576
#define STD_T_LIM 2
#define STD_F_LIM (STD_MB<<5)
#define STD_M_LIM (STD_MB<<7)
#define BUFFER_SIZE 512

#define OJ_WT0 0
#define OJ_WT1 1
#define OJ_CI 2
#define OJ_RI 3
#define OJ_AC 4
#define OJ_PE 5
#define OJ_WA 6
#define OJ_TL 7
#define OJ_ML 8
#define OJ_OL 9
#define OJ_RE 10
#define OJ_CE 11
#define OJ_CO 12
#define OJ_TR 13
/*copy from ZOJ
 http://code.google.com/p/zoj/source/browse/trunk/judge_client/client/tracer.cc?spec=svn367&r=367#39
 */
#ifdef __i386
#define REG_SYSCALL orig_eax
#define REG_RET eax
#define REG_ARG0 ebx
#define REG_ARG1 ecx
#else
#define REG_SYSCALL orig_rax
#define REG_RET rax
#define REG_ARG0 rdi
#define REG_ARG1 rsi

#endif

static int DEBUG = 1;
static char oj_home[BUFFER_SIZE];
static int oi_mode=0;

static char lang_ext[12][8] = { "c", "cc", "pas", "java", "rb", "sh", "py", "php","pl", "cs","m","bas" };

namespace Runner
{
    struct StartInfo
    {
        char stdin_file[BUFFER_SIZE];
        char stdout_file[BUFFER_SIZE];
        char stderr_file[BUFFER_SIZE];
        int time_limit;
        int file_limit;
        int process_limit;
        int stack_memory_limit;
        int memory_limit;
        int uid;
        bool is_path_file;
        char work_dir[BUFFER_SIZE];
        char** command;
        void init()
        {
            memset(stdin_file,0,sizeof(stdin_file));
            memset(stdout_file,0,sizeof(stdout_file));
            memset(stderr_file,0,sizeof(stderr_file));
            memset(work_dir,0,sizeof(work_dir));
            time_limit=0;
            file_limit=0;
            process_limit=0;
            stack_memory_limit=0;
            memory_limit=0;
            uid=0;
            is_path_file=false;
        }
        StartInfo()
        {
            init();
        }
    };
    struct ProcessInfo
    {
        enum Status{Normal,Success,Failed,TimeLimitError,MemoryLimitError,OutputLimitError,RuntimeError};

        int time;
        int memory;
        int exit_code;
        Status flag;
        void init()
        {
            flag=Normal;
            time=0;
            memory=0;
            exit_code=0;
        }
        ProcessInfo()
        {
            init();
        }
    };

    long get_file_size(const char * filename)
    {
        struct stat f_stat;
        if (stat(filename, &f_stat) == -1)
            return 0;
        return (long) f_stat.st_size;
    }
    int get_proc_status(int pid, const char * mark)
    {
        FILE * pf;
        char fn[BUFFER_SIZE], buf[BUFFER_SIZE];
        int ret = 0;
        sprintf(fn, "/proc/%d/status", pid);
        pf = fopen(fn, "r");
        int m = strlen(mark);
        while (pf && fgets(buf, BUFFER_SIZE - 1, pf))
        {
            buf[strlen(buf) - 1] = 0;
            if (strncmp(buf, mark, m) == 0)
            {
                sscanf(buf + m + 1, "%d", &ret);
            }
        }
        if (pf)
            fclose(pf);
        return ret;
    }
    void run_command(const StartInfo& start_info,ProcessInfo& process_info)
    {
        process_info.init();
        pid_t pid = fork();
        if(pid == 0)//child
        {
                if(*start_info.work_dir)
                    chdir(start_info.work_dir);
                if(*start_info.stdin_file)
                    freopen(start_info.stdin_file, "r", stdin);
                if(*start_info.stdout_file)
                    freopen(start_info.stdout_file, "w", stdout);
                if(*start_info.stderr_file)
                    freopen(start_info.stderr_file, "w", stderr);

                // trace me
                ptrace(PTRACE_TRACEME, 0, NULL, NULL);

                // set the limit
                struct rlimit LIM; // time limit, file limit& memory limit

                // time limit
                if(start_info.time_limit)
                {
                    LIM.rlim_cur = start_info.time_limit/1000 + 1;
                    LIM.rlim_max = LIM.rlim_cur;
                    setrlimit(RLIMIT_CPU, &LIM);
                    alarm(0);
                    alarm(start_info.time_limit/1000*2);
                }

                // file limit
                if(start_info.file_limit)
                {
                    LIM.rlim_max = start_info.file_limit * 1024 + STD_MB;
                    LIM.rlim_cur = start_info.file_limit * 1024;
                    setrlimit(RLIMIT_FSIZE, &LIM);
                }

                // proc limit
                if(start_info.process_limit)
                {
                    LIM.rlim_cur=LIM.rlim_max=start_info.process_limit;
                    setrlimit(RLIMIT_NPROC, &LIM);
                }

                // set the stack
                if(start_info.stack_memory_limit)
                {
                    LIM.rlim_cur = start_info.stack_memory_limit * 1024;
                    LIM.rlim_max = start_info.stack_memory_limit * 1024;
                    setrlimit(RLIMIT_STACK, &LIM);
                }

                // set the memory
                if(start_info.memory_limit)
                {
                    LIM.rlim_cur = start_info.memory_limit*1024/2*3;
                    LIM.rlim_max = start_info.memory_limit*1024*2;
                    setrlimit(RLIMIT_AS, &LIM);
                }

                nice(19);
                if(start_info.uid != 0)
                {
                    while(setgid(start_info.uid)!=0) sleep(1);
                    while(setuid(start_info.uid)!=0) sleep(1);
                    while(setresuid(start_info.uid, start_info.uid, start_info.uid)!=0) sleep(1);
                }

                if(start_info.is_path_file)
                    execvp(start_info.command[0], start_info.command);
                else execv(start_info.command[0], start_info.command);
                printf("error\n");
                exit(1);
        }else{//parent
                process_info.flag = ProcessInfo::Success;

                int temp_memory;
                int status, sig;
                struct rusage ruse;
                while (1)
                {
                    // check the usage
                    wait4(pid, &status, 0, &ruse);

                    temp_memory = get_proc_status(pid, "VmPeak:") << 10;
                    if (temp_memory > process_info.memory)
                        process_info.memory = temp_memory;

                    if (process_info.memory > start_info.memory_limit * 1024 && start_info.memory_limit != 0)
                    {
                        if (DEBUG)
                            printf("out of memory %d\n", process_info.memory);
                        if (process_info.flag == ProcessInfo::Success)
                            process_info.flag = ProcessInfo::MemoryLimitError;
                        ptrace(PTRACE_KILL, pid, NULL, NULL);
                        break;
                    }

                    if (WIFEXITED(status))
                    {
                        process_info.exit_code = WEXITSTATUS(status);
                        break;
                    }

                    if (start_info.file_limit != 0 && get_file_size(start_info.stdout_file) + get_file_size(start_info.stderr_file) > start_info.file_limit)
                    {
                        process_info.flag = ProcessInfo::OutputLimitError;
                        ptrace(PTRACE_KILL, pid, NULL, NULL);
                        break;
                    }

                    if (WIFSIGNALED(status))//异常结束
                    {
                        /*  WIFSIGNALED: if the process is terminated by signal
                        *
                        *  psignal(int sig, char *s)，like perror(char *s)，print out s, with error msg from system of sig
                        * sig = 5 means Trace/breakpoint trap
                        * sig = 11 means Segmentation fault
                        * sig = 25 means File size limit exceeded
                        */
                        sig = WTERMSIG(status);
                        if (DEBUG)
                        {
                            printf("WTERMSIG=%d\n", sig);
                        }
                        if (process_info.flag==ProcessInfo::Success)
                        {
                            switch (sig)
                            {
                                case SIGCHLD:case SIGALRM:
                                    alarm(0);
                                case SIGKILL:case SIGXCPU:
                                    process_info.flag=ProcessInfo::TimeLimitError;
                                    break;
                                case SIGXFSZ:
                                    process_info.flag=ProcessInfo::OutputLimitError;
                                    break;
                                default:
                                    process_info.flag=ProcessInfo::RuntimeError;
                            }
                        }
                        break;
                    }
                    /*     comment from http://www.felix021.com/blog/read.php?1662
                        WIFSTOPPED: return true if the process is paused or stopped while ptrace is watching on it
                        WSTOPSIG: get the signal if it was stopped by signal
                    */

                    // check the system calls
                    ptrace(PTRACE_SYSCALL, pid, NULL, NULL);
            }
            process_info.time  = ruse.ru_utime.tv_sec * 1000 + ruse.ru_utime.tv_usec / 1000;
            process_info.time += ruse.ru_stime.tv_sec * 1000 + ruse.ru_stime.tv_usec / 1000;
        }
    }
}

int main(int argc, char** argv)
{
    Runner::StartInfo start_info;
    Runner::ProcessInfo process_info;
    char* cmd[] = { "g++", "Main.cc", "-o", "Main",NULL};
    char* error_file = "ce.txt";
    start_info.command = cmd;
    memcpy(start_info.stderr_file,error_file,sizeof(error_file));
    start_info.is_path_file = true;

    Runner::run_command(start_info,process_info);

    printf("compile:%d\n",process_info.exit_code);
    printf("flag:%d\n",process_info.flag);
    printf("time:%d\n",process_info.time);
    printf("memory:%d\n",process_info.memory);

    char* exec_cmd[] = {"./Main",NULL};
    start_info.init();

    start_info.command = exec_cmd;
    start_info.is_path_file = false;
    char *input_file="input.txt";
    char *output_file="output.txt";

    memcpy(start_info.stdin_file,input_file,sizeof(input_file));
    memcpy(start_info.stdout_file,output_file,sizeof(output_file));
    printf("%s\n",output_file);
    printf("%s\n",start_info.stdout_file);

    Runner::run_command(start_info,process_info);

    printf("exit code:%d\n",process_info.exit_code);
    printf("flag:%d\n",process_info.flag);
    printf("time:%d\n",process_info.time);
    printf("memory:%d\n",process_info.memory);

    return 0;
}

