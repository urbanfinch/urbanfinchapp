Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  namespace :account do
    root :to => 'account#edit'
    resource :account, :only => [:edit, :update], :controller => :account do
      member do
        get 'regenerate'
      end
    end
    resources :users
  end

  namespace :content do
    root :to => 'albums#index'
    resources :albums
    resources :blurbs
    resources :employees
    resources :lists
    resources :maps
    resources :navs
    resources :posts
    resources :testimonials
  end

  namespace :dashboard do
    root :to => 'overview#index'
    get 'overview' => 'overview#index'
    resources :activities, :only => [:index]
  end

  get 'login' => 'authentication#login'
  post 'login' => 'authentication#login_create'
  get 'logout' => 'authentication#login_destroy'
  get 'recover' => 'authentication#recover'
  post 'recover' => 'authentication#recover_process'
  get 'reset' => 'authentication#reset'
  post 'reset' => 'authentication#reset_process'

  root :to => 'dashboard/overview#index'
  #match '*path', :to => 'dashboard/overview#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
