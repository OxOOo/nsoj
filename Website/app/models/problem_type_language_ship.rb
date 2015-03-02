class ProblemTypeLanguageShip < ActiveRecord::Base
	belongs_to :problem_type
	belongs_to :language
end
