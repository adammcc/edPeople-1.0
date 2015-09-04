Ep::Application.routes.draw do

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks",
    registrations: "registrations",
    sessions: "sessions",
    passwords: "passwords"
  }

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
      put :remove_avatar
      put :add_resume
      put :remove_resume
      get :my_jobs
      get :refresh_progress
    end

    authenticate :user do
      resources :conversations do
        member do
          put :restore
        end
      end
    end

    resources :connections, only: [:index]
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

end
