#require 'FileUtils'
require 'zip'

class Problem < ActiveRecord::Base
  validates :name, presence: {message: "题目名称不能为空"},length: {maximum: 50, message: "题目名称长度不能超过50"}
	validates :origin_id, length: {maximum: 20, message: "原题库ID长度不能超过20"}
	validate :check_origin_id

	belongs_to :user
	belongs_to :online_judge
	belongs_to :problem_type
	has_one :statistic, as: :statisticable
	has_many :submissions, through: :statistic
	
	scope :not_hide, ->{ where(["hide = ?", false]) }
	
	after_create do
		Dir.mkdir("public/problems") if not Dir.exists?("public/problems")
		FileUtils.rm_r("public/problems/#{self.id}") if Dir.exists?("public/problems/#{self.id}")
		Dir.mkdir("public/problems/#{self.id}") if not Dir.exists?("public/problems/#{self.id}")
	end
	
	after_save do
	  self.create_statistic if not self.statistic
	  self.update!(:origin_id=>self.id) if OnlineJudge::Local && self.online_judge_id == OnlineJudge::Local.id && self.origin_id.to_i != self.id
	end
	
	def description
		self.readfile("description")
	end
	
	def description=(str)
		self.savefile("description", str)
	end
	
	def hint
		self.readfile("hint")
	end
	
	def hint=(str)
		self.savefile("hint", str)
	end
	
	def spj
		self.readfile("spj")
	end
	
	def spj=(str)
		self.savefile("spj", str)
	end
	
	def spj_file
		file_name = "/problems/#{self.id}/spj"
		file_name = nil if not File.exists?("public" + file_name)
		return file_name
	end
	
	def front
		self.readfile("front")
	end
	
	def front=(str)
		self.savefile("front", str)
	end
	
	def front_file
		file_name = "/problems/#{self.id}/front"
		file_name = nil if not File.exists?("public" + file_name)
		return file_name
	end
	
	def front_slightly
		return "\n" if not File.exists?("public/problems/#{self.id}/front")
		lines = IO.readlines("public/problems/#{self.id}/front")
		return "\n" if lines == nil || lines.length == 0
		if lines.length <= 5
			return lines.join
		else
			return "#{lines[0,5].join}..."
		end
	end
	
	def back
		self.readfile("back")
	end
	
	def back=(str)
		self.savefile("back", str)
	end
	
	def back_file
		file_name = "/problems/#{self.id}/back"
		file_name = nil if not File.exists?("public" + file_name)
		return file_name
	end
	
	def back_slightly
		return "\n" if not File.exists?("public/problems/#{self.id}/back")
		lines = IO.readlines("public/problems/#{self.id}/back")
		return "\n" if lines == nil || lines.length == 0
		if lines.length <= 5
			return lines.join
		else
			return "...\n#{lines[lines.length-5,lines.length].join}"
		end
	end
	
	def set_data(io)
		File.open("public/problems/#{self.id}/data.zip", "wb") do |file|
			file.write(io.read)
		end
		list = []
		Zip::File.open("public/problems/#{self.id}/data.zip") do |zipfile|
			(1..self.test_count).each do |index|
			  list << index if zipfile.glob("input#{index}.txt").first && zipfile.glob("output#{index}.txt").first
		  end
		end
		return list
	end
	
	def data_file
	  file_name = "/problems/#{self.id}/data.zip"
		file_name = nil if not File.exists?("public" + file_name)
		return file_name
	end
	
	def data_input(index)
		file_name = "input#{index}.txt"
		Zip::File.open("public/problems/#{self.id}/data.zip") do |zipfile|
			file = zipfile.glob(file_name).first
			return file.get_input_stream.read if file != nil
		end
		return nil
	end
	
	def data_output(index)
		file_name = "output#{index}.txt"
		Zip::File.open("public/problems/#{self.id}/data.zip") do |zipfile|
			file = zipfile.glob(file_name).first
			return file.get_input_stream.read if file != nil
		end
		return nil
	end
	
	def new_problem
		problem = self.dup
		problem.save!
		Dir.mkdir("public/problems/#{problem.id}") if not Dir.exists?("public/problems/#{problem.id}")
		Dir.entries("public/problems/#{self.id}").each do |sub|
	  	if sub != '.' && sub != '..'
			  if File.directory?("public/problems/#{self.id}/#{sub}")
			    FileUtils.cp_r "public/problems/#{self.id}/#{sub}", "public/problems/#{problem.id}"
			  else
			    FileUtils.cp_r "public/problems/#{self.id}/#{sub}", "public/problems/#{problem.id}/#{sub}"
	    	end
	  	end
	  end
	  return problem
	end
	
	def visible(from_contest = false)
		if self.hide == true
			return false
		end
		if from_contest == true
			return true
		end
		Contest.hide_problem.each do |contest|
			if contest.exists?(self)
				return false
			end
		end
		return true
	end
	
	protected
	  def readfile(fname)
	    file_name = "public/problems/#{self.id}/#{fname}"
		  file = File.new(file_name, "r") if File.exists?(file_name)
		  str = nil
		  str = file.sysread(file.size).force_encoding("utf-8") if file != nil
		  file.close if file != nil
		  return str
		end
	  
	  def savefile(fname, str)
	    Dir.mkdir("public/problems") if not Dir.exists?("public/problems")
		  Dir.mkdir("public/problems/#{self.id}") if not Dir.exists?("public/problems/#{self.id}")
		
		  file_name = "public/problems/#{self.id}/#{fname}"
		  file = File.new(file_name, "w")
		  file.syswrite(str) if file != nil
	  end
	  
	  def check_origin_id
	    if not Regexp.new("\\A#{self.online_judge.regexp}\\z").match(self.origin_id)
        errors[:origin_id] << "编号 #{self.origin_id} 不符合 #{self.online_judge.name} 的规范，提示：#{self.online_judge.hint}"
    	end
	  end
	  
end
