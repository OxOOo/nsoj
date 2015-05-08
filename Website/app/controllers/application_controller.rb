class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action do
    #root only
    if $root_only && request.path != root_path
      flash[:error] = "网站被管理员限制只能访问主页"
      return redirect_to root_path
    end
    
    #载入Config
    Contest.load_hide_problem_ids if not $hide_problem_ids
    Config.flash if not $config_load
  
    #计数
    @real_path = request.path.gsub(/\/\d+/, '/:id')
    PageNumberCounter.count(@real_path)
  
    #检查IP是否被禁
    if BannedIp.active.where(:banned_ip=>request.remote_ip).exists?
      deadline = BannedIp.active.where(:banned_ip=>request.remote_ip).order("deadline desc").first.deadline
			flash.now[:error] = "你的IP #{request.remote_ip} 被管理员禁止在 #{format_datetime(deadline)} 前访问本网站，请与管理员联系"
			return render 'welcome/index'
		end
		
		if session[:current_user_id] != nil && User.where(:id=>session[:current_user_id]).exists?
			@current_user = User.find(session[:current_user_id])
		end
		if @current_user != nil && (@current_user.last_online == nil || Time.now - @current_user.last_online > $timeout_seconds)
		  @current_user = nil
		  session[:current_user_id] = nil
		end
		if @current_user != nil && @current_user.access != nil && @current_user.access.is_root == true && request.remote_ip != "127.0.0.1"
			flash.now[:error] = "具有root权限的用户只能在服务器上登录"
			@current_user = nil
			session[:current_user_id] = nil
			return render 'welcome/index'
		end
		
		#检查当前用户是否被禁
		if @current_user != nil && BannedId.active.where(:banned=>@current_user).exists?
		  deadline = BannedId.active.where(:banned=>@current_user).order("deadline desc").first.deadline
			flash.now[:error] = "#{@current_user.username} 被管理员禁止在 #{format_datetime(deadline)} 前登录本网站，请与管理员联系"
			@current_user = nil
			session[:current_user_id] = nil
			return render 'welcome/index'
		end
		
		if @current_user != nil
		  @current_user.last_online = Time.now
		  @current_user.save!
		  @current_user.access = Access.new if @current_user.access == nil
		end
  end
  
  protected
    def check_logout
      @current_user = nil
			session[:current_user_id] = nil
		end
		
		def check_login
      if @current_user == nil
  			flash[:warning] = "请先登录或注册"
  			return redirect_to user_login_path
  		end
		end
		
		def clac_page(total_number, per_number)
		  @total_page = (total_number + per_number - 1) / per_number
      @total_page = 1 if @total_page < 1
      @current_page = params[:page] == nil ? 1 : params[:page].to_i
      @current_page = @total_page if @current_page > @total_page
      @current_page = 1 if @current_page < 1
      @offset = (@current_page - 1) * per_number
		end
end
