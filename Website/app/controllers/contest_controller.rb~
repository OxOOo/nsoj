class ContestController < ApplicationController

	def list
		@course = Course.find(params[:course_id])
		@user_course_ship = @course.user_course_ships.where(:user=>@current_user).first
		if (@user_course_ship == nil || @user_course_ship.status != UserCourseShip::StatusPassed) && @current_user.level < User::LevelWatcher
			flash[:error] = "无法查看该页面"
			return redirect_to :back
		end
		
		@running_contests = Contest.running
		@pending_contests = Contest.pending
		@finished_contests = Contest.finished.paginate(:page => params[:page])
	end

end
