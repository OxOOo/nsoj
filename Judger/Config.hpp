#ifndef CONFIG_H
#define CONFIG_H

#include <iostream>
#include <cstring>
#include <cstdio>
using namespace std;

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
#include <sys/ptrace.h>
#include <signal.h>

#define LOCKFILE (oj_home + "/judged.pid").c_str()
#define LOCKMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH)

#define RESULT_AC		101
#define RESULT_WA		102
#define RESULT_TLE	103
#define RESULT_MLE	104
#define RESULT_OLE	105
#define RESULT_RE		106
#define RESULT_CE		107
#define RESULT_PR		108
#define RESULT_RI		109
#define RESULT_CI		110
#define RESULT_SE		111

const string host_path = "http://localhost:3000/" ;
const string judger_get_waiting_status_path = "judger/get_waiting_status" ;
const string judger_get_status_submit_path = "judger/get_status_submit" ;
const string judger_get_status_submit_zip_path = "judger/get_status_submit_zip" ;
const string judger_get_problem_info_path = "judger/get_problem_info" ;
const string judger_get_problem_spj_path = "judger/get_problem_spj" ;
const string judger_get_problem_front_path = "judger/get_problem_front" ;
const string judger_get_problem_back_path = "judger/get_problem_back" ;
const string judger_get_problem_input_path = "judger/get_problem_input" ;
const string judger_get_problem_output_path = "judger/get_problem_output" ;
const string judger_update_status_info_path = "judger/update_status_info" ;
const string judger_update_status_ce_path = "judger/update_status_ce" ;
const string judger_update_status_result_path = "judger/update_status_result" ;

const int STD_MB = 1048576;
const int BUFFER_SIZE = 1024;
const bool DEBUG = false;

const string oj_home = "/home/judge" ;
const int sleep_time = 10 ;
const int max_running = 4 ;
const int judge_client_uid = 1536;

const char* language_ext[5] = { "", "txt", "cpp", "c", "pas" };
//const char language_complie[4][100] = { "", "g++ main.cpp -o main", "gcc main.c -o main", "fpc main.pas" };

FILE* read_cmd_output(const char * fmt, ...)
{
    char cmd[BUFFER_SIZE];

    va_list ap;
    va_start(ap, fmt);
    vsprintf(cmd, fmt, ap);
    va_end(ap);

    return popen(cmd,"r");
}

int execute_cmd(const char * fmt, ...)
{
    char cmd[BUFFER_SIZE];

    va_list ap;
    va_start(ap, fmt);
    vsprintf(cmd, fmt, ap);
    va_end(ap);
    
    pid_t pid = fork();
    if(pid == 0)
    {
    	fclose(stdin);
    	fclose(stdout);
    	fclose(stderr);
    	exit(system(cmd));
    }else{
    	int status = 0;
    	waitpid(pid,&status,0);
    	return status;
    }
}

string num2str(int num)
{
	char buf[BUFFER_SIZE];
	sprintf(buf, "%d", num);
	return buf;
}

#endif
