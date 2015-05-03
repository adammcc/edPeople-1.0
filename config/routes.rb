Ep::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks", registrations: "registrations" }

  devise_scope :user do
    authenticated :user do
      root :to => 'users#show', as: :authenticated_root
    end
    unauthenticated :user do
      root :to => 'devise/registrations#new'
    end
  end

  resources :users do
    get :autocomplete_college_name, :on => :collection
    member do
      put :add_avatar
      put :add_resume
      put :remove_resume
      get :add_password
      get :my_jobs
    end

    authenticate :user do
      resources :conversations
    end
  end

  resources :colleges, only: [:create]
  resources :college_infos, only: [:edit, :update, :destroy]
  resources :experiences, only: [:create, :edit, :update, :destroy]
  resources :skills, only: [:create, :destroy]
  resources :certs, only: [:create, :destroy]
  resources :roles, only: [:create, :destroy]
  resources :subjects, only: [:create, :destroy]
  resources :job_posts
  resources :messages
  resources :job_maps, only: [:index]
  resources :friendships, only: [:create, :update, :destroy]

  resources :orgs, only: [:show, :index, :update]

  get '/terms' => 'pages#terms', as: :terms
  get '/privacy_policy' => 'pages#privacy_policy', as: :privacy_policy


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
