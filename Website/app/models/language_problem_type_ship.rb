class LanguageProblemTypeShip < ActiveRecord::Base
  belongs_to :language
  belongs_to :problem_type
end
