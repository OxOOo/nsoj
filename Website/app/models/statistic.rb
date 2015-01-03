class Statistic < ActiveRecord::Base
	belongs_to :statistic_table, polymorphic: true
	has_many :solved, ->{where(score: 100).group(:user_course_ship_id).having("submission_score=max(submission_score)")}, class_name: "Submission"
	has_many :accepted, ->{where(score: 100)}, class_name: "Submission"
	has_many :submissions

	after_touch do
		self.solved_count = self.solved.count
		self.accepted_count = self.accepted.count
		self.submissions_count = self.submissions.count
		if self.solved_count == nil
			self.solved_count = 0
		end
		self.save
	end
	
	def problem
		if self.statistic_table_type == "CourseProblemShip"
			return CourseProblemShip.find(self.statistic_table_id).problem
		else
			return ContestProblemShip.find(self.statistic_table_id).problem
		end
	end
end
