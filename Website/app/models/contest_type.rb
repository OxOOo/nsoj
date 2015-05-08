class ContestType < ActiveRecord::Base
  validates_presence_of :name, message: "比赛类型名称不能为空"
  validates_length_of :name, in: 1..20, message: "比赛类型名称长度不能超过20"
  validates_presence_of :description, message: "比赛类型描述不能为空"
  validates_length_of :description, in: 1..200, message: "比赛类型描述长度不能超过200"
  
  has_many :contests
  
end
