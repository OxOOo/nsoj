class Language < ActiveRecord::Base
	validates :title, presence: {message: "标题不能未空"}, length: {maximum: 30, message: "标题长度不能超过30"}
end
