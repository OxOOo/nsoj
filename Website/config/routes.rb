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
  get 'help' => 'welcome#help', as: :help
  
  get 'problems/new' => 'problem#new', as: :problem_new
  post 'problems/new/problem/:problem_id' => 'problem#new_problem', as: :problem_new_problem_commit
  post 'problems/new/:online_judge_id' => 'problem#new_vjudge', as: :problem_new_vjudge_commit
  post 'problems/changeOJ/:online_judge_id' => 'problem#changeOJ', as: :problem_changeOJ
  get 'problems/edit/:problem_id' => 'problem#edit', as: :problem_edit
  post 'problems/vjudge/:problem_id' => 'problem#edit_vjudge_commit', as: :problem_edit_vjudge
  post 'problems/local/:problem_id' => 'problem#edit_local_commit', as: :problem_edit_local
  get 'problems/local/:problem_id/description' => 'problem#edit_description', as: :problem_edit_description
  post 'problems/local/:problem_id/description' => 'problem#edit_description_commit'
  get 'problems/local/:problem_id/judge' => 'problem#edit_judge', as: :problem_edit_judge
  post 'problems/local/:problem_id/judge' => 'problem#edit_judge_commit'
  get 'problems/:page' => 'problem#index', as: :problem_index
  get 'problem/:problem_id' => 'problem#single', as: :problem_single
  post 'problem/:problem_id' => 'problem#submit'
  
  get 'contests/:page' => 'contest#index', as: :contest_index
  
  get 'blogs/person/:user_id/:page' => 'blog#person', as: :blog_person
  get 'blogs/new' => 'blog#new_blog', as: :blog_new_blog
  post 'blogs/new' => 'blog#new_blog_commit'
  get 'blogs/:page' => 'blog#index', as: :blog_index
  get 'blogs/single/:blog_id' => 'blog#single', as: :blog_single
  get 'blogs/edit/:blog_id' => 'blog#edit', as: :blog_edit
  post 'blogs/edit/:blog_id' => 'blog#edit_commit'
  get 'blogs/delete/:blog_id' => 'blog#delete', as: :blog_delete
  post 'blogs/delete/:blog_id' => 'blog#delete_commit'
  get 'blogs/top/:blog_id' => 'blog#top', as: :blog_top
  post 'blogs/top/:blog_id' => 'blog#top_commit'
  get 'blogs/untop/:blog_id' => 'blog#untop', as: :blog_untop
  post 'blogs/untop/:blog_id' => 'blog#untop_commit'
  
  get 'status/:page' => 'status#index', as: :status_index
  
  get 'user/ranklist/:page' => 'user#ranklist', as: :user_ranklist
  get 'user/login' => 'user#login', as: :user_login
  post 'user/login' => 'user#login_commit'
  get 'user/register' => 'user#register', as: :user_register
  post 'user/register' => 'user#register_commit'
  get 'user/datum/:user_id' => 'user#datum', as: :user_datum
  get 'user/modify' => 'user#modify', as: :user_modify
  post 'user/modify/password' => 'user#modify_password', as: :user_modify_password
  post 'user/modify/datum' => 'user#modify_datum', as: :user_modify_datum
  get 'user/logout' => 'user#logout', as: :user_logout
  get 'user/messages/:page' => 'user#messages', as: :user_messages
  get 'user/message/:message_id' => 'user#show_message', as: :user_show_message
  get 'user/send_message' => 'user#send_message', as: :user_send_message
  post 'user/send_message' => 'user#send_message_commit'
  get 'user/entries/:page' => 'user#entries', as: :user_entries
end
