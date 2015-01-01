class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :check_banned_ip
  before_action :find_current_user
  
  protected
  	def check_banned_ip #检查IP地址是否被禁
  		if BannedIp.valid.where(:banned_ip=>request.remote_ip).exists?
  			flash.now[:errors] = Array.new
  			flash.now[:errors] << "你的IP #{request.remote_ip} 被管理员禁止在 #{format_time(BannedIp.valid.where(:banned_ip=>request.remote_ip).first.deadline)} 前访问本网站，请与管理员联系"
  			return render 'welcome/index'
  		end
  	end
  	
  	def find_current_user #获取当前用户
  		if @current_user == nil && session[:current_user_id] != nil
  			@current_user = User.find(session[:current_user_id])
  		end
  		if @current_user != nil && @current_user.username == "root" && request.remote_ip != "127.0.0.1"
  			flash[:errors] << "root 用户只能在服务器上登录"
  			@current_user = nil
  			session[:current_user_id] = nil
  			return redirect_to root_path
  		end
  		if BannedId.valid.where(:banned=>@current_user).exists?
  			flash[:errors] << "#{@current_user.username} 被管理员禁止在 #{format_time(BannedId.valid.where(:banned=>@current_user).first.deadline)} 前登录本网站，请与管理员联系"
  			@current_user = nil
  			session[:current_user_id] = nil
  			return redirect_to root_path
  		end
  		if @current_user != nil
  			@current_user_course_ship = @current_user.user_course_ships.where(:course=>@current_user.current_course).first
  		end
  	end
  	
  	def check_login #检查是否已登录
  		if @current_user == nil
				flash[:info] = "请先登录"
				return redirect_to user_login_path
			end
		end
		
		def check_logout #检查是否已退出
			if @current_user != nil
				flash[:info] = "请先退出"
				return redirect_to root_path
			end
		end
end
