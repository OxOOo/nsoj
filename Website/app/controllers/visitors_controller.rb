class VisitorsController < ApplicationController
	def index
		@html = '<a href="http://www.baidu.com">baidu</a><br/>'+
			'<script>alert("233");</script>'+
			'<img src="http://www.baidu.com/img/baidu_jgylogo3.gif?v=19576207.gif"/>'
	end
end
