#include "Running.h"

Running::Running()
{
    //ctor
}

Running::~Running()
{
    //dtor
}

void Running::test()
{
    for(int i=1;i<=10;i++)
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
    }
}
