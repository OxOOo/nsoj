module ApplicationHelper
	def format_time(time)
		time.strftime("%Y年%m月%d日 %H:%M:%S")
	end
	
	def friendly_time(time,unit=0)
		units = ['MS','S']
		while unit < units.size - 1 do
   		if time >= 1000.0
   			time /= 1000.0
   			unit += 1
   		else
   			break
   		end
		end
		return time.round(2).to_s + ' ' + units[unit]
	end
	
	def friendly_memory(memory,unit=1)
		units = ['B','KB','MB','G']
		while unit < units.size - 1 do
   		if memory >= 1024.0
   			memory /= 1024.0
   			unit += 1
   		else
   			break
   		end
		end
		return memory.round(2).to_s + ' ' + units[unit]
	end
	
	def friendly_duration(duration)
		duration = duration.round(0)
		second = duration % 60
		duration /= 60
		minute = duration % 60
		duration /= 60
		hour = duration % 24
		duration /= 24
		day = duration
		
		str = ""
		if day != 0
			str += day.to_s + "天"
		end
		if hour != 0
			str += hour.to_s + "小时"
		end
		if minute != 0
			str += minute.to_s + "分钟"
		end
		if second != 0
			str += second.to_s + "秒"
		end
		if str == ""
			str = "零持续时间"
		end
		return str
	end
end
