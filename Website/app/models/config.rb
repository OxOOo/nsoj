class Config < ActiveRecord::Base
  validates_presence_of :name, message: "配置名称不能为空"
  validates_length_of :name, in: 1..40, message: "配置名称长度不能超过40"
  validates_presence_of :description, message: "配置描述不能为空"
  validates_length_of :description, in: 1..90, message: "配置描述长度不能超过90"
  
  after_save do
    Config.flash
  end
  
  def Config.flash
    $config_load = true
  
    $can_login = Config.where(:name=>"can_login").take.value != nil if Config.where(:name=>"can_login").exists?
    $can_register = Config.where(:name=>"can_register").take.value != nil if Config.where(:name=>"can_register").exists?
    $can_submit = Config.where(:name=>"can_submit").take.value != nil if Config.where(:name=>"can_submit").exists?
    $can_blog = Config.where(:name=>"can_blog").take.value != nil if Config.where(:name=>"can_blog").exists?
    $can_message = Config.where(:name=>"can_message").take.value != nil if Config.where(:name=>"can_message").exists?
    $root_only = Config.where(:name=>"root_only").take.value != nil if Config.where(:name=>"root_only").exists?
    
    $token = Config.where(:name=>"token").take.value if Config.where(:name=>"token").exists?
    
    $user_per_page = Config.where(:name=>"user_per_page").take.value.to_i if Config.where(:name=>"user_per_page").exists?
    $problem_per_page = Config.where(:name=>"problem_per_page").take.value.to_i if Config.where(:name=>"problem_per_page").exists?
    $contest_per_page = Config.where(:name=>"contest_per_page").take.value.to_i if Config.where(:name=>"contest_per_page").exists?
    $status_per_page = Config.where(:name=>"status_per_page").take.value.to_i if Config.where(:name=>"status_per_page").exists?
    $blog_per_page = Config.where(:name=>"blog_per_page").take.value.to_i if Config.where(:name=>"blog_per_page").exists?
    $message_per_page = Config.where(:name=>"message_per_page").take.value.to_i if Config.where(:name=>"message_per_page").exists?
    $entry_per_page = Config.where(:name=>"entry_per_page").take.value.to_i if Config.where(:name=>"entry_per_page").exists?
    $small_entry_number = Config.where(:name=>"small_entry_number").take.value.to_i if Config.where(:name=>"small_entry_number").exists?
    $timeout_seconds = Config.where(:name=>"timeout_seconds").take.value.to_i if Config.where(:name=>"timeout_seconds").exists?
    $keep_entry_days = Config.where(:name=>"keep_entry_days").take.value.to_i if Config.where(:name=>"keep_entry_days").exists?
    $page_range = Config.where(:name=>"page_range").take.value.to_i if Config.where(:name=>"page_range").exists?
  end
  
end
