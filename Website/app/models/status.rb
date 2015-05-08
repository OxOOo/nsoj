class Status < ActiveRecord::Base
  validates :name, presence: {message: "状态的名称不能为空"}, length: {maximum: 20, message: "状态的名称长度不能超过20"}
	validates :style, length: {maximum: 20, message: "状态的css类型长度不能超过20"}
	
	has_many :submissions

	#常量
	List = Status.all
	Pending = Status.first

	has_many :submissions
end
