class ClientIp < ActiveRecord::Base
	validates :ip, presence: {message: "评测器的IP地址不能为空"}, format: {with: /\d+[\.\d]+/, message: "评测器的IP地址格式不正确"},
			length: {in: 7..23, message: "评测器的IP地址长度不正确"}

	belongs_to :user
end
