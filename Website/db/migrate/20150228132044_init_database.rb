class InitDatabase < ActiveRecord::Migration
  def up
  	 normal = ProblemType.create!(:title=>"传统题目")
  	 normal_spj = ProblemType.create!(:title=>"传统SPJ题目")
  	 interaction = ProblemType.create!(:title=>"交互式题目")
  	 submit_answer = ProblemType.create!(:title=>"提交答案式题目")
  	 
  	 none = Language.create!(:title=>"None")
  	 c_plus_plus = Language.create!(:title=>"C++")
  	 c = Language.create!(:title=>"C")
  	 pascal = Language.create!(:title=>"Pascal")
  	 
  	 ProblemTypeLanguageShip.create!(:problem_type=>normal, :language=>c_plus_plus)
  	 ProblemTypeLanguageShip.create!(:problem_type=>normal, :language=>c)
  	 ProblemTypeLanguageShip.create!(:problem_type=>normal, :language=>pascal)
  	 ProblemTypeLanguageShip.create!(:problem_type=>normal_spj, :language=>c_plus_plus)
  	 ProblemTypeLanguageShip.create!(:problem_type=>normal_spj, :language=>c)
  	 ProblemTypeLanguageShip.create!(:problem_type=>normal_spj, :language=>pascal)
  	 ProblemTypeLanguageShip.create!(:problem_type=>interaction, :language=>c_plus_plus)
  	 ProblemTypeLanguageShip.create!(:problem_type=>submit_answer, :language=>none)
  	 
  	 User.create!(:username=>"admin", :password=>"admin", :password_confirmation=>"admin", :admin=>true)
  	 
  	 Problem.create!(:problem_type=>normal, :title=>"A + B 问题", :time_limit=>1000, :memory_limit=>128*1024*1024,
  	 			:submit_limit=>100*1024, :show=>true, :judge=>true)
  	 Problem.create!(:problem_type=>normal_spj, :title=>"A + B 问题", :time_limit=>1000, :memory_limit=>128*1024*1024,
  	 			:submit_limit=>100*1024, :show=>true, :judge=>true)
  	 Problem.create!(:problem_type=>interaction, :title=>"A + B 问题", :time_limit=>1000, :memory_limit=>128*1024*1024,
  	 			:submit_limit=>100*1024, :show=>true, :judge=>true)
  	 Problem.create!(:problem_type=>submit_answer, :title=>"A + B 问题", :time_limit=>1000, :memory_limit=>128*1024*1024,
  	 			:submit_limit=>100*1024, :show=>true, :judge=>true)
  end
  
  def down
  	ProblemType.destroy_all
  	Language.destroy_all
  	ProblemTypeLanguageShip.destroy_all
  	User.destroy_all
  	Problem.destroy_all
  end
end
