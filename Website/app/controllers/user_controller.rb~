class UserController < ApplicationController
	before_action :check_login, only: [:logout,:my_info,:modify,:modify_post,:messages,:messages_post,:show_message,:entries]
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
	
	def messages
		@messages = @current_user.all_messages.paginate(:page => params[:page]).includes(:from_user,:receive_user)
		@messages.notread.where(:receive_user=>@current_user).update_all(:read=>true, :updated_at=>Time.now)
		@send_message = Message.new
	end
	
	def messages_post
		@send_message = Message.new(params[:message].permit(:title,:body))
		@send_message.from_user = @current_user
		receive_user = User.where(:username=>params[:message][:receive_user]).first
		if receive_user == nil
			@send_message.errors[:receive_user] << "收信人不存在"
		elsif receive_user == @current_user
			@send_message.errors[:receive_user] << "发信人和收信人不能是同一个"
		else
			@send_message.receive_user = receive_user
			if @send_message.save
				@send_message = Message.new
				flash[:success] = "发送成功"
				return redirect_to user_messages_path
			end
		end
		@messages = @current_user.all_messages.paginate(:page => params[:page]).includes(:from_user,:receive_user)
		return render 'messages'
	end
	
	def show_message
		@message = @current_user.all_messages.find(params[:message_id])
		if @message == nil
			flash[:error] = "不存在的私信"
			return redirect_to user_messages_path
		end
		@send_message = Message.new
		if @message.from_user == @current_user
			@send_message.receive_user = @message.receive_user
		else 
			@send_message.receive_user = @message.send_user
		end
		if @message.title.match(/回复：.*/)
			@send_message.title = @message.title
		else
			@send_message.title = "回复："+@message.title
		end
	end
	
	def entries
		@entries = @current_user.entries.paginate(:page => params[:page], :per_page => 10)
	end
	
	def show
		@user = User.find(params[:user_id])
	end
end
