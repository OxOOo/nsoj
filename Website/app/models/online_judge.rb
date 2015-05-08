class OnlineJudge < ActiveRecord::Base
  validates :name, presence: {message: "OJ的名称不能为空"}, length: {maximum: 20, message: "OJ的名称长度不能超过20"}
	validates :description, length: {maximum: 200, message: "OJ的描述长度不能超过200"}
	validates :address, presence: {message: "OJ的地址不能为空"}, length: {maximum: 40, message: "OJ的地址长度不能超过40"}
	validates :regexp, presence: {message: "OJ的正则表达式匹配不能为空"}, length: {maximum: 20, message: "OJ的正则表达式长度不能超过20"}
	validates_length_of :hint, maximum: 40, message: "OJ的提示长度不能超过40"
	
	has_many :problems

	#常量
	List = OnlineJudge.all
	VJudgeList = OnlineJudge.where("id != ?", 1)
	Local = OnlineJudge.first
end
