#ifndef WORK_NORMAL_SPJ_H
#define WORK_NORMAL_SPJ_H

#include "Config.hpp"
#include "Client_Base.hpp"

void work_normal_spj()
{
	result.push(Result::Sub("Compiling", 0));
	update_result();

	//download scoure code
	execute_cmd("wget -q -O \"Main.%s\" %s%s/%d", language_ext[language_id], host_path.c_str(), judger_get_status_submit_path.c_str(), status_id);
	
	if(compile(language_id) != true)
	{
		if(DEBUG)
		{
			printf("[%d] compile error\n", status_id);
		}
		status["finish"] = 1;
		update_status();
		update_ce();
		return;
	}else{
		
	}
	
	//download spj code
	execute_cmd("wget -q -O \"Spj.cpp\" %s%s/%d", host_path.c_str(), judger_get_problem_spj_path.c_str(), problem_id);
	if(compile_spj() != true)
	{
		if(DEBUG)
		{
			printf("[%d] compile spj error\n", status_id);
		}
		status["finish"] = 1;
		update_status();
		return;
	}else{
		
	}
	
	status["time"] = 0;
	status["memory"] = 0;
	status["score"] = 0;
	status["finish"] = 0;
	
	result.pop();
	for(int index = 1; index <= test_count; index ++)
	{
		if(DEBUG)
		{
			printf("[%d] running %d\n", status_id, index);
		}
		result.push(Result::Sub("Running", 0));
		update_result();
		
		int total_score = 100 / test_count;
		if(100 % test_count > test_count - index)
			total_score ++;
	
		//download input file
		execute_cmd("wget -q -O \"input.txt\" %s%s/%d/%d", host_path.c_str(), judger_get_problem_input_path.c_str(), problem_id, index);
		
		//download input file
		execute_cmd("wget -q -O \"answer.txt\" %s%s/%d/%d", host_path.c_str(), judger_get_problem_output_path.c_str(), problem_id, index);
		
		Runner::StartInfo start_info;
    Runner::ProcessInfo process_info;
    
    const char* exec_cmd[] = {"./Main",NULL};

    start_info.command = exec_cmd;
    start_info.is_path_file = false;
    start_info.time_limit = time_limit;
    start_info.process_limit = 1;
    start_info.memory_limit = memory_limit;
    start_info.uid = judge_client_uid;
    
    const char *input_file="input.txt";
    const char *output_file="output.txt";
    memcpy(start_info.stdin_file,input_file,strlen(input_file));
    memcpy(start_info.stdout_file,output_file,strlen(output_file));

    Runner::run_command(start_info,process_info);
    result.pop();

		if(process_info.exit_code == 0 && process_info.flag == Runner::ProcessInfo::Success)
		{
			int flag = compare_spj(index, total_score, "input.txt", "output.txt", "answer.txt", (string("Main") + language_ext[language_id]).c_str(), language_id);
			if(0 < flag && flag <= total_score)
			{
				status["time"] = max(status["time"], process_info.time);
				status["memory"] = max(status["memory"], process_info.memory);
				status["score"] = status["score"] + flag;
				if(flag == total_score)
				{
					result.push(Result::Sub("Accepted", total_score));
				}else{
					result.push(Result::Sub("Part Right", flag));
				}
			}else{
				result.push(flag2sub(flag));
			}
		}
		
		if(DEBUG)
		{
			printf("[%d] score %lld\n", status_id, status["score"]);
		}
		update_status();
		update_result();
	}
	status["finish"] = 1;
	update_status();
}

#endif
