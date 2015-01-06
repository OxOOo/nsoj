#include "Running.h"
#include <cstring>

/*

*/
int main(int argc,char *argv[])
{
        Running run;
        run.DEBUG=1;
        memcpy(run.oj_home,"/home/judge",strlen("/home/judge"));
        run.oi_mode=0;
        run.test();
        return 0;
}
