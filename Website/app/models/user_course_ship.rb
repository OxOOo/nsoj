class UserCourseShip < ActiveRecord::Base

	#常量
	StatusRefusee = 0
	StatusWaiting = 1
	StatusPassed = 2
	LevelCommon = 0
	LevelWatcher = 1
	LevelAdmin = 2
	LevelCreater = 3

	belongs_to :user
	belongs_to :course
	has_many :solved, ->{where(score: 100).group(:statistic_id).having("submission_score=max(submission_score)")}, class_name: "Submission"
	has_many :accepted, ->{where(score: 100)}, class_name: "Submission"
	has_many :submissions
	
	after_touch do
		self.solved_count = self.solved.count
		self.accepted_count = self.accepted.count
		self.submissions_count = self.submissions.count
		if self.solved_count == nil
			self.solved_count = 0
		end
		self.save!
	end
	
	scope :list, ->{includes(:user).order("solved_count DESC")}
	
	self.per_page = 10
end
