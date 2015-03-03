class StatusController < ApplicationController
	before_action :check_admin_right, only: [:rejudge]

	def index
		@status = Status.list
	end
	
	def single
		@status = Status.find(params[:status_id])
	end
	
	def rejudge
		@status = Status.find(params[:status_id])
		@status.init
		return redirect_to status_index_path
	end

end
