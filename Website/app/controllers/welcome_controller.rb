require 'zip'

class WelcomeController < ApplicationController
	
	def index
	end
	
	def help
	end
	
	def post
		result = ""
		Zip::File.open(params[:submit][:file].path) do |zipfile|
			zipfile.each do |entry|
				result += entry.name + "\n"
				File.open(entry.name, "wb") do |file|
					file.write(entry.get_input_stream.read)
				end
			end
		end
		render plain: result
	end
	
end
