#require 'FileUtils'
require 'zip'

class Problem < ActiveRecord::Base
	belongs_to :problem_type
	
	validates :title, presence: {message: "标题不能未空"}, length: {maximum: 50, message: "标题长度不能超过50"}
	
	scope :visible, -> { where(show: true) }
	
	def description
		return nil if not File.exists?("problems/#{self.id}/description")
		file = File.open("problems/#{self.id}/description", "r")
		str = file.read
		file.close
		return str
	end
	
	def description=(str)
		File.open("problems/#{self.id}/description", "w") do |file|
			file.write(str)
		end
	end
	
	def spj
		return nil if not File.exists?("problems/#{self.id}/spj")
		file = File.open("problems/#{self.id}/spj", "r")
		str = file.read
		file.close
		return str
	end
	
	def spj=(str)
		File.open("problems/#{self.id}/spj", "w") do |file|
			file.write(str)
		end
	end
	
	def spj_file
		file_name = "problems/#{self.id}/spj"
		file_name = nil if not File.exists?(file_name)
		return file_name
	end
	
	def front
		return nil if not File.exists?("problems/#{self.id}/front")
		file = File.open("problems/#{self.id}/front", "r")
		str = file.read
		file.close
		return str
	end
	
	def front=(str)
		File.open("problems/#{self.id}/front", "w") do |file|
			file.write(str)
		end
	end
	
	def front_file
		file_name = "problems/#{self.id}/front"
		file_name = nil if not File.exists?(file_name)
		return file_name
	end
	
	def front_slightly
		lines = IO.readlines("problems/#{self.id}/front")
		return "\n" if lines == nil || lines.length == 0
		if lines.length <= 5
			return lines.join
		else
			return "#{lines[0,5].join}..."
		end
	end
	
	def back
		return nil if not File.exists?("problems/#{self.id}/back")
		file = File.open("problems/#{self.id}/back", "r")
		str = file.read
		file.close
		return str
	end
	
	def back=(str)
		File.open("problems/#{self.id}/back", "w") do |file|
			file.write(str)
		end
	end
	
	def back_file
		file_name = "problems/#{self.id}/back"
		file_name = nil if not File.exists?(file_name)
		return file_name
	end
	
	def back_slightly
		lines = IO.readlines("problems/#{self.id}/back")
		return "\n" if lines == nil || lines.length == 0
		if lines.length <= 5
			return lines.join
		else
			return "...\n#{lines[lines.length-5,5].join}"
		end
	end
	
	def data=(io)
		File.open("problems/#{self.id}/data.zip", "wb") do |file|
			file.write(io.read)
		end
	end
	
	def data_input(index)
		file_name = "input#{index}.txt"
		Zip::File.open("problems/#{self.id}/data.zip") do |zipfile|
			file = zipfile.glob(file_name).first
			return file.get_input_stream.read if file != nil
		end
		return nil
	end
	
	def data_output(index)
		file_name = "output#{index}.txt"
		Zip::File.open("problems/#{self.id}/data.zip") do |zipfile|
			file = zipfile.glob(file_name).first
			return file.get_input_stream.read if file != nil
		end
		return nil
	end
	
	def new_record
		problem = self.dup
		problem.save!
		Dir.entries("problems/#{self.id}").each do |sub|
	  	if sub != '.' && sub != '..'
			  if File.directory?("problems/#{self.id}/#{sub}")
			    FileUtils.cp_r "problems/#{self.id}/#{sub}", "problems/#{problem.id}"
			  else
			    FileUtils.cp_r "problems/#{self.id}/#{sub}", "problems/#{problem.id}/#{sub}"
	    	end
	  	end
	  end
	  return problem
	end
	
	private
		def rmdir(path)
			Dir.entries(path).each do |sub|
		  	if sub != '.' && sub != '..'
				  if File.directory?("#{path}/#{sub}")
				    rmdir("#{path}/#{sub}")
				  else
				    File.delete("#{path}/#{sub}")
		    	end
		  	end
		  end
		  Dir.delete(path)
		end
	
	after_create do
		Dir.mkdir("problems") if not Dir.exists?("problems")
		#rmdir("problems/#{self.id}") if Dir.exists?("problems/#{self.id}")
		Dir.mkdir("problems/#{self.id}") if not Dir.exists?("problems/#{self.id}")
	end
end
