class BannedId < ActiveRecord::Base
  belongs_to :user
  belongs_to :banned, :class_name => "User"
  
  validates_presence_of :banned_id, message: "被禁用户ID不能为空"
	validates_presence_of :deadline, message: "过期时间不能为空"
	validate :check_deadline

	protected
		def check_deadline
			if self.deadline != nil && self.deadline <= Time.now
				errors.add(:deadline,"过期时间不能比当前时间早")
			end
		end
  
  scope :active, -> { where(["deadline > ?",Time.now]) }
end
