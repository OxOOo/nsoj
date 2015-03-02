Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  root 'welcome#index'
  get 'help' => 'welcome#help', as: 'help'
  post 'help' => 'welcome#post'
  
  get 'problems' => 'problems#index', as: 'problems_index'
  get 'problems/:problem_id' => 'problems#single', as: 'problems_single'
  post 'problems/:problem_id' => 'problems#single_submit'
  get 'problems/append/:problem_type' => 'problems#append', as: 'problems_append'
  get 'problems/:problem_id/edit' => 'problems#edit', as: 'problems_edit'
  patch 'problems/:problem_id/edit' => 'problems#edit_submit'
  get 'problems/:problem_id/edit/description' => 'problems#edit_description', as: 'problems_edit_description'
  patch 'problems/:problem_id/edit/description' => 'problems#edit_description_submit'
  get 'problems/:problem_id/edit/judge' => 'problems#edit_judge', as: 'problems_edit_judge'
  patch 'problems/:problem_id/edit/judge' => 'problems#edit_judge_submit'
  
  get 'status' => 'status#index', as: 'status_index'
  get 'status/:status_id' => 'status#single', as: 'status_single'
  get 'status/:status_id/rejudge' => 'status#rejudge', as: 'status_rejudge'
  
  get 'users/login' => 'users#login', as: 'users_login'
  post 'users/login' => 'users#login_submit'
  get 'users/logout' => 'users#logout', as: 'users_logout'
  get 'users/register' => 'users#register', as: 'users_register'
  post 'users/register' => 'users#register_submit'
  get 'users/edit' => 'users#edit', as: 'users_edit'
  patch 'users/edit' => 'users#edit_submit'
  
  get 'judger/get_waiting_status' => 'judger#get_waiting_status', as: 'judger_get_waiting_status'
  get 'judger/get_status_submit/:status_id' => 'judger#get_status_submit', as: 'judger_get_status_submit'
  get 'judger/get_status_submit_zip/:status_id/:index' => 'judger#get_status_submit_zip', as: 'judger_get_status_submit_zip'
  get 'judger/get_problem_info/:problem_id' => 'judger#get_problem_info', as: 'judger_get_problem_info'
  get 'judger/get_problem_spj/:problem_id' => 'judger#get_problem_spj', as: 'judger_get_problem_spj'
  get 'judger/get_problem_front/:problem_id' => 'judger#get_problem_front', as: 'judger_get_problem_front'
  get 'judger/get_problem_back/:problem_id' => 'judger#get_problem_back', as: 'judger_get_problem_back'
  get 'judger/get_problem_input/:problem_id/:index' => 'judger#get_problem_input', as: 'judger_get_problem_input'
  get 'judger/get_problem_output/:problem_id/:index' => 'judger#get_problem_output', as: 'judger_get_problem_output'
  post 'judger/update_status_info/:status_id' => 'judger#update_status_info', as: 'judger_update_status_info'
  post 'judger/update_status_ce/:status_id' => 'judger#update_status_ce', as: 'judger_update_status_ce'
  post 'judger/update_status_result/:status_id' => 'judger#update_status_result', as: 'judger_update_status_result'
end
