class ProblemController < ApplicationController
	before_action :check_user_level

	def list
		@course_problem_ships = @current_user.current_course.course_problem_ships.list.paginate(:page=>params[:page])
	end

	def show
		@course_problem_ship = @course.course_problem_ships.find(params[:problem_id])
		@problem = @course_problem_ship.problem
		if @problem.visible == false
			@problem = Problem.new
		end
	end
	
	protected
		def check_user_level
			@course = Course.find(params[:course_id])
			@user_course_ship = @course.user_course_ships.where(:user=>@current_user).first
			if (@user_course_ship == nil || @user_course_ship.status != UserCourseShip::StatusPassed) && @current_user.level < User::LevelWatcher
				flash[:error] = "你不能查看本页面"
				return redirect_to :back
			end
		end
end
