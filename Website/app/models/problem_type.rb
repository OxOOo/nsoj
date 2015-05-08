class ProblemType < ActiveRecord::Base
  validates :name, presence: {message: "题目类型的名称不能为空"}, length: {maximum: 20, message: "题目类型的名称长度不能超过20"}
	validates :description, presence: {message: "题目类型的描述不能为空"}, length: {maximum: 200, message: "题目类型的描述长度不能超过200"}
	
	has_many :language_problem_type_ships
	has_many :languages, through: :language_problem_type_ships

	#常量
	LocalList = ProblemType.limit(4)
	Normal = ProblemType.first
	NormalSpj = ProblemType.offset(1).first
	Interaction = ProblemType.offset(2).first
	SubmitAnswer = ProblemType.offset(3).first
	VJudge = ProblemType.offset(4).first

	has_many :problems
end
