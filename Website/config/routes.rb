Rails.application.routes.draw do
	root to: 'welcome#index'
	get '/user/login', to: 'user#login', as: 'user_login'
	post '/user/login', to: 'user#login_post'
	get '/user/register', to: 'user#register', as: 'user_register'
	post '/user/register', to: 'user#register_post'
	get '/user', to: 'user#my_info', as: 'user_my_info'
	get '/user/modify', to: 'user#modify', as: 'user_modify'
	post '/user/modify', to: 'user#modify_post'
	get '/user/messages', to: 'user#messages', as: 'user_messages'
	get '/user/logout', to: 'user#logout', as: 'user_logout'
	get '/user/entries', to: 'user#entries', as: 'user_entries'
end
