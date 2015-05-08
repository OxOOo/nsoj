class Contest < ActiveRecord::Base
  validates_presence_of :name, message: "比赛名称不能为空"
  validates_length_of :name, in: 1..50, message: "比赛名称长度不能超过50"
  validate :check_datetime
  
  has_many :contest_problem_ships
  has_many :problems, through: :contest_problem_ships
  has_many :statistics, through: :contest_problem_ships
  has_many :submissions, through: :statistics

  scope :finished, ->{ where(["end_time < ?", Time.now]) }
  scope :running, ->{ where(["start_time < ? AND ? < end_time", Time.now, Time.now]) }
  scope :pending, ->{ where(["start_time > ?", Time.now]) }
  
  scope :hide_problem, ->{ where(["(start_time < ? AND ? < end_time) OR (start_time > ? AND hide_problem == ?)",
    Time.now, Time.now, Time.now, true]) }

  after_save do
    Contest.load_hide_problem_ids
  end
  
  after_destroy do
    Contest.load_hide_problem_ids
  end

  def Contest.load_hide_problem_ids
    $hide_problem_ids = []
    Contest.hide_problem.each do |contest|
      $hide_problem_ids << contest.problems.ids
    end
  end

	protected
		def check_datetime
		  if self.start_time == nil
				errors.add(:start_time,"开始时间不能为空")
			end
			if self.end_time == nil
				errors.add(:end_time,"结束时间不能未空")
			end
			if self.end_time != nil && self.end_time < Time.now
				errors.add(:end_time,"结束时间不能比当前时间早")
			end
			if self.start_time != nil && self.end_time != nil && self.start_time > self.end_time
				errors.add(:base,"开始时间不能比结束时间晚")
			end
		end

  belongs_to :contest_type
  belongs_to :user
end
