#ifndef JUDGE_CLIENT_H
#define JUDGE_CLIENT_H

#include <unistd.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <sys/ptrace.h>
#include <sys/stat.h>
#include <sys/user.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
using namespace std;

#include "Config.h"

class Judge_Client
{
        public:
                Judge_Client();
                virtual ~Judge_Client();

                void test();
                int compile(int lang);
                void run_solution(int & lang,int & time_limit,int & memory_limit);
                int get_proc_status(int pid, const char * mark);
                long get_file_size(const char * filename);
                void print_runtimeerror(char * err);
                void watch_solution(pid_t pidApp, char * std_input_file,char * std_output_file, char * user_output_file,
                        int lang,int memory_limit,int time_limit,
                        int & top_memory,int & top_time, int & ACFlag);
        protected:
        private:
};

#endif // JUDGE_CLIENT_H
