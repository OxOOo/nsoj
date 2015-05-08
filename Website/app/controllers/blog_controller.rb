class BlogController < ApplicationController
  
  before_action :check_login, only: [:new_blog, :new_blog_commit, :top, :top_commit, :edit, :edit_commit,
      :delete, :delete_commit, :untop, :untop_commit]

  def index
    clac_page Blog.all.size, $blog_per_page
    
    @notices = Blog.notice
    @blogs = Blog.normal.limit($blog_per_page).offset(@offset)
  end
  
  def new_blog
    if $can_blog != true
      flash[:error] = "本网站被管理员禁止发表博客"
      return redirect_to root_path
    end
    
    @blog = Blog.new
  end
  
  def new_blog_commit
    if $can_blog != true
      flash[:error] = "本网站被管理员禁止发表博客"
      return redirect_to root_path
    end
    
    @blog = Blog.new(params[:blog].permit(:title, :body))
    @blog.user = @current_user
    if @blog.save
      flash[:success] = "发表成功"
      return redirect_to blog_single_path(@blog)
    else
      return render 'new_blog'
    end
  end
  
  def person
    @user = User.find(params[:user_id])
    clac_page @user.blogs.size, $blog_per_page
    
    @blogs = @user.blogs.limit($blog_per_page).offset(@offset);
  end
  
  def single
    @blog = Blog.find(params[:blog_id])
  end
  
  def top
    @blog = Blog.find(params[:blog_id])
    if @current_user.access.is_admin != true
      flash[:error] = "你没有置顶博客的权限"
      return redirect_to blog_single_path(@blog)
    end
  end
  
  def top_commit
    @blog = Blog.find(params[:blog_id])
    if @current_user.access.is_admin != true
      flash[:error] = "你没有置顶博客的权限"
      return redirect_to blog_single_path(@blog)
    end
    
    @blog.top = Time.now
    @blog.save!
    flash[:success] = "置顶成功"
    return redirect_to blog_single_path(@blog)
  end
  
  def untop
    @blog = Blog.find(params[:blog_id])
    if @current_user.access.is_admin != true
      flash[:error] = "你没有取消置顶博客的权限"
      return redirect_to blog_single_path(@blog)
    end
  end
  
  def untop_commit
    @blog = Blog.find(params[:blog_id])
    if @current_user.access.is_admin != true
      flash[:error] = "你没有取消置顶博客的权限"
      return redirect_to blog_single_path(@blog)
    end
    
    @blog.top = nil
    @blog.save!
    flash[:success] = "取消置顶成功"
    return redirect_to blog_single_path(@blog)
  end
  
  def edit
    @blog = Blog.find(params[:blog_id])
    if @current_user.access.is_admin != true && @current_user != @blog.user
      flash[:error] = "你没有修改本博客的权限"
      return redirect_to blog_single_path(@blog)
    end
  end
  
  def edit_commit
    @blog = Blog.find(params[:blog_id])
    if @current_user.access.is_admin != true && @current_user != @blog.user
      flash[:error] = "你没有修改本博客的权限"
      return redirect_to blog_single_path(@blog)
    end
    
    if @blog.update(params[:blog].permit(:title, :body))
      flash[:success] = "修改成功"
      return redirect_to blog_single_path(@blog)
    else
      return render 'edit'
    end
  end
  
  def delete
    @blog = Blog.find(params[:blog_id])
    if @current_user.access.is_admin != true && @current_user != @blog.user
      flash[:error] = "你没有删除本博客的权限"
      return redirect_to blog_single_path(@blog)
    end
  end
  
  def delete_commit
    @blog = Blog.find(params[:blog_id])
    if @current_user.access.is_admin != true && @current_user != @blog.user
      flash[:error] = "你没有删除本博客的权限"
      return redirect_to blog_single_path(@blog)
    end
    
    @blog.destroy
    flash[:success] = "删除成功"
    return redirect_to blog_index_path(1)
  end

end
