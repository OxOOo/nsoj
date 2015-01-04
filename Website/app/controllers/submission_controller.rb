class SubmissionController < ApplicationController

	def submit
		@course = Course.find(params[:course_id])
		@user_course_ship = @course.user_course_ships.where(:user=>@current_user).first
		if (@user_course_ship == nil || @user_course_ship.status != UserCourseShip::StatusPassed) && @current_user.level < User::LevelAdmin
			flash[:error] = "提交失败"
			return redirect_to :back
		end
		@course_problem_ship = @course.course_problem_ships.find(params[:problem_id])
		@problem = @course_problem_ship.problem
		if @problem.visible == false
			flash[:error] = "提交失败"
			return redirect_to :back
		end
		@submission = Submission.new
		@submission.user_course_ship = @user_course_ship
		@submission.statistic = @course_problem_ship.statistic
		@submission.language = Language::List[params[:submission][:language].to_i]
		@submission.status = Status::Pending
		@submission.environment_type = EnvironmentType::List[params[:submission][:environment_type].to_i]
		@submission.submit_ip = request.remote_ip
		@submission.source_length = params[:submission][:source_code].length
		if @submission.save
			flash[:success] = "提交成功"
			@submission.source_code = params[:submission][:source_code]
		else
			flash[:success] = "提交失败"
		end
		return redirect_to submission_list_path
	end
	
	def list
		@course = Course.find(params[:course_id])
		@user_course_ship = @course.user_course_ships.where(:user=>@current_user).first
		if @current_user.level < User::LevelWatcher && (@user_course_ship == nil || @user_course_ship.status != UserCourseShip::StatusPassed)
			flash[:error] = "你没有权限查看该页面"
			return redirect_to :back
		end
		@submissions = @course.submissions.list.paginate(:page=>params[:page])
	end
	
	def show
		@course = Course.find(params[:course_id])
		@user_course_ship = @course.user_course_ships.where(:user=>@current_user).first
		if @current_user.level < User::LevelWatcher && (@user_course_ship == nil || @user_course_ship.status != UserCourseShip::StatusPassed)
			flash[:error] = "你没有权限查看该页面"
			return redirect_to :back
		end
		@submission = @course.submissions.where(:id=>params[:submission_id]).first
		@submissions = [@submission]
		@see_source = false
		if @current_user.level >= User::LevelSuperWatcher || @submission.user_course_ship.user == @current_user || (@user_course_ship != nil && @user_course_ship.level >= UserCourseShip::LevelWatcher)
			@see_source = true
		end
	end
end
