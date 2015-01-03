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
end
