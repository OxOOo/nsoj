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

#include "okcalls.h"

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

//static int sleep_tmp;
#define ZOJ_COM

//static char buf[BUFFER_SIZE];

long get_file_size(const char * filename)
{
    struct stat f_stat;

    if (stat(filename, &f_stat) == -1)
    {
        return 0;
    }

    return (long) f_stat.st_size;
}

void write_log(const char *fmt, ...)
{
    va_list ap;
    char buffer[4096];
    //      time_t          t = time(NULL);
    //int l;
    sprintf(buffer,"%s/log/client.log",oj_home);
    FILE *fp = fopen(buffer, "a+");
    if (fp == NULL)
    {
        fprintf(stderr, "openfile error!\n");
        system("pwd");
    }
    va_start(ap, fmt);
    //l =
    vsprintf(buffer, fmt, ap);
    fprintf(fp, "%s\n", buffer);
    if (DEBUG)
        printf("%s\n", buffer);
    va_end(ap);
    fclose(fp);

}

int call_counter[512];

int compile(int lang)
{
    int pid;

    const char * CP_C[] = { "gcc", "Main.c", "-o", "Main", "-O2","-Wall", "-lm",
                            "--static", "-std=c99", "-DONLINE_JUDGE", NULL
                          };
    const char * CP_X[] = { "g++", "Main.cc", "-o", "Main","-O2", "-Wall",
                            "-lm", "--static", "-DONLINE_JUDGE", NULL
                          };
    const char * CP_P[] = { "fpc", "Main.pas", "-O2","-Co", "-Ct","-Ci", NULL };

    pid = fork();
    if (pid == 0)
    {
        struct rlimit LIM;
        LIM.rlim_max = 60;
        LIM.rlim_cur = 60;
        setrlimit(RLIMIT_CPU, &LIM);

        LIM.rlim_max = 90 * STD_MB;
        LIM.rlim_cur = 90 * STD_MB;
        setrlimit(RLIMIT_FSIZE, &LIM);

        LIM.rlim_max = 1024 * STD_MB;
        LIM.rlim_cur = 1024 * STD_MB;
        setrlimit(RLIMIT_AS, &LIM);
        if (lang != 2)
        {
            freopen("ce.txt", "w", stderr);
            //freopen("/dev/null", "w", stdout);
        }
        else
        {
            freopen("ce.txt", "w", stdout);
        }
        switch (lang)
        {
        case 0:
            execvp(CP_C[0], (char * const *) CP_C);
            break;
        case 1:
            execvp(CP_X[0], (char * const *) CP_X);
            break;
        case 2:
            execvp(CP_P[0], (char * const *) CP_P);
            break;
        default:
            printf("nothing to do!\n");
        }
        if (DEBUG)
            printf("compile end!\n");
        exit(0);
    }
    else
    {
        int status=0;

        waitpid(pid, &status, 0);
        if (DEBUG)
            printf("status=%d\n", status);
        return status;
    }

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

void run_solution(int & lang, char * work_dir, int & time_lmt, int & usedtime,
                  int & mem_lmt)
{
    nice(19);
    // now the user is "judger"
    chdir(work_dir);
    // open the files
    freopen("data.in", "r", stdin);
    freopen("user.out", "w", stdout);
    freopen("error.out", "a+", stderr);
    // trace me
    ptrace(PTRACE_TRACEME, 0, NULL, NULL);
    // run me
    if (lang != 3)
        chroot(work_dir);

    while(setgid(1723)!=0) sleep(1);
    while(setuid(1723)!=0) sleep(1);
    while(setresuid(1723, 1723, 1723)!=0) sleep(1);

    // child
    // set the limit
    struct rlimit LIM; // time limit, file limit& memory limit
    // time limit
    if(oi_mode)
        LIM.rlim_cur = time_lmt+1;
    else
        LIM.rlim_cur = (time_lmt - usedtime / 1000) + 1;
    LIM.rlim_max = LIM.rlim_cur;
    setrlimit(RLIMIT_CPU, &LIM);
    alarm(0);
    alarm(time_lmt*2);

    // file limit
    LIM.rlim_max = STD_F_LIM + STD_MB;
    LIM.rlim_cur = STD_F_LIM;
    setrlimit(RLIMIT_FSIZE, &LIM);

    // proc limit
    LIM.rlim_cur=LIM.rlim_max=1;
    setrlimit(RLIMIT_NPROC, &LIM);

    // set the stack
    LIM.rlim_cur = STD_MB << 6;
    LIM.rlim_max = STD_MB << 6;
    setrlimit(RLIMIT_STACK, &LIM);

    // set the memory
    LIM.rlim_cur = STD_MB *mem_lmt/2*3;
    LIM.rlim_max = STD_MB *mem_lmt*2;
    setrlimit(RLIMIT_AS, &LIM);

    execl("./Main", "./Main", (char *)NULL);
    exit(0);
}

void print_runtimeerror(char * err)
{
    FILE *ferr=fopen("error.out","a+");
    fprintf(ferr,"Runtime Error:%s\n",err);
    fclose(ferr);
}

void watch_solution(pid_t pidApp, char * infile, int & ACflg, int isspj,
                    char * userfile, char * outfile, int solution_id, int lang,
                    int & topmemory, int mem_lmt, int & usedtime, int time_lmt, int & p_id,
                    int & PEflg, char * work_dir)
{
    // parent
    int tempmemory;
    int sub_level=0;
    if (DEBUG)
        printf("pid=%d judging %s\n", pidApp, infile);

    int status, sig, exitcode;
    struct user_regs_struct reg;
    struct rusage ruse;
    int sub = 0;
    pid_t subwatcher=0;
    while (1)
    {
        // check the usage

        wait4(-1, &status, 0, &ruse);

        tempmemory = get_proc_status(pidApp, "VmPeak:") << 10;

        if (tempmemory > topmemory)
            topmemory = tempmemory;

        if (topmemory > mem_lmt * STD_MB)
        {
            if (DEBUG)
                printf("out of memory %d\n", topmemory);
            if (ACflg == OJ_AC)
                ACflg = OJ_ML;
            ptrace(PTRACE_KILL, pidApp, NULL, NULL);
            break;
        }

        if (WIFEXITED(status))
            break;
        if (get_file_size("error.out")&&!oi_mode)
        {
            ACflg = OJ_RE;
            ptrace(PTRACE_KILL, pidApp, NULL, NULL);
            break;
        }

        if (!isspj && get_file_size(userfile) > get_file_size(outfile) * 2+1024)
        {
            ACflg = OJ_OL;
            ptrace(PTRACE_KILL, pidApp, NULL, NULL);
            break;
        }

        exitcode = WEXITSTATUS(status);
        /*exitcode == 5 waiting for next CPU allocation          * ruby using system to run,exit 17 ok
         *  */
        if (exitcode == 0x05 || exitcode == 0)
            //go on and on
            ;
        else
        {

            if (DEBUG)
            {
                printf("status>>8=%d\n", exitcode);

            }
            //psignal(exitcode, NULL);

            if (ACflg == OJ_AC)
            {
                switch (exitcode)
                {
                case SIGCHLD:
                case SIGALRM:
                    alarm(0);
                case SIGKILL:
                case SIGXCPU:
                    ACflg = OJ_TL;
                    break;
                case SIGXFSZ:
                    ACflg = OJ_OL;
                    break;
                default:
                    ACflg = OJ_RE;
                }
                print_runtimeerror(strsignal(exitcode));
            }
            ptrace(PTRACE_KILL, pidApp, NULL, NULL);

            break;
        }
        if (WIFSIGNALED(status))
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
                psignal(sig, NULL);
            }
            if (ACflg == OJ_AC)
            {
                switch (sig)
                {
                case SIGCHLD:
                case SIGALRM:
                    alarm(0);
                case SIGKILL:
                case SIGXCPU:
                    ACflg = OJ_TL;
                    break;
                case SIGXFSZ:
                    ACflg = OJ_OL;
                    break;

                default:
                    ACflg = OJ_RE;
                }
                print_runtimeerror(strsignal(sig));
            }
            break;
        }
        /*     comment from http://www.felix021.com/blog/read.php?1662

          WIFSTOPPED: return true if the process is paused or stopped while ptrace is watching on it
          WSTOPSIG: get the signal if it was stopped by signal
         */

        // check the system calls
        ptrace(PTRACE_GETREGS, pidApp, NULL, &reg);

        {
            if (sub == 1 && call_counter[reg.REG_SYSCALL] > 0)
                call_counter[reg.REG_SYSCALL]--;

            if(reg.REG_SYSCALL==SYS_fork||reg.REG_SYSCALL==SYS_clone||reg.REG_SYSCALL==SYS_vfork)//
            {
                if(sub_level>3&&sub==1)
                {
                    printf("sub are not allowed to fork!\n");
                    ptrace(PTRACE_KILL, pidApp, NULL, NULL);
                }
                else
                {
                    //printf("syscall:%ld\t",regs.REG_SYSCALL);
                    ptrace(PTRACE_SINGLESTEP, pidApp,NULL, NULL);

                    ptrace(PTRACE_GETREGS, pidApp,
                           NULL, &reg);
                    //printf("pid=%lu\n",regs.eax);
                    pid_t subpid=reg.REG_RET;
                    if(subpid>0&&subpid!=subwatcher)
                    {
                        //ptrace(PTRACE_ATTACH, subpid,               NULL, NULL);
                        //wait(NULL);

                        subwatcher=fork();
                        if(subwatcher==0)
                        {
                            //total_sub++;
                            sub_level++;
                            pidApp=subpid;
                            int success=ptrace(PTRACE_ATTACH, pidApp,
                                               NULL, NULL);
                            if(success==0)
                            {
                                wait(NULL);
                                printf("attatched sub %d->%d\n",getpid(),pidApp);

                                // ptrace(PTRACE_SYSCALL, traced_process,NULL, NULL);
                            }
                            else
                            {
                                //printf("not attatched sub %d\n",traced_process);

                                exit (0);
                            }
                        }
                    }
                }
                reg.REG_SYSCALL=0;
            }
        }
        sub = 1 - sub;

        ptrace(PTRACE_SYSCALL, pidApp, NULL, NULL);
    }
    usedtime += (ruse.ru_utime.tv_sec * 1000 + ruse.ru_utime.tv_usec / 1000);
    usedtime += (ruse.ru_stime.tv_sec * 1000 + ruse.ru_stime.tv_usec / 1000);
    if(sub_level) exit(0);
    //clean_session(pidApp);
}

int main(int argc, char** argv)
{
    int lang = 1,time_lmt=1,usedtime=0,mem_lmt=4,ACflg=OJ_AC,topmemory=0,p_id=0,PEflg=0;
    printf("compile:%d\n",compile(lang));
    pid_t pid = fork();
    if(pid == 0)
    {
        run_solution(lang, ".", time_lmt, usedtime,mem_lmt);
        exit(0);
    }
    else
    {
        watch_solution(pid, "input.txt", ACflg,0,
                       "data.out", "output.txt", 0, lang,
                       topmemory, mem_lmt, usedtime,time_lmt,p_id,
                       PEflg, ".");
        printf("time:%d\n",usedtime);
        printf("memory:%d\n",topmemory);
        printf("flag:%d\n",ACflg);
    }
    return 0;
}
