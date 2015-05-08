class Submission < ActiveRecord::Base
  validates :submit_ip, presence: {message: "IP地址不能为空"}, format: {with: /\A\d+[\.\d]+\z/, message: "IP地址格式不正确"},
				length: {in: 7..23, message: "IP地址长度不正确"}

	belongs_to :user, touch: true, counter_cache: true
	belongs_to :statistic, touch: true, counter_cache: true
	belongs_to :language
	belongs_to :status
	
	scope :list, ->{order("id DESC")}
	
	def code
		readfile("code")
	end
	
	def code=(str)
		savefile("code", str)
		self.code_length = str.length
		self.save!
	end
	
	def compile_info
		readfile("compile_info")
	end
	
	def compile_info=(str)
		savefile("compile_info", str)
	end
	
	def judge_info
		readfile("judge_info")
	end
	
	def judge_info=(str)
		savefile("judge_info", str)
	end
	
	def problem
		statistic.problem
	end
	
	after_save do
	  self.submission_score = ((self.score * 100 - self.time) * 100 - self.memory) * 10 - self.code_length;
	  self.save!
	end
	
	private
	  def readfile(fname)
	    file_name = "submissions/#{self.id}/#{fname}"
		  file = File.new(file_name, "r") if File.exists?(file_name)
		  str = nil
		  str = file.sysread(file.size).force_encoding("utf-8") if file != nil
		  file.close if file != nil
		  return str
	  end
	  
	  def savefile(fname, str)
	    Dir.mkdir("submissions") if Dir.exists?("submissions") == false
		  Dir.mkdir("submissions/#{self.id}") if Dir.exists?("submissions/#{self.id}") == false
		
		  file_name = "submissions/#{self.id}/#{fname}"
		  file = File.new(file_name, "w")
		  file.syswrite(str) if file != nil
	  end
end
