class CourseProblemShip < ActiveRecord::Base
	belongs_to :user
	belongs_to :course
	belongs_to :problem
	has_one :statistic, as: :statistic_table
	has_many :submissions, through: :statistic
end
