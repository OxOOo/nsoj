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
		@status.update!(:task=>false, :finish=>false)
		@status.ce = nil
		@status.result = nil
		return redirect_to status_index_path
	end

end
