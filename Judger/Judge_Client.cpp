#include "Config.hpp"
#include "Client_Base.hpp"
#include "Work_Normal.hpp"
#include "Work_Normal_Spj.hpp"
#include "Work_Interaction.hpp"
#include "Work_Submit_Answer.hpp"

char buf[BUFFER_SIZE];
char work_dir[BUFFER_SIZE];

int main(int argc, char* argv[])
{
	if (argc < 5)
	{
		fprintf(stderr, "Usage:%s client_index status_id problem_id language_id.\n", argv[0]);
		return 1;
	}
	client_index = atoi(argv[1]);
  status_id = atoi(argv[2]);
  problem_id = atoi(argv[3]);
  language_id = atoi(argv[4]);
  
  sprintf(work_dir, "%s/client%d", oj_home.c_str(), client_index);
  sprintf(buf, "rm -rf %s", work_dir);
  system(buf);
  sprintf(buf, "mkdir %s", work_dir);
  system(buf);
  chdir(work_dir);
  
  FILE* file = read_cmd_output("wget -q -O - %s%s/%d", host_path.c_str(), judger_get_problem_info_path.c_str(), problem_id);
  char yes = 'N';
  fscanf(file, "%c", &yes);
  if(DEBUG)
  {
  	printf("[%d] client problem info : %c\n", status_id, yes);
  }
  if(yes == 'N')
  {
  	pclose(file);
  	status["flash"] = 1;
  	update_status();
  	return 0;
  }
  fscanf(file, "%d", &problem_type_id);
  fscanf(file, "%lld", &time_limit);
  fscanf(file, "%lld", &memory_limit);
  fscanf(file, "%d", &test_count);
  pclose(file);
  
  switch(problem_type_id)
  {
  	case 1:work_normal();break;
  	case 2:work_normal_spj();break;
  	case 3:work_interaction();break;
  	case 4:work_submit_answer();break;
  }
  
	return 0;
}
