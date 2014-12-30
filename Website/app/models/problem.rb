class Problem < ActiveRecord::Base
	validates :name, presence: {message: "题目名称不能为空"},length: {maximum: 50, message: "题目名称长度不能超过50"}
	validates :origin_id, length: {maximum: 20, message: "原题库ID长度不能超过20"}

	#常量
	TaskPending = 0
	TaskRunning = 1
	TaskFinished = 2

	belongs_to :user
	belongs_to :online_judge
	belongs_to :problem_type
	has_many :course_problem_ships
	has_many :courses, through: :course_problem_ships
	has_many :contest_problem_ships
	has_many :contests, through: :contest_problem_ships
end
