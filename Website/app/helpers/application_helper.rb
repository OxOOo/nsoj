module ApplicationHelper
  def display_code(code)
		return code.gsub('\t','    ')
	end
	
	def display_friendly_time(time)
		time = time.to_f
		return "#{time}ms" if  time < 1000
		return "#{time/1000}s"
	end
	
	def display_friendly_memory(memory)
		memory = memory.to_f
		return "#{memory}B" if memory < 1024
		return "#{memory/1024}KB" if memory < 1024 * 1024
		return "#{memory/1024/1024}MB" if memory < 1024 * 1024 * 1024
		return "#{memory/1024/1024/1024}GB"
	end

  def format_datetime(datetime)
    return datetime.strftime("%Y-%m-%d %H:%M:%S")
  end
  
  def max(a, b)
    return a > b ? a : b
  end
  
  def min(a, b)
    return a > b ? b : a
  end
  
  def pagination(hash)
    current_page = hash[:current_page]
    total_page = hash[:total_page]
    if false && total_page <= 1
      return
    end
    
    html = []
    html << '<div class="text-center">'
    html << '<nav>'
    html << '<ul class="pagination">'
    html << '<li>'
    html << link_to(yield(1)){raw '<span aria-hidden="true">首页</span>'}
    html << '</li>'
    (max(1,current_page-$page_range)..min(total_page,current_page+$page_range)).each do |page|
      html << "<li class=#{ "active" if page == current_page } >"
      html << link_to(page, yield(page))
      html << '</li>'
    end
    html << '<li>'
    html << link_to(yield(total_page)){raw '<span aria-hidden="true">尾页</span>' }
    html << '</li>'
    html << '</ul>'
    html << '</nav>'
    html << '</div>'
    
    raw html.join("\n")
  end

end
