#ifndef WORK_SUBMIT_ANSWER_H
#define WORK_SUBMIT_ANSWER_H

#include "Config.hpp"
#include "Client_Base.hpp"

void work_submit_answer()
{
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
	
	for(int index = 1; index <= test_count; index ++)
	{
		if(DEBUG)
		{
			printf("[%d] running %d\n", status_id, index);
		}
	
		//download input file
		execute_cmd("wget -q -O \"input.txt\" %s%s/%d/%d", host_path.c_str(), judger_get_problem_input_path.c_str(), problem_id, index);
		
		//download answer file
		execute_cmd("wget -q -O \"answer.txt\" %s%s/%d/%d", host_path.c_str(), judger_get_problem_output_path.c_str(), problem_id, index);
		
		//download output file
		execute_cmd("wget -q -O \"output.txt\" %s%s/%d/%d", host_path.c_str(), judger_get_status_submit_zip_path.c_str(), status_id, index);
		
		int total_score = 100 / test_count;
		if(100 % test_count > test_count - index)
			total_score ++;
		
		int flag = compare_spj(index, total_score, "input.txt", "output.txt", "answer.txt", "null", 0);
		
		if(0 < flag && flag <= total_score)
		{
			status["score"] = status["score"] + flag;
		}
		
		if(DEBUG)
		{
			printf("[%d] score %lld\n", status_id, status["score"]);
		}
	}
	status["finish"] = 1;
	update_status();
}

#endif
