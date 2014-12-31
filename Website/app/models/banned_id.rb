class BannedId < ActiveRecord::Base
	validates_presence_of :banned_id, message: "用户ID不能为空"
	validates_presence_of :deadline, message: "过期时间不能为空"
	validate :check_deadline

	protected
		def check_deadline
			if self.deadline != nil && self.deadline <= Time.now
				errors.add(:base,"过期时间不能比当前时间早")
			end
		end

	belongs_to :banned, class_name: "User"
	belongs_to :user

	scope :valid, -> { where(["deadline > ?",Time.now]) }
end
