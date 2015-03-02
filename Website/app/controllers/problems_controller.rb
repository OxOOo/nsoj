class ProblemsController < ApplicationController
	before_action :check_login, only: [:single_submit]
	before_action :check_admin_right, only: [:append, :edit, :edit_submit, :edit_description, :edit_description_submit, 
				:edit_judge, :edit_judge_submit]

	def index
		@problems = Problem.visible
	end
	
	def single
		@problem = Problem.find(params[:problem_id])
	end
	
	def single_submit
		@problem = Problem.find(params[:problem_id])
		if @problem.problem_type.languages.where(:id=>params[:status][:language]).exists? == false
			flash[:error] = "参数错误"
			return redirect_to :back
		end
		@status = Status.new(:problem=>@problem, :user=>@current_user, :language_id=>params[:status][:language])
		@status.save!
		@status.submit = params[:status][:submit]
		return redirect_to status_single_path(@status)
	end

	def append
		@problem = Problem.find(params[:problem_type]).new_record
		return redirect_to problems_edit_path(@problem)
	end
	
	def edit
		@problem = Problem.find(params[:problem_id])
	end
	
	def edit_submit
		@problem = Problem.find(params[:problem_id])
		if @problem.update(params[:problem].permit(:title, :time_limit, :memory_limit, :show)) && @problem.update(:problem_type_id =>params[:problem][:problem_type].to_i)
			flash[:success] = "修改成功"
			return redirect_to problems_edit_description_path(@problem)
		else
			return render :edit
		end
	end
	
	def edit_description
		@problem = Problem.find(params[:problem_id])
	end
	
	def edit_description_submit
		@problem = Problem.find(params[:problem_id])
		@problem.description = params[:problem][:description]
		flash[:success] = "修改成功"
		return redirect_to problems_edit_judge_path(@problem)
	end
	
	def edit_judge
		@problem = Problem.find(params[:problem_id])
	end
	
	def edit_judge_submit
		@problem = Problem.find(params[:problem_id])
		if @problem.update(params[:problem].permit(:submit_limit, :judge)) == false
			return render :edit_judge
		end
		@problem.data = params[:problem][:data] if params[:problem][:data] != nil
		if @problem.problem_type == ProblemType::NormalSpjType || @problem.problem_type == ProblemType::InteractionType
			@problem.spj = params[:problem][:spj]
			if @problem.problem_type == ProblemType::InteractionType
				@problem.front = params[:problem][:front]
				@problem.back = params[:problem][:back]
			end
		end
		return redirect_to problems_single_path(@problem)
	end
	
end
