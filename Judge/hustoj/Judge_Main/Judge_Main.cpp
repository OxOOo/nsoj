#include <time.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <unistd.h>
#include <syslog.h>
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/resource.h>
#include <signal.h>

static int DEBUG=0;
#define BUFFER_SIZE 1024
#define LOCKFILE "/var/run/judged.pid"
#define LOCKMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH)
#define STD_MB 1048576

static char oj_home[BUFFER_SIZE];
static int max_running;
static int sleep_time;
static char http_token[BUFFER_SIZE];
static char http_get_job_url[BUFFER_SIZE];

static bool STOP=false;

void call_for_exit(int s)
{
    STOP=true;
    printf("Stopping judged...\n");
}

void write_log(const char *fmt, ...)
{
    va_list         ap;
    char            buffer[4096];

    sprintf(buffer,"%s/log/client.log",oj_home);
    FILE *fp = fopen(buffer, "a+");
    if (fp==NULL)
    {
        fprintf(stderr,"openfile error!\n");
        system("pwd");
    }
    va_start(ap, fmt);
    vsprintf(buffer, fmt, ap);
    fprintf(fp,"%s\n",buffer);
    if (DEBUG) printf("%s\n",buffer);
    va_end(ap);
    fclose(fp);
}

int after_equal(char * c)
{
    int i=0;
    for(; c[i]!='\0'&&c[i]!='='; i++);
    return ++i;
}
void trim(char * c)
{
    char buf[BUFFER_SIZE];
    char * start,*end;
    strcpy(buf,c);
    start=buf;
    while(isspace(*start)) start++;
    end=start;
    while(!isspace(*end)) end++;
    *end='\0';
    strcpy(c,start);
}
bool read_buf(char * buf,const char * key,char * value)
{
    if (strncmp(buf,key, strlen(key)) == 0)
    {
        strcpy(value, buf + after_equal(buf));
        trim(value);
        if (DEBUG) printf("%s\n",value);
        return 1;
    }
    return 0;
}
void read_int(char * buf,const char * key,int * value)
{
    char buf2[BUFFER_SIZE];
    if (read_buf(buf,key,buf2))
        sscanf(buf2, "%d", value);
}

int run_client(int run_id,int client_id)
{
    pid_t pid=fork();                                   // start to fork
    if(pid != 0)return pid;
    if(DEBUG)write_log("<<=sid=%d===clientid=%d==>>\n",run_id);

    struct rlimit LIM;
    LIM.rlim_max=800;
    LIM.rlim_cur=800;
    setrlimit(RLIMIT_CPU,&LIM);

    LIM.rlim_max=80*STD_MB;
    LIM.rlim_cur=80*STD_MB;
    setrlimit(RLIMIT_FSIZE,&LIM);

    LIM.rlim_max=STD_MB<<11;
    LIM.rlim_cur=STD_MB<<11;
    setrlimit(RLIMIT_AS,&LIM);

    LIM.rlim_cur=LIM.rlim_max=200;
    setrlimit(RLIMIT_NPROC, &LIM);

    char run_id_str[BUFFER_SIZE],client_id_str[BUFFER_SIZE];
    sprintf(run_id_str,"%d",run_id);
    sprintf(client_id_str,"%d",client_id);

    if (!DEBUG)
        execl("/usr/bin/Judge_Client","/usr/bin/Judge_Client",run_id_str,client_id_str,oj_home,(char *)NULL);
    else
        execl("/usr/bin/Judge_Client","/usr/bin/Judge_Client",run_id_str,client_id_str,oj_home,"debug",(char *)NULL);
    exit(0);
}

FILE * read_cmd_output(const char * fmt, ...)
{
    char cmd[BUFFER_SIZE];

    FILE *  ret =NULL;
    va_list ap;

    va_start(ap, fmt);
    vsprintf(cmd, fmt, ap);
    va_end(ap);
    //if(DEBUG) printf("%s\n",cmd);
    ret = popen(cmd,"r");

    return ret;
}
int read_int_http(FILE * f)
{
    char buf[BUFFER_SIZE];
    fgets(buf,BUFFER_SIZE-1,f);
    return atoi(buf);
}
int get_job()
{
    const char * cmd="wget %s?token=%s";
    FILE * fjob=read_cmd_output(cmd,http_get_job_url,http_token);
    int id = read_int_http(fjob);
    pclose(fjob);
    return id;
}

