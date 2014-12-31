class InitDatabase < ActiveRecord::Migration
  	def up
		#OnlineJudge
		OnlineJudge.create!(:name=>"本地题库",:description=>"南山在线评测系统",:address=>"/",:regexp=>"/[1-9]\d*/")

		#Language
		Language.create!(:name=>"C",:origin_cmd=>"gcc ./main.c -o ./main(main.exe) -m",:extra_cmd=>" ")
		Language.create!(:name=>"C++",:origin_cmd=>"g++ ./main.cpp -o ./main(main.exe) -m",:extra_cmd=>" ")
		Language.create!(:name=>"Pascal",:origin_cmd=>"gcc ./main.pas",:extra_cmd=>" ")

		#Status
		Status.create!(:name=>"正确",:style=>"accepted")
		Status.create!(:name=>"错误答案",:style=>"wrong")
		Status.create!(:name=>"超出时间限制",:style=>"tle")
		Status.create!(:name=>"超出空间限制",:style=>"mle")
		Status.create!(:name=>"输出格式错误",:style=>"pe")
		Status.create!(:name=>"运行时出错",:style=>"re")
		Status.create!(:name=>"编译失败",:style=>"ce")
		Status.create!(:name=>"部分正确",:style=>"score")

		#ProblemType
		ProblemType.create!(:name=>"传统型",:description=>"忽略行末空格与文末回车")
		ProblemType.create!(:name=>"传统SpecialJudge型",:description=>"由SpecialJudge判断得分")
		ProblemType.create!(:name=>"提交答案型",:description=>"提交一个包含答案的zip文件")
		ProblemType.create!(:name=>"交互型",:description=>"补全一段代码，然后由特定的Judge判断")

		#ContestType
		ContestType.create!(:name=>"OI",:description=>"比赛时不能看到提交结果，最终按总分排名")
		ContestType.create!(:name=>"ACM",:description=>"比赛时可以看到提交结果，最终按总分排名")

		#EnvironmentType
		EnvironmentType.create!(:name=>"Windows",:description=>"Windows系统")
		EnvironmentType.create!(:name=>"Linux",:description=>"Ubuntu系统")

		#User
		root = User.create!(:username=>"root",:password=>"root",
				:password_confirmation=>"root",:create_ip=>"127.0.0.1",:level=>4)

		#Course
		course_local = Course.create!(:name=>"本地题库", :user=>root)
		course_vjudge = Course.create!(:name=>"虚拟在线评测系统", :user=>root)
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

		#EnvironmentType
		EnvironmentType.destroy_all

		#User
		User.destroy_all

		#Course
		Course.destroy_all
	end
end
