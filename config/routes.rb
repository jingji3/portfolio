Rails.application.routes.draw do
  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :users do
      member do
        post :activate
        post :deactivate
      end
    end

    resources :characters

      root to: "dashboard#index"
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root "top#index"
  resources :users, only: %i[new create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
