class ProblemType < ActiveRecord::Base
	validates :name, presence: {message: "题目类型的名称不能为空"}, length: {maximum: 20, message: "题目类型的名称长度不能超过20"}
	validates :description, presence: {message: "题目类型的描述不能为空"}, length: {maximum: 1000, message: "题目类型的描述长度不能超过1000"}

	#常量
	List = self.all
	
	Normal = ProblemType.first
	NormalSpj = ProblemType.second

	has_many :problems
end
