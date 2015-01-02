class Statistic < ActiveRecord::Base
	belongs_to :statistic_table, polymorphic: true
	has_many :solved, ->{where(score: 100).group(:user_course_ship_id).having("submission_score=max(submission_score)")}, class_name: "Submission"
	has_many :accepted, ->{where(score: 100)}, class_name: "Submission"
	has_many :submissions

	after_touch do
		self.solved_count = self.solved.count
		self.accepted_count = self.accepted.count
		self.submissions_count = self.submissions.count
		self.save
	end
end
