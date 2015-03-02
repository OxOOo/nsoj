class Status < ActiveRecord::Base
	belongs_to :problem
	belongs_to :user
	belongs_to :language
	
	scope :list, -> { order(id: :desc) }
	
	def submit
		return nil if not File.exists?("status/#{self.id}_submit")
		file = File.open("status/#{self.id}_submit", "r")
		str = file.read
		file.close
		return str
	end
	
	def submit=(data)
		if self.problem.problem_type == ProblemType::SubmitAnswerType
			File.open("status/#{self.id}_submit.zip", "wb") do |file|
				file.write(data.read)
			end
		else
			File.open("status/#{self.id}_submit", "w") do |file|
				file.write(data)
			end
		end
	end
	
	def submit_file
		if self.problem.problem_type != ProblemType::SubmitAnswerType
			file_name = "status/#{self.id}_submit"
		else
			file_name = "status/#{self.id}_submit.zip"
		end
		file_name = nil if not File.exists?(file_name)
		return file_name
	end
	
	def submit_zip(index)
		file_name = "answer#{index}.txt"
		Zip::File.open("status/#{self.id}_submit.zip") do |zipfile|
			file = zipfile.glob(file_name).first
			return file.get_input_stream.read if file != nil
		end
		return nil
	end
	
	def ce
		return nil if not File.exists?("status/#{self.id}_ce")
		file = File.open("status/#{self.id}_ce", "r")
		str = file.read
		file.close
		return str
	end
	
	def ce=(data)
		File.delete "status/#{self.id}_ce" if File.exists?("status/#{self.id}_ce")
		if data != nil
			File.open("status/#{self.id}_ce", "w") do |file|
				file.write(data)
			end
		end
	end
	
	def result
		return nil if not File.exists?("status/#{self.id}_result")
		file = File.open("status/#{self.id}_result", "r")
		str = file.read
		file.close
		return str
	end
	
	def result=(data)
		File.delete "status/#{self.id}_result" if File.exists?("status/#{self.id}_result")
		if data != nil
			File.open("status/#{self.id}_result", "w") do |file|
				file.write(data)
			end
		end
	end
	
	after_create do
		Dir.mkdir("status") if not Dir.exists?("status")
	end
end
