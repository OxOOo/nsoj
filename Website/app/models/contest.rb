class Contest < ActiveRecord::Base
	validates :name, presence: {message: "比赛名称不能为空"},length: {maximum: 50, message: "比赛名称长度不能超过50"}
	validates :description, presence: {message: "比赛描述不能为空"},length: {maximum: 1000, message: "比赛描述长度不能超过1000"}
	validates_presence_of :start_time, message: "比赛开始时间不能为空"
	validates_presence_of :end_time, message: "比赛结束时间不能为空"
	validate :check_time

	belongs_to :contest_type
	belongs_to :course
	belongs_to :user
	has_many :contest_problem_ships
	has_many :problems, through: :contest_problem_ships
	has_many :submissions, through: :contest_problem_ships

	before_validation do
		if self.description == nil || self.description == ""
			self.description = self.name
		end
	end
	
	scope :hide_problem, -> { where(["hide_problem = ? AND ? <= end_time",true,Time.now]) }
	scope :pending, -> {where(["start_time > ?", Time.now]) }
	scope :running, -> {where(["start_time <= ? AND ? <= end_time", Time.now, Time.now]) }
	scope :finished, -> {where(["end_time < ?", Time.now]) }

	protected
		def check_time
			if self.start_time != nil && self.start_time <= Time.now
				errors.add(:base,"比赛开始时间不能比当前时间早")
			end
			if self.start_time != nil && self.end_time != nil && self.start_time >= self.end_time
				errors.add(:base,"比赛结束时间不能比开始时间早")
			end
		end
end
