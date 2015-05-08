class Blog < ActiveRecord::Base
  validates_presence_of :title, message: "博客标题不能为空"
  validates_presence_of :body, message: "博客内容不能为空"
  validates_length_of :title, in: 1..50, message: "博客标题长度不能超过50"
  
  belongs_to :user
  
  scope :notice, -> { where("top IS NOT NULL").order("top DESC").includes(:user) }
  scope :normal, -> { where("top IS NULL").order("id DESC").includes(:user) }
end
