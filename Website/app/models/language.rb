class Language < ActiveRecord::Base
  validates :name, presence: {message: "编程语言的名称不能为空"}, length: {maximum: 10, message: "编程语言的名称长度不能超过10"}
	validates :cmd, presence: {message: "编译命令不能为空"}, length: {maximum: 90, message: "编译命令长度不能超过90"}
	
	has_many :submissions

	#常量
	List = self.all
end
