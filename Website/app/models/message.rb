class Message < ActiveRecord::Base
  validates_presence_of :message, message: "消息不能为空"
  validates_length_of :message, in: 1..1000, message: "消息长度不能超过1000"
  
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"
  
  scope :not_read, -> { where(:read=>false) }
  
  def Message.all_messages(user)
    Message.where(["sender_id == ? or receiver_id == ?", user.id, user.id]).order("id DESC")
  end
  
end
