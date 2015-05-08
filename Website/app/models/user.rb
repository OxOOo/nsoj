class User < ActiveRecord::Base
  validates_presence_of :username, message: "用户名不能为空"
	validates_presence_of :password, message: "密码不能为空"
	validates_presence_of :create_ip, message: "IP地址不能为空"
	validates_format_of :username, with: /\A[0-9a-zA-Z_]{,20}\z/, message: "用户名只能由1-20个数字,小写字母,大写字母和下划线组成"
	validates_format_of :password, with: /\A[0-9a-zA-Z_]{,35}\z/, message: "用户名只能由1-35个数字,小写字母,大写字母和下划线组成"
	validates_format_of :create_ip, with: /\A\d+[\.\d]+\z/, message: "IP地址不正确"
	validates_length_of :nickname, maximum: 20, message: "真实姓名长度不能超过20"
	validates_length_of :sign, maximum: 100, message: "真实姓名长度不能超过100"
	validates_length_of :create_ip, in: 7..23, message: "IP地址长度不正确"
	validates_confirmation_of :password, message: "两次输入的密码不一致"
	validates_uniqueness_of :username, message: "该用户名已存在"

	has_many :entries, ->{order("id DESC")}
	has_many :send_messages, class_name: "Message", foreign_key: "sender_id"
	has_many :receive_messages, class_name: "Message", foreign_key: "receiver_id"
	has_many :submissions, class_name: "Submission"
	has_many :accepted, -> { where(score: 100) }, class_name: "Submission"
	has_many :solved, ->{ where(score: 100).group(:statistic_id).having("submission_score=max(submission_score)") }, class_name: "Submission"
	has_one :access
	has_many :blogs, ->{ order("updated_at DESC") }

	def all_messages
		Message.all_messages(self)
	end

	after_touch do
		self.solved_count = self.solved.count
		self.accepted_count = self.accepted.count
		self.submissions_count = self.submissions.count
		self.save!
	end
	
	after_save do
	  if self.nickname == nil || /\A\s*\z/.match(self.nickname)
	    self.nickname = self.username
	    self.save!
	  end
	end
end
