class Course < ActiveRecord::Base
	validates_presence_of :user_id, message: "创始人不能为空"
	validates_presence_of :name, message: "课程名称不能为空"
	validates_presence_of :description, message: "课程描述不能为空"
	validates_length_of :name, maximum: 200, message: "课程名称长度不能超过200"
	validates_length_of :description, maximum: 1000, massage: "课程描述不能超过1000"

	belongs_to :user
	has_many :user_course_ships
	has_many :valid_user_course_ships, ->{where status: UserCourseShip::StatusPassed}, class_name: "UserCourseShip"
	has_many :users, through: :valid_user_course_ships
	has_many :course_problem_ships
	has_many :problems, through: :course_problem_ships
	has_many :contests

	before_validation do
		if self.description == nil || self.description == ""
			self.description = self.name
		end
	end

	after_create do
		UserCourseShip.create!(:user=>self.user, :course=>self, :status=>UserCourseShip::StatusPassed,
					:level=>UserCourseShip::LevelCreater)
	end

	#常量
	LocalCourse = self.first
	VJudgeCourse = self.second
end
