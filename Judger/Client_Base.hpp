#ifndef CLIENT_BASE_H
#define CLIENT_BASE_H

#include "Config.hpp"
#include <map>
#include <vector>

typedef long long LL;
namespace Runner
{
    struct StartInfo
    {
        char stdin_file[BUFFER_SIZE];
        char stdout_file[BUFFER_SIZE];
        char stderr_file[BUFFER_SIZE];
        LL time_limit;
        LL file_limit;
        LL process_limit;
        LL stack_memory_limit;
        LL memory_limit;
        int uid;
        bool is_path_file;
        char work_dir[BUFFER_SIZE];
        const char** command;
        void init()
        {
            memset(stdin_file,0,sizeof(stdin_file));
            memset(stdout_file,0,sizeof(stdout_file));
            memset(stderr_file,0,sizeof(stderr_file));
            memset(work_dir,0,strlen(work_dir));
            time_limit = 1000 * 60;
            file_limit = 1024 * 1024 * 1024;
            process_limit = 10;
            stack_memory_limit = 0;
            memory_limit = 1024 * 1024 * 1024;
            uid = 0;
            is_path_file = false;
        }
        StartInfo()
        {
            init();
        }
    };
    struct ProcessInfo
    {
        enum Status{Normal,Success,Failed,TimeLimitError,MemoryLimitError,OutputLimitError,RuntimeError};

        LL time;
        LL memory;
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

