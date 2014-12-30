class Statistic < ActiveRecord::Base
	belongs :statistic_table, polymorphic: true
	has_many :submissions
end
