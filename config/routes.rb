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
  # ユーザー登録
  resources :users, only: %i[new create]
  # プロフィール編集
  resource :profile, only: %i[show edit update]
  # 投稿機能
  resources :posts, only: %i[index show edit new create destroy update] do
    resource :likes, only: %i[create destroy]
  end
  # キャラクター
  resources :characters

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
