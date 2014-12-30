class Message < ActiveRecord::Base
	validates :body, presence: {message: "消息的内容不能为空"}, length: {maximum: 1000, message: "消息的内容长度不能超过1000"}

	belongs_to :from_user, class_name: "User", inverse_of: :send_messages
	belongs_to :receive_user, class_name: "User", inverse_of: :receive_messages
end
