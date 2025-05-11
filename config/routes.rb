Rails.application.routes.draw do
  # letter_openerのセットアップ用
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # admin用
  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :users do
      member do
        post :activate
        post :deactivate
      end
    end

    resources :characters do
      member do
        post :compress
      end
    end

    root to: 'dashboard#index'
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
  root 'top#index'

  # ユーザー登録
  resources :users, only: %i[new create]

  # OAuthログインのプロセル
  post 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
  get 'oauth/callback/:provider', to: 'oauths#callback', as: :oauth_callback

  # プロフィール編集
  resource :profile, only: %i[show edit update]

  # パスワードリセット機能
  resources :password_resets, only: %i[new create edit update]

  # 投稿機能
  resources :posts, only: %i[index show edit new create destroy update] do
    resources :comments, only: %i[create edit update destroy], shallow: true do
      resource :comment_likes, only: %i[create destroy]
      member do
        get :cancel
      end
    end
    resource :likes, only: %i[create destroy]
    resource :favorites, only: %i[create destroy]
    collection do
      get :favorites
    end
  end
  # 編成評価機能
  resources :team_ratings, only: %i[index show edit new create destroy update]

  # 編成一覧機能
  resources :teams, only: %i[index show]

  # キャラクター
  resources :characters

  # プライバシポリシー、利用規約
  get 'privacy', to: 'static_pages#privacy_policy', as: :privacy_policy
  get 'terms', to: 'static_pages#terms_of_use', as: :terms_of_use

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
