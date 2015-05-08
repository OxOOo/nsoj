class ContestProblemShip < ActiveRecord::Base
  belongs_to :contest
  belongs_to :problem
  
  has_one :statistic, as: :statisticable
  has_many :submissions, through: :statistic
end
