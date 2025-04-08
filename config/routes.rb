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
  # ユーザー投稿
  resources :users, only: %i[new create]
  # 投稿機能
  resources :posts
  # キャラクター
  resources :characters

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
