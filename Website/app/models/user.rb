class User < ActiveRecord::Base
	validates_presence_of :username, message: "用户名不能为空"
	validates_presence_of :password, message: "密码不能为空"
	validates_presence_of :create_ip, message: "IP地址不能为空"
	validates_presence_of :password_confirmation, message: "请再次输入密码"
	validates_format_of :username, with: /[0-9a-zA-Z_]{,20}/, message: "用户名只能由1-20个数字，小写字母和大写字母组成"
	validates_format_of :password, with: /[0-9a-zA-Z_]{,35}/, message: "用户名只能由1-35个数字，小写字母和大写字母组成"
	validates_format_of :email, with: /\w+[\.\w]+@\w+\.\w+[\.\w]+/, message: "EMAIL格式不正确", allow_blank: true
	validates_format_of :create_ip, with: /\d+[\.\d]+/, message: "IP地址不正确"
	validates_length_of :realname, maximum: 10, message: "真实姓名长度不能超过10"
	validates_length_of :create_ip, in: 7..23, message: "IP地址长度不正确"
	validates_length_of :school, maximum: 200, message: "学校长度不能超过200"
	validates_confirmation_of :password, message: "两次输入的密码不一致"
	validates_uniqueness_of :username, message: "该用户名已存在"

	#常量
	LevelCommon = 0
	LevelWatcher = 1
	LevelSuperWatcher = 2
	LevelAdmin = 3
	LevelSuperAdmin = 4

	belongs_to :current_course, class_name: "Course", foreign_key: "current_course_id"
	has_many :entries, ->{order("id DESC")}
	has_many :user_course_ships
	has_many :valid_user_course_ships, ->{where status: UserCourseShip::StatusPassed}, class_name: "UserCourseShip"
	has_many :courses, through: :valid_user_course_ships
	has_many :created_courses, class_name: "Course"
	has_many :submissions
	has_many :send_messages, class_name: "Message", foreign_key: "from_user_id"
	has_many :receive_messages, class_name: "Message", foreign_key: "receive_user_id"
	has_many :solved, ->{where(score: 100).group(:statistic_id).having("submission_score=max(submission_score)")}, class_name: "Submission"
	has_many :accepted, ->{where(score: 100)}, class_name: "Submission"
	has_many :submissions

	after_touch do
		self.solved_count = self.solved.count
		self.accepted_count = self.accepted.count
		self.submissions_count = self.submissions.count
		self.save
	end

	after_create do
		if Course::LocalCourse != nil
			local = UserCourseShip.new(:user => self, :course => Course::LocalCourse)
			local.status = UserCourseShip::StatusPassed
		end
		if Course::VJudgeCourse != nil
			vjudge = UserCourseShip.new(:user => self, :course => Course::VJudgeCourse)
			vjudge.status = UserCourseShip::StatusPassed
		end
	end
	
	def level_info
		if self.level == LevelCommon
			return "普通用户"
		elsif self.level == LevelWatcher
			return "观察员"
		elsif self.level == LevelSuperWatcher
			return "超级观察员"
		elsif self.level == LevelAdmin
			return "管理员"
		else
			return "超级管理员"
		end
	end
end