int work()
{
    static int working_cnt=0;
    static int ID[100];

    int run_id=0;
    int client_id=0;

    run_id=get_job();
    if(!run_id)return 0;
    /* exec the submit */

    if(DEBUG)write_log("Judging solution %d",run_id);
    if (working_cnt>=max_running)               // if no more client can running
    {
        pid_t pid = waitpid(-1,NULL,0);     // wait 4 one child exit
        working_cnt--;
        while(client_id<max_running && ID[client_id]!=pid)client_id++;
        ID[client_id]=0;
    }else{
        while(client_id<max_running && ID[client_id]!=0)client_id++;
    }
    if(working_cnt<max_running)
    {
        working_cnt++;
        ID[client_id]=run_client(run_id,client_id);
        return run_id;
    }
    ID[client_id]=0;
    return 0;
}

int lockfile(int fd)
{
    struct flock fl;
    fl.l_type = F_WRLCK;
    fl.l_start = 0;
    fl.l_whence = SEEK_SET;
    fl.l_len = 0;
    return (fcntl(fd,F_SETLK,&fl));
}

int already_running()
{
    int fd;
    char buf[16];
    fd = open(LOCKFILE, O_RDWR|O_CREAT, LOCKMODE);
    if (fd < 0)
    {
        syslog(LOG_ERR|LOG_DAEMON, "can't open %s: %s", LOCKFILE, strerror(errno));
        exit(1);
    }
    if (lockfile(fd) < 0)
    {
        if (errno == EACCES || errno == EAGAIN)
        {
            close(fd);
            return 1;
        }
        syslog(LOG_ERR|LOG_DAEMON, "can't lock %s: %s", LOCKFILE, strerror(errno));
        exit(1);
    }
    ftruncate(fd, 0);
    sprintf(buf,"%d", getpid());
    write(fd,buf,strlen(buf)+1);
    return (0);
}
int daemon_init(void)
{
    pid_t pid;

    if((pid = fork()) < 0) return(-1);

    else if(pid != 0) exit(0); /* parent exit */

    /* child continues */

    setsid(); /* become session leader */

    chdir(oj_home); /* change working directory */

    umask(0); /* clear file mode creation mask */

    close(0); /* close stdin */

    close(1); /* close stdout */

    close(2); /* close stderr */

    return(0);
}

void init_conf()
{
    FILE *fp=NULL;
	char buf[BUFFER_SIZE];
	http_token[0]=0;
	http_get_job_url[0]=0;
	max_running=4;
	sleep_time=5;
	fp = fopen("./etc/judge.conf", "r");
	if(fp!=NULL){
		while (fgets(buf, BUFFER_SIZE - 1, fp)) {
			read_buf(buf,"OJ_TOKEN",http_token);
			read_buf(buf, "OJ_GET_JOB_URL",http_get_job_url);
			read_int(buf, "OJ_RUNNING", &max_running);
			read_int(buf, "OJ_SLEEP_TIME", &sleep_time);
		}
		fclose(fp);
    }
}

int main(int argc, char** argv)
{
    DEBUG=(argc>2);
    if (argc>1)
        strcpy(oj_home,argv[1]);
    else
        strcpy(oj_home,"/home/judge");
    chdir(oj_home);// change the dir

    if (!DEBUG) daemon_init();
    init_conf();

    if (strcmp(oj_home,"/home/judge")==0&&already_running())
    {
        syslog(LOG_ERR|LOG_DAEMON, "This daemon program is already running!\n");
        return 1;
    }
    signal(SIGQUIT,call_for_exit);
    signal(SIGKILL,call_for_exit);
    signal(SIGTERM,call_for_exit);
    while (!STOP) 			// start to run
    {
        while(work());
        sleep(sleep_time);
    }
    return 0;
}
