class UserController < ApplicationController

  before_action :check_logout, only: [:logout, :register, :register_commit, :login, :login_commit]
  before_action :check_login, only: [:modify, :modify_password, :modify_datum, :entries,
    :messages, :send_message, :send_message_commit, :show_message]

  def login
    #can login
    if $can_login == false
      flash[:error] = "网站被管理员限制禁止登录"
      return redirect_to root_path
    end
    
  end
  
  def login_commit
    #can login
    if $can_login == false
      flash[:error] = "网站被管理员限制禁止登录"
      return redirect_to root_path
    end
    
    @user = User.where(:username=>params[:user][:username]).take
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
		@user.last_online = Time.now
		@user.save!
		@user.entries.where(["created_at < ?", Time.now - 60*60*24*$keep_entry_days]).destroy_all
		return redirect_to root_path
  end
  
  def register
    #can register
    if $can_register == false
      flash[:error] = "网站被管理员限制禁止注册"
      return redirect_to root_path
    end
    
    @user = User.new
  end
  
  def register_commit
    #can register
    if $can_register == false
      flash[:error] = "网站被管理员限制禁止注册"
      return redirect_to root_path
    end
    
    @user = User.new(params[:user].permit(:username,:password,:password_confirmation,:nickname,:sign))
		@user.create_ip = request.remote_ip
		@user.last_online = Time.now
		if @user.save
			session[:current_user_id] = @user.id
			@user.entries.create!(:ip=>request.remote_ip)
			flash[:success] = "注册成功"
			return redirect_to root_path
		end
		return render 'register'
  end
  
  def logout
    flash[:success] = "退出成功"
    return redirect_to root_path
  end
  
  def datum
    @user = User.find(params[:user_id])
  end
  
  def modify
    @user = @current_user
    @user.password = nil
  end
  
  def modify_password
    @user = @current_user
    if @user.password != params[:user][:current_password]
      flash[:error] = "密码错误，请重新输入"
      return redirect_to user_modify_path
    end
    if @user.update(params[:user].permit(:password, :password_confirmation)) == false
      @user.password = nil
      return render "modify"
    else
      flash[:success] = "修改成功"
      return redirect_to user_modify_path
    end
  end
  
  def modify_datum
    @user = @current_user
    if @user.password != params[:user][:password]
      flash[:error] = "密码错误，请重新输入"
      return redirect_to user_modify_path
    end
    if @user.update(params[:user].permit(:nickname, :sign)) == false
      @user.password = nil
      return render "modify"
    else
      flash[:success] = "修改成功"
      return redirect_to user_modify_path
    end
  end
  
  def messages
    clac_page @current_user.all_messages.size, $message_per_page
    
    @messages = @current_user.all_messages.limit($message_per_page).offset(@offset).includes(:sender,:receiver)
    @send_message = Message.new
  end
  
  def send_message
    if $can_message == false
      flash[:error] = "网站被管理员禁止发送消息"
      return redirect_to root_path
    end
    
    @send_message = Message.new
  end
  
  def send_message_commit
    if $can_message == false
      flash[:error] = "网站被管理员禁止发送消息"
      return redirect_to root_path
    end
    
    @send_message = Message.new
    @send_message.message = params[:message][:message]
    @send_message.sender = @current_user
    @receiver = User.where(:username=>params[:message][:receiver]).take
    if @receiver == nil
      flash.now[:error] = "没有用户名为 #{params[:message][:receiver]} 的用户"
      return render 'send_message'
    end
    if @receiver == @current_user
      flash.now[:error] = "不能给自己发送消息"
      return render 'send_message'
    end
    @send_message.receiver = @receiver
    
    if @send_message.save
      flash[:success] = "发送成功"
      return redirect_to user_show_message_path(@send_message)
    else
      return render 'send_message'
    end
  end
  
  def show_message
    @message = @current_user.all_messages.includes(:sender,:receiver).find(params[:message_id])
    if @message.receiver == @current_user
      @message.read = true
      @message.save!
    end
    
    @send_message = Message.new
    @send_message.receiver = (@message.sender == @current_user ? @message.receiver : @message.sender)
  end
  
  def entries
    clac_page @current_user.entries.size, $entry_per_page
    
    @entries = @current_user.entries.limit($entry_per_page).offset(@offset)
  end
  
  def ranklist
    clac_page User.all.size, $user_per_page
    
    @users = User.order("solved_count DESC").limit($user_per_page).offset(@offset)
  end

end
