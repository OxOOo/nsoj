class Operation < ActiveRecord::Base
  validates_presence_of :description, message: "消息不能为空"
  validates_length_of :description, in: 1..100, message: "消息长度不能超过100"
  validates_presence_of :ip, message: "IP地址不能为空"
	validates_format_of :ip, with: /\A\d+[\.\d]+\z/, message: "IP地址格式不正确"
	validates_length_of :ip, in: 7..23, message: "IP地址长度不正确"
	
	belongs_to :user
end
