#include "Judge_Client.h"

Judge_Client::Judge_Client()
{
        //ctor
}

Judge_Client::~Judge_Client()
{
        //dtor
}

void Judge_Client::test()
{
        puts("test");
        compile(1);
        pid_t pid;
        pid = fork();
        int  lang=1,time_limit=1000,memory_limit=1024*128;
        if(pid == 0)
        {
                run_solution(lang,time_limit,memory_limit);
        }else{
                int top_memory=0,top_time=0, ACFlag=OJ_AC;
                watch_solution(pid,"input.txt","output.txt","user.txt",lang,memory_limit,time_limit,top_memory,top_time,ACFlag);
                printf("memory : %d\n",top_memory);
                printf("time: %d\n",top_time);
                printf("flag: %d\n",ACFlag);
        }
}

int Judge_Client::compile(int lang)
{
    int pid;
    const char * CP_C[] = { "gcc", "Main.c", "-o", "Main", "-O2","-Wall", "-lm","--static", "-std=c99", "-DONLINE_JUDGE", NULL};//0
    const char * CP_X[] = { "g++", "Main.cpp", "-o", "Main","-O2", "-Wall","-lm", "--static", "-DONLINE_JUDGE", NULL};//1
    const char * CP_P[] = { "fpc", "Main.pas", "-O2","-Co", "-Ct","-Ci", NULL };//2

    pid = fork();
    if (pid == 0)//child process
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
        printf("compile end!\n");
        exit(0);
    }
    else
    {
        int status=0;
        waitpid(pid, &status, 0);
        printf("status=%d\n", status);
        return status;
    }
}

void Judge_Client::run_solution(int & lang,int & time_limit,int & memory_limit)
{
        nice(19);
        // open the files
        freopen("input.txt", "r", stdin);
        freopen("user.txt", "w", stdout);
        freopen("error.out", "a+", stderr);
        // trace me
        ptrace(PTRACE_TRACEME, 0, NULL, NULL);
        // run me

        while(setgid(1536)!=0) sleep(1);
        while(setuid(1536)!=0) sleep(1);
        while(setresuid(1536, 1536, 1536)!=0) sleep(1);

        // set the limit
        struct rlimit LIM; // time limit, file limit& memory limit
        // time limit
        LIM.rlim_cur = time_limit/1000 + 1;
        LIM.rlim_max = LIM.rlim_cur;
        setrlimit(RLIMIT_CPU, &LIM);
        alarm(0);
        alarm(max(time_limit/1000*10,1));

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
        LIM.rlim_cur = (memory_limit<<10)/2*3;
        LIM.rlim_max = (memory_limit<<10)*2;
        setrlimit(RLIMIT_AS, &LIM);

        execl("./Main", "./Main", (char *)NULL);
        exit(0);
}

int Judge_Client::get_proc_status(int pid, const char * mark)
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
        if (pf)fclose(pf);
        return ret;
}

long Judge_Client::get_file_size(const char * filename)
{
        struct stat f_stat;

        if (stat(filename, &f_stat) == -1)
        {
                return 0;
        }
        return (long) f_stat.st_size;
}

void Judge_Client::print_runtimeerror(char * err)
{
        FILE *ferr=fopen("error.out","a+");
        fprintf(ferr,"Runtime Error:%s\n",err);
        fclose(ferr);
}

void Judge_Client::watch_solution(pid_t pidApp, char * std_input_file,char * std_output_file, char * user_output_file,
                        int lang,int memory_limit,int time_limit,
                        int & top_memory,int & top_time, int & ACFlag)
{
        // parent
        int temp_memory;
        int sub_level=0;
        printf("pid=%d judging %s\n", pidApp, std_input_file);

        int status, sig, exitcode;
        struct user_regs_struct reg;
        struct rusage ruse;
        int sub = 0;
        pid_t subwatcher=0;
        while (1)
        {
                puts("while running");

                // check the usage
                wait4(-1, &status, 0, &ruse);

                printf("after waiting\n");

                temp_memory = get_proc_status(pidApp, "VmPeak:") ;

                if (temp_memory > top_memory)
                        top_memory = temp_memory;

                if (top_memory > memory_limit)
                {
                        printf("out of memory %d\n", top_memory);
                        if (ACFlag == OJ_AC)
                                ACFlag = OJ_ML;
                        ptrace(PTRACE_KILL, pidApp, NULL, NULL);
                        break;
                }

                if (WIFEXITED(status))
                        break;
                if (get_file_size("error.out"))
                {
                        ACFlag = OJ_RE;
                        ptrace(PTRACE_KILL, pidApp, NULL, NULL);
                        break;
                }

                if (get_file_size(user_output_file) > get_file_size(std_output_file) * 2+1024)
                {
                        ACFlag = OJ_OL;
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
                        printf("status>>8=%d\n", exitcode);

                        if (ACFlag == OJ_AC)
                        {
                                switch (exitcode)
                                {
                                case SIGCHLD:case SIGALRM:
                                        alarm(0);
                                case SIGKILL:case SIGXCPU:
                                        ACFlag = OJ_TL;
                                        break;
                                case SIGXFSZ:
                                        ACFlag = OJ_OL;
                                        break;
                                default:
                                        ACFlag = OJ_RE;
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

                        printf("WTERMSIG=%d\n", sig);
                        psignal(sig, NULL);

                        if (ACFlag == OJ_AC)
                        {
                                switch (sig)
                                {
                                        case SIGCHLD:case SIGALRM:
                                                alarm(0);
                                        case SIGKILL:case SIGXCPU:
                                                ACFlag = OJ_TL;
                                                break;
                                        case SIGXFSZ:
                                                ACFlag = OJ_OL;
                                                break;

                                        default:
                                                ACFlag = OJ_RE;
                                }
                                print_runtimeerror(strsignal(sig));
                        }
                        break;
                }
        }
        top_time += (ruse.ru_utime.tv_sec * 1000 + ruse.ru_utime.tv_usec / 1000);
        top_time += (ruse.ru_stime.tv_sec * 1000 + ruse.ru_stime.tv_usec / 1000);
        if(sub_level) exit(0);
}
