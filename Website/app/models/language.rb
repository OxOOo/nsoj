class Language < ActiveRecord::Base
	validates :name, presence: {message: "编程语言的名称不能为空"}, length: {maximum: 10, message: "编程语言的名称长度不能超过10"}
	validates :origin_cmd, presence: {message: "编程语言的原编译命令不能为空"}, length: {maximum: 50, message: "编程语言的原编译命令长度不能超过50"}
	validates :extra_cmd, length: {maximum: 50, message: "编程语言的附加编译命令长度不能超过50"}

	has_many :submissions
end
