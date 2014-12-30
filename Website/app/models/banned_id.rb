class BannedId < ActiveRecord::Base
	validates_presence_of :banned_id, message: "用户ID不能为空"
	validates_presence_of :deadline, message: "过期时间不能为空"

	belongs_to :banned, class_name: "User"
	belongs_to :user
end
