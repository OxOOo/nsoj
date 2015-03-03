#include "Config.hpp"

bool STOP = false;

void call_for_exit(int s)
{
   STOP = true;
   printf("Stopping Judge Main...\n");
}

int daemon_init(void)
{
	pid_t pid;
 	if((pid = fork()) < 0) return -1;
 	else if(pid != 0) exit(0); /* parent exit */
 	/* child continues */
 	setsid(); /* become session leader */
 	chdir(oj_home.c_str()); /* change working directory */
 	umask(0); /* clear file mode creation mask */
 	close(0); /* close stdin */
 	close(1); /* close stdout */
 	close(2); /* close stderr */
 	
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
	if (fd < 0){
		syslog(LOG_ERR|LOG_DAEMON, "can't open %s: %s", LOCKFILE, strerror(errno));
		exit(1);
	}
	if (lockfile(fd) < 0){
		if (errno == EACCES || errno == EAGAIN){
			close(fd);
			return 1;
		}
		syslog(LOG_ERR|LOG_DAEMON, "can't lock %s: %s", LOCKFILE, strerror(errno));
		exit(1);
	}
	ftruncate(fd, 0);
	sprintf(buf,"%d", getpid());
	write(fd,buf,strlen(buf)+1);
	return 0;
}

void run_client(int client_index, int status_id, int problem_id, int language_id)
{
	char client_index_buf[BUFFER_SIZE];
	char status_id_buf[BUFFER_SIZE];
	char problem_id_buf[BUFFER_SIZE];
	char language_id_buf[BUFFER_SIZE];
	
	sprintf(client_index_buf, "%d", client_index);
	sprintf(status_id_buf, "%d", status_id);
	sprintf(problem_id_buf, "%d", problem_id);
	sprintf(language_id_buf, "%d", language_id);
	
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
	
	execl("./Judge_Client", "./Judge_Client", client_index_buf, status_id_buf, problem_id_buf, language_id_buf, (char *)NULL);
}

int work()
{
	static int already_done = 0;
	static pid_t IDs[100];
	static int working_cnt=0;
	
	while(working_cnt >= max_running){
		pid_t tmp_pid = waitpid(-1,NULL,0);     // wait children exit
		for (int i = 0;i < max_running;i ++)     // get the client id
			if (IDs[i] == tmp_pid)
			{
				working_cnt--;
				IDs[i] = 0; // set the client id
			}
	}
	
	int status_id = 0;
	int problem_id = 0;
	int language_id = 0;
	
	FILE* file = read_cmd_output("wget -q -O - %s%s", host_path.c_str(), judger_get_waiting_status_path.c_str());
	
	char yes = 'N';
	fscanf(file, "%c", &yes);
	if(DEBUG){
		printf("work result : %c\n", yes);
	}
	if(yes == 'N'){
		pclose(file);
		return 0;
	}
	
	fscanf(file, "%d", &status_id);
	fscanf(file, "%d", &problem_id);
	fscanf(file, "%d", &language_id);
	
	if(DEBUG){
		printf("running solution id: %d problem: %d language: %d\n", status_id, problem_id, language_id);
	}
	
	int idle_index = 0;
	while(IDs[idle_index] != 0)
		idle_index ++;
	
	IDs[idle_index] = fork();    // start to fork
	if (IDs[idle_index] == 0){ // child
		if(DEBUG) {
			printf("<<==status id=%d===client index=%d===client pid=%d==>>\n", status_id, idle_index, getpid());
		}
		run_client(idle_index, status_id, problem_id, language_id);
		exit(0);
	}else{
		working_cnt ++;
	}
	
	already_done ++;
	if(DEBUG) {
		printf("<<%d done! === working cnt: %d>>\n", already_done, working_cnt);
	}
	
	return status_id;
}

int main(int argc, char* argv[])
{
	//chdir(oj_home.c_str());// change the dir
	if (!DEBUG && daemon_init() != 0) return 1;
	if (already_running()){
		syslog(LOG_ERR|LOG_DAEMON, "This daemon program is already running!\n");
		return 1;
	}
	
	signal(SIGQUIT,call_for_exit);
	signal(SIGKILL,call_for_exit);
	signal(SIGTERM,call_for_exit);
	
	while (!STOP){			// start to run
		
		if(work())continue;
		
		sleep(sleep_time);
	}
	
	return 0;
}
