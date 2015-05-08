class WelcomeController < ApplicationController
	def index
	  session[:test] = session[:test].to_i + 1
	  if session[:test] % 5 == 0
	    flash.now[:msg] = "message"
	  end
	end
end
