class ProblemController < ApplicationController
  before_action :check_login, only: [:submit, :new, :new_problem, :new_vjudge, :edit, :edit_vjudge_commit,
        :edit_local_commit, :edit_description, :edit_description_commit, :edit_judge, :edit_judge_commit]
  before_action { @problem = Problem.find(params[:problem_id]) if params[:problem_id] }
  before_action :check_new_problem_access, only: [:new, :new_problem, :new_vjudge]
  before_action :check_edit_problem_access, only: [:edit, :edit_vjudge_commit,:edit_local_commit, :edit_description, 
        :edit_description_commit, :edit_judge, :edit_judge_commit]

  before_action do
    session[:online_judge_id] = 0 if session[:online_judge_id] == nil
    @online_judge = nil
    @online_judge = OnlineJudge::List[session[:online_judge_id] - 1] if OnlineJudge::List.ids.include?(session[:online_judge_id])
  end

  def index
    if @current_user != nil
      if @current_user.access.is_admin || @current_user.access.can_modify_problem
        @problems = Problem.all
      elsif @current_user.access.can_add_problem
        @problems = Problem.where("hide == ? OR user_id == ?", false, @current_user.id)
        @problems = @problems.where("id NOT IN (?)", $hide_problem_ids) if not $hide_problem_ids.empty?
      end
    else
      @problems = Problem.where("hide == ?", false)
      @problems = @problems.where("id NOT IN (?)", $hide_problem_ids) if not $hide_problem_ids.empty?
    end
    @problems = @problems.where(:online_judge=>@online_judge) if @online_judge
    @extra_url = []
    if params[:id] && /\S+/.match(params[:id])
      @problems = @problems.where("origin_id LIKE ?", "%"+params[:id]+"%")
      @extra_url << "id=#{params[:id]}"
    end
    if params[:name] && /\S+/.match(params[:name])
      @problems = @problems.where("name LIKE ?", "%"+params[:name]+"%")
      @extra_url << "name=#{params[:name]}"
    end
    @extra_url = @extra_url.join("&")
    
    clac_page @problems.size, $problem_per_page
    
    @problems = @problems.limit($problem_per_page).offset(@offset).includes(:online_judge)
  end
  
  def changeOJ
    online_judge_id = params[:online_judge_id].to_i
    if online_judge_id != 0 && OnlineJudge::List.ids.include?(online_judge_id) == false
      flash[:warning] = "非法操作"
    else
      session[:online_judge_id] = online_judge_id
    end
    return redirect_to :back
  end
  
  def single
  end
  
  #----------------------------------------
  def submit
  end
  
  def new
  end
  
  def new_problem
    return redirect_to problem_edit_path(@problem.new_problem)
  end
  
  def new_vjudge
    online_judge_id = params[:online_judge_id].to_i
    if not OnlineJudge::VJudgeList.ids.include?(online_judge_id)
      flash[:error] = "操作错误"
      return redirect_to root_path
    end
    
    @problem = Problem.new
    @problem.user = @current_user
    @problem.online_judge_id = online_judge_id
    @problem.problem_type = ProblemType::VJudge
    @problem.name = "未知"
    @problem.answer_limit = 100 * 1024
    @problem.origin_id = @problem.online_judge.default
    @problem.save!
    return redirect_to problem_edit_path(@problem)
  end
  
  def edit
    return render 'local_edit' if @problem.online_judge == OnlineJudge::Local
    return render 'vjudge_edit'
  end
  
  def edit_vjudge_commit
    
    if @problem.update(params[:problem].permit(:origin_id, :answer_limit, :hide, :submit, :hint))
      @problem.update!(:task=>false)
      flash[:success] = "修改成功"
      return redirect_to problem_single_path(@problem)
    end
    return render 'vjudge_edit'
  end
  
  def edit_local_commit
    if not ProblemType::LocalList.ids.include?(params[:problem][:problem_type].to_i)
      flash[:error] = "非法操作！"
      return redirect_to root_path
    end
    
		if @problem.update(params[:problem].permit(:name,:time_limit,:memory_limit,:test_count,:hide)) &&
		    @problem.update(:problem_type_id =>params[:problem][:problem_type].to_i)
			flash[:success] = "修改成功"
			return redirect_to problem_edit_description_path(@problem)
		else
			return render 'local_edit'
		end
  end
  
  def edit_description
  end
  
  def edit_description_commit
    @problem.description = params[:problem][:description]
		flash[:success] = "修改成功"
		return redirect_to problem_edit_judge_path(@problem)
  end
  
  def edit_judge
  end
  
  def edit_judge_commit
    if @problem.update(params[:problem].permit(:answer_limit, :submit)) == false
			return render :edit_judge
		end
		if params[:problem][:data]
		  dataset = @problem.set_data(params[:problem][:data])
		  flash[:info] = "上传的数据有 #{dataset.join(',')} 组"
		end
		if @problem.problem_type == ProblemType::NormalSpj || @problem.problem_type == ProblemType::SubmitAnswer
			@problem.spj = params[:problem][:spj]
		end
		if @problem.problem_type == ProblemType::Interaction
			@problem.front = params[:problem][:front]
			@problem.back = params[:problem][:back]
		end
		return redirect_to problem_single_path(@problem)
  end
  
  private
    def check_new_problem_access
      if @current_user.access.can_add_problem != true && @current_user.access.can_modify_problem != true
        flash[:error] = "你没有添加题目的权限"
        return redirect_to root_path
      end
    end
    
    def check_edit_problem_access
      if @current_user.access.can_modify_problem != true && (@current_user.access.can_add_problem && @problem.user == @current_user) != true
        flash[:error] = "你没有修改本题的权限"
        return redirect_to root_path
      end
    end

end
