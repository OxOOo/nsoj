class InitDatabase < ActiveRecord::Migration
  def up
		#OnlineJudge
		local = OnlineJudge.create!(:name=>"本地",:description=>"南山在线评测系统",:address=>"/",:regexp=>"[1-9]\\d*",:default=>"0")
		OnlineJudge.create!(:name=>"BZOJ",:description=>"编号格式不正确，BZOJ的编号为数字组成，例如：1039",
		        :address=>"http://www.lydsy.com/JudgeOnline/",:regexp=>"[1-9]\\d*",:default=>"1039")
		        
		#ContestType
		ContestType.create!(:name=>"OI",:description=>"比赛时不能看到提交结果，最终按总分排名")
		ContestType.create!(:name=>"ACM",:description=>"比赛时可以看到提交结果，最终按总分排名")

		#Status
		Status.create!(:name=>"等待测评",:style=>"waitting")
		Status.create!(:name=>"正在编译",:style=>"compiling")
		Status.create!(:name=>"正在评测",:style=>"running")
		Status.create!(:name=>"正确",:style=>"accepted")
		Status.create!(:name=>"错误答案",:style=>"wrong")
		Status.create!(:name=>"超出时间限制",:style=>"tle")
		Status.create!(:name=>"超出空间限制",:style=>"mle")
		Status.create!(:name=>"输出格式错误",:style=>"pe")
		Status.create!(:name=>"运行时出错",:style=>"re")
		Status.create!(:name=>"编译失败",:style=>"ce")
		Status.create!(:name=>"部分正确",:style=>"score")

		#ProblemType
		normal = ProblemType.create!(:name=>"传统型",:description=>"忽略行末空格与文末回车")
		normal_spj = ProblemType.create!(:name=>"传统SpecialJudge型",:description=>"由SpecialJudge判断得分")
		interaction = ProblemType.create!(:name=>"交互型",:description=>"补全一段代码，然后由特定的Judge判断")
		submit_answer = ProblemType.create!(:name=>"提交答案型",:description=>"提交一个包含答案的zip文件")
		vjudge = ProblemType.create!(:name=>"虚拟题目",:description=>"由本题库转交代码到其他题库测试")
		
		#Language
		c = Language.create!(:name=>"C",:cmd=>"gcc ./main.c -o ./main -m")
		c_plus_plus = Language.create!(:name=>"C++",:cmd=>"g++ ./main.cpp -o ./main -m")
		pascal = Language.create!(:name=>"Pascal",:cmd=>"gcc ./main.pas")
		none = Language.create!(:name=>"None",:cmd=>"none")

    #LanguageProblemTypeShip
    LanguageProblemTypeShip.create!(:problem_type=>normal, :language=>c_plus_plus)
    LanguageProblemTypeShip.create!(:problem_type=>normal, :language=>c)
    LanguageProblemTypeShip.create!(:problem_type=>normal, :language=>pascal)
    LanguageProblemTypeShip.create!(:problem_type=>normal_spj, :language=>c_plus_plus)
    LanguageProblemTypeShip.create!(:problem_type=>normal_spj, :language=>c)
    LanguageProblemTypeShip.create!(:problem_type=>normal_spj, :language=>pascal)
    LanguageProblemTypeShip.create!(:problem_type=>interaction, :language=>c_plus_plus)
    LanguageProblemTypeShip.create!(:problem_type=>submit_answer, :language=>none)
    LanguageProblemTypeShip.create!(:problem_type=>vjudge, :language=>c_plus_plus)
    LanguageProblemTypeShip.create!(:problem_type=>vjudge, :language=>c)
    LanguageProblemTypeShip.create!(:problem_type=>vjudge, :language=>pascal)

		#User
		root = User.create!(:username=>"root",:password=>"root",:nickname=>"管理员",
		  :create_ip=>"0.0.0.0",:password_confirmation=>"root")
		root.create_access(:is_root=>true, :is_admin=>true, :can_add_problem=>true,
		  :can_modify_problem=>true, :can_add_contest=>true,
		  :can_modify_contest=>true, :can_watch_code=>true)
		
		#Problem
    Problem.create!(:problem_type=>normal, :name=>"A + B 问题", :time_limit=>1000, :memory_limit=>128*1024*1024,
     			:answer_limit=>100*1024, :hide=>false, :submit=>true, :task=>true, :user=>root, :online_judge=>local, :origin_id=>1)
    Problem.create!(:problem_type=>normal_spj, :name=>"A + B 问题", :time_limit=>1000, :memory_limit=>128*1024*1024,
		      :answer_limit=>100*1024, :hide=>false, :submit=>true, :task=>true, :user=>root, :online_judge=>local, :origin_id=>2)
    Problem.create!(:problem_type=>interaction, :name=>"A + B 问题", :time_limit=>1000, :memory_limit=>128*1024*1024,
		      :answer_limit=>100*1024, :hide=>false, :submit=>true, :task=>true, :user=>root, :online_judge=>local, :origin_id=>3)
    Problem.create!(:problem_type=>submit_answer, :name=>"A + B 问题", :time_limit=>1000, :memory_limit=>128*1024*1024,
		      :answer_limit=>100*1024, :hide=>false, :submit=>true, :task=>true, :user=>root, :online_judge=>local, :origin_id=>4)
    
    #Config
    Config.create!(:name=>"can_login", :value=>"t", :is_boolean=>true, :is_integer=>false,
      :description=>"是否可以登录")
    Config.create!(:name=>"can_register", :value=>"t", :is_boolean=>true, :is_integer=>false,
      :description=>"是否可以注册")
    Config.create!(:name=>"can_submit", :value=>"t", :is_boolean=>true, :is_integer=>false,
      :description=>"是否可以提交")
    Config.create!(:name=>"can_blog", :value=>"t", :is_boolean=>true, :is_integer=>false,
      :description=>"是否可以发表博客")
    Config.create!(:name=>"can_message", :value=>"t", :is_boolean=>true, :is_integer=>false,
      :description=>"是否可以发送消息")
    Config.create!(:name=>"root_only", :is_boolean=>true, :is_integer=>false,
      :description=>"是否只能查看主页")
    
    Config.create!(:name=>"token", :value=>"fghjk87uibyui9iu78", :is_boolean=>false, :is_integer=>false,
      :description=>"评测器识别用的token")
    
    Config.create!(:name=>"user_per_page", :value=>"20", :is_boolean=>false, :is_integer=>true,
      :description=>"每页用户排名数量")
    Config.create!(:name=>"problem_per_page", :value=>"20", :is_boolean=>false, :is_integer=>true,
      :description=>"每页题目数量")
    Config.create!(:name=>"contest_per_page", :value=>"20", :is_boolean=>false, :is_integer=>true,
      :description=>"每页比赛数量")
    Config.create!(:name=>"status_per_page", :value=>"20", :is_boolean=>false, :is_integer=>true,
      :description=>"每页状态数量")
    Config.create!(:name=>"blog_per_page", :value=>"20", :is_boolean=>false, :is_integer=>true,
      :description=>"每页博客数量")
    Config.create!(:name=>"message_per_page", :value=>"20", :is_boolean=>false, :is_integer=>true,
      :description=>"每页显示的信息数量")
    Config.create!(:name=>"entry_per_page", :value=>"10", :is_boolean=>false, :is_integer=>true,
      :description=>"每页登录情况数量")
    Config.create!(:name=>"small_entry_number", :value=>"5", :is_boolean=>false, :is_integer=>true,
      :description=>"最近登录情况数量")
    Config.create!(:name=>"timeout_seconds", :value=>"600", :is_boolean=>false, :is_integer=>true,
      :description=>"用户登录过期时间（秒）")
    Config.create!(:name=>"keep_entry_days", :value=>"10", :is_boolean=>false, :is_integer=>true,
      :description=>"用户登录记录保存时间（天）")
    Config.create!(:name=>"page_range", :value=>"3", :is_boolean=>false, :is_integer=>true,
      :description=>"分页范围")
  end

	def down
		#OnlineJudge
		OnlineJudge.destroy_all

		#Language
		Language.destroy_all

		#Status
		Status.destroy_all

		#ProblemType
		ProblemType.destroy_all

		#ContestType
		ContestType.destroy_all

		#User
		User.destroy_all
		
		#Config
		Config.destory_all
	end
end
