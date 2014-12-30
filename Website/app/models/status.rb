class Status < ActiveRecord::Base
	validates :name, presence: {message: "状态的名称不能为空"}, length: {maximum: 20, message: "状态的名称长度不能超过20"}
	validates :style, presence: {message: "状态的css类型不能为空"}, length: {maximum: 20, message: "状态的css类型长度不能超过20"}

	has_many :submissions
end
