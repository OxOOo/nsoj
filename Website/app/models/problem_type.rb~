class ProblemType < ActiveRecord::Base
	has_many :problem_type_language_ships
	has_many :languages, through: :problem_type_language_ships
	
	validates :title, presence: {message: "标题不能未空"}, length: {maximum: 50, message: "标题长度不能超过50"}
	
	NormalType = ProblemType.where(:id=>1).first
  NormalSpjType = ProblemType.where(:id=>2).first
  InteractionType = ProblemType.where(:id=>3).first
  SubmitAnswerType = ProblemType.where(:id=>4).first
end
