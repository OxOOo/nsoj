class ContestProblemShip < ActiveRecord::Base
	belongs_to :contest
	belongs_to :problem
	has_one :statistic, as: :statistic_table
	has_many :submissions, through: :statistic

	after_create do
		self.statistic = Statistic.create
		self.save
	end
end
