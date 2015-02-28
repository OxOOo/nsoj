class UsersController < ApplicationController

	def login
	end
	
	def login_submit
		return redirect_to root_path
	end
	
	def logout
		return redirect_to root_path
	end
	
	def register
	end
	
	def register_submit
		return redirect_to root_path
	end
	
	def edit
	end
	
	def edit_submit
		return redirect_to root_path
	end

end
