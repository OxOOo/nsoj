class UserController < ApplicationController
	before_action :check_login, only: [:logout,:my_info,:modify,:modify_post]
	before_action :check_logout, only: [:login,:login_post,:register,:register_post]

	def login
	end
	
	def login_post
		@user = User.where(:username=>params[:user][:username]).first
		if @user == nil
			flash[:error] = "用户#{params[:user][:username]}不存在"
			return redirect_to user_login_path
		end
		if @user.password != params[:user][:password]
			flash[:error] = "用户名或密码错误"
			return redirect_to user_login_path
		end
		session[:current_user_id] = @user.id
		flash[:success] = "登录成功"
		@user.entries.create!(:ip=>request.remote_ip)
		return redirect_to root_path
	end
	
	def logout
		session[:current_user_id] = nil
		flash[:success] = "退出成功"
		return redirect_to root_path
	end
	
	def my_info
		return render 'my_info'
	end
	
	def register
		@user = User.new
		render 'register'
	end
	
	def register_post
		@user = User.new(params[:user].permit(:username,:password,:password_confirmation,:realname,:email,:school))
		@user.create_ip = request.remote_ip
		if @user.save
			session[:current_user_id] = @user.id
			@user.entries.create!(:ip=>request.remote_ip)
			flash[:success] = "注册成功"
			return redirect_to root_path
		end
		return render 'register'
	end
	
	def modify
		@user = @current_user
		@user.password = nil
	end
	
	def modify_post
		if @current_user.password != params[:current_password]
			flash[:error] = "密码错误"
		else
			if params[:user][:password] == nil || params[:user][:password] == ""
				params[:user][:password] = @current_user.password
				params[:user][:password_confirmation] = @current_user.password
			end
			if @current_user.update(params[:user].permit(:password,:password_confirmation,:realname,:email,:school)) == false
				@user = @current_user
				@user.password = nil
				@user.password_confirmation = nil
				return render "modify"
			else
				flash[:success] = "修改成功"
			end
		end
		return redirect_to user_modify_path
	end
end