    LL get_file_size(const char * filename)
    {
        struct stat f_stat;
        if (stat(filename, &f_stat) == -1)
            return 0;
        return (LL) f_stat.st_size;
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
    		for(int times = 10; times --;)
    		{
		      process_info.init();
		      pid_t pid = fork();
		      if(pid == 0)//child
		      {
		              if(*start_info.work_dir)
		                  chdir(start_info.work_dir);
		              if(*start_info.stdin_file)
		                  freopen(start_info.stdin_file, "r", stdin);
		              else fclose(stdin);
		              if(*start_info.stdout_file)
		                  freopen(start_info.stdout_file, "w", stdout);
		              else fclose(stdout);
		              if(*start_info.stderr_file)
		                  freopen(start_info.stderr_file, "w", stderr);
		              else fclose(stderr);

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
		                  alarm(start_info.time_limit/1000*2 + 1);
		              }

		              // file limit
		              if(start_info.file_limit)
		              {
		                  LIM.rlim_max = start_info.file_limit + STD_MB;
		                  LIM.rlim_cur = start_info.file_limit;
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
		                  LIM.rlim_cur = start_info.stack_memory_limit;
		                  LIM.rlim_max = start_info.stack_memory_limit;
		                  setrlimit(RLIMIT_STACK, &LIM);
		              }

		              // set the memory
		              if(start_info.memory_limit)
		              {
		                  LIM.rlim_cur = start_info.memory_limit/2*3;
		                  LIM.rlim_max = start_info.memory_limit*2;
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
		                  execvp(start_info.command[0], (char * const *) start_info.command);
		              else execv(start_info.command[0], (char * const *) start_info.command);
		              printf("error\n");
		              exit(1);
		      }else{//parent
		              process_info.flag = ProcessInfo::Success;

		              LL temp_memory;
		              int status, sig;
		              struct rusage ruse;
		              while (1)
		              {
		                  // check the usage
		                  wait4(pid, &status, 0, &ruse);

		                  temp_memory = get_proc_status(pid, "VmPeak:") << 10;
		                  if (temp_memory > process_info.memory)
		                      process_info.memory = temp_memory;

		                  if (process_info.memory > start_info.memory_limit && start_info.memory_limit != 0)
		                  {
		                      if (DEBUG)
		                          printf("out of memory %lld\n", process_info.memory);
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
		          
		          if(process_info.flag == ProcessInfo::Success)
		          {
		          	if(start_info.time_limit != 0 && process_info.time > start_info.time_limit)
		          		process_info.flag = ProcessInfo::TimeLimitError;
		          	if(start_info.memory_limit != 0 && process_info.memory > start_info.memory_limit)
		          		process_info.flag = ProcessInfo::MemoryLimitError;
		          	if(process_info.exit_code == 1 && get_file_size(start_info.stdout_file) == 6)
		          		process_info.flag = ProcessInfo::Failed;
		          }
		      }
				  
				  if(process_info.flag != Runner::ProcessInfo::Failed)break;
				  usleep(500);
			}
    }
}

struct Result
{
	struct Sub
	{
		string title;
		int score;
		Sub(string title, int score):title(title),score(score){}
		void save(FILE *file)
		{
			fprintf(file, "[\"%s\",%d]", title.c_str(), score);
		}
	};
	vector<Sub> stack;
	Result(){}
	void push(Sub sub)
	{
		stack.push_back(sub);
	}
	void pop()
	{
		if(stack.size() != 0)
			stack.pop_back();
	}
	void save(const char* filename)
	{
		FILE* file = fopen(filename, "w");
		fprintf(file, "[");
		for(int i = 0;i < (int)stack.size(); i++)
		{
			if(i)fprintf(file, ",");
			stack[i].save(file);
		}
		fprintf(file, "]");
		fclose(file);
	}
};

int client_index;
int status_id;
int problem_id;
int language_id;

int problem_type_id;
LL time_limit;
LL memory_limit;
int test_count;

map<string, LL> status;
Result result;

Result::Sub flag2sub(int flag)
{
	switch(flag)
	{
		case RESULT_WA:return Result::Sub("Wrong Answer", 0);break;
		case RESULT_TLE:return Result::Sub("Time Limit Exceeded", 0);break;
		case RESULT_MLE:return Result::Sub("Memory Limit Exceeded", 0);break;
		case RESULT_OLE:return Result::Sub("Output Limit Exceeded", 0);break;
		case RESULT_RE:return Result::Sub("Runtime Error", 0);break;
		case RESULT_CE:return Result::Sub("Compile Error", 0);break;
		case RESULT_SE:return Result::Sub("System Error", 0);break;
		default:return Result::Sub("Unknow", 0);break;
	}
}

void update_status()
{
	string data;
	for(map<string, LL>::iterator iter = status.begin(); iter != status.end(); iter ++)
	{
		if(!data.empty())
			data += "&";
		data += iter->first + "=" + num2str(iter->second);
	}
	execute_cmd("wget -q -O - --post-data=\"%s\" %s%s/%d", data.c_str(), host_path.c_str(), judger_update_status_info_path.c_str(), status_id);
}

void update_ce()
{
	execute_cmd("wget -q -O - --post-file=\"ce.txt\" %s%s/%d", host_path.c_str(), judger_update_status_ce_path.c_str(), status_id);
}

void update_result()
{
	result.save("result");
	execute_cmd("wget -q -O - --post-file=\"result\" %s%s/%d", host_path.c_str(), judger_update_status_result_path.c_str(), status_id);
}

bool compile(int language_id)
{
	const char * CP_C[] = { "gcc", "Main.c", "-o", "Main", "-lm", "-DONLINE_JUDGE", NULL};
	const char * CP_X[] = { "g++", "Main.cpp", "-o", "Main", "-lm", "-DONLINE_JUDGE", NULL};
	const char * CP_P[] = { "fpc", "Main.pas", NULL };
	Runner::StartInfo start_info;
  Runner::ProcessInfo process_info;
  
  switch(language_id)
  {
  	case 2:start_info.command = CP_X;break;
  	case 3:start_info.command = CP_C;break;
  	case 4:start_info.command = CP_P;break;
  }
  
  const char* error_file = "ce.txt";
  
  if(language_id == 4)
  	memcpy(start_info.stdout_file,error_file,strlen(error_file));
  else memcpy(start_info.stderr_file,error_file,strlen(error_file));
  start_info.is_path_file = true;

  Runner::run_command(start_info,process_info);
  return process_info.exit_code == 0 && process_info.flag == Runner::ProcessInfo::Success;
}

bool compile_spj()
{
	Runner::StartInfo start_info;
  Runner::ProcessInfo process_info;
  
  const char * cmd[] = { "g++", "Spj.cpp", "-o", "Spj", "-lm", NULL};
  start_info.command = cmd;
  start_info.is_path_file = true;

  Runner::run_command(start_info,process_info);
  return process_info.exit_code == 0 && process_info.flag == Runner::ProcessInfo::Success;
}

bool compile_interaction()
{
	Runner::StartInfo start_info;
  Runner::ProcessInfo process_info;
  
  const char * cmd[] = { "g++", "Main.cpp", "-o", "Main", "-lm", NULL};
  start_info.command = cmd;
  const char* error_file = "ce.txt";
  memcpy(start_info.stderr_file,error_file,strlen(error_file));
  start_info.is_path_file = true;

  Runner::run_command(start_info,process_info);
  return process_info.exit_code == 0 && process_info.flag == Runner::ProcessInfo::Success;
}

int readline(FILE *file, char* buf)
{
	int len = 0;
	char c;
	if(fscanf(file, "%c", &c) == EOF)return -1;
	buf[len ++] = c;
	do
	{
		if(fscanf(file, "%c", &c) == EOF || c == '\n')
			break;
		buf[len ++] = c;
	}while(len < BUFFER_SIZE);
	if(len < BUFFER_SIZE)
	{
		while(len && isspace(buf[len - 1])) len --;
	}
	buf[len] = '\0';
	return len;
}
bool compare_ok(const char* std_filename, const char* out_filename)
{
	FILE *std_file = fopen(std_filename, "r");
	FILE *out_file = fopen(out_filename, "r");
	
	char std_buf[BUFFER_SIZE * 2], out_buf[BUFFER_SIZE * 2];
	int std_buf_len, out_buf_len;
	
	if(!std_file || !out_file)
	{
		if(std_file)fclose(std_file);
		if(out_file)fclose(out_file);
		return false;
	}
	
	while(true)
	{
		std_buf_len = out_buf_len = 0;
		if((std_buf_len = readline(std_file, std_buf)) < 0)break;
		if((out_buf_len = readline(out_file, out_buf)) < 0 || strcmp(std_buf, out_buf) != 0)
		{
			if(std_file)fclose(std_file);
			if(out_file)fclose(out_file);
			return false;
		}
	}
	
	if(std_file)fclose(std_file);
	if(out_file)fclose(out_file);
	
	return true;
}

int compare_spj(int test_index, int total_score, const char* input_filename, const char* output_filename,
							const char* answer_filename, const char* scoure_filename, int language_id)
{
	Runner::StartInfo start_info;
  Runner::ProcessInfo process_info;
  
  char* command[9];
  command[0] = new char[BUFFER_SIZE];sprintf(command[0], "./Spj");
  command[1] = new char[BUFFER_SIZE];sprintf(command[1], "%d", test_index);
  command[2] = new char[BUFFER_SIZE];sprintf(command[2], "%d", total_score);
  command[3] = new char[BUFFER_SIZE];sprintf(command[3], "%s", input_filename);
  command[4] = new char[BUFFER_SIZE];sprintf(command[4], "%s", output_filename);
  command[5] = new char[BUFFER_SIZE];sprintf(command[5], "%s", answer_filename);
  command[6] = new char[BUFFER_SIZE];sprintf(command[6], "%s", scoure_filename);
  command[7] = new char[BUFFER_SIZE];sprintf(command[7], "%d", language_id);
  command[8] = (char *)NULL;

  start_info.command = (const char**)command;
  start_info.is_path_file = false;
  start_info.uid = judge_client_uid;

  Runner::run_command(start_info,process_info);
  for(int i = 0;i < 8;i ++)
  	delete[] command[i];
  
  if(process_info.flag != Runner::ProcessInfo::Success)
  {
  	return RESULT_SE;
  }
  return process_info.exit_code;
}

#endif
