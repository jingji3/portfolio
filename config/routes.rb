Rails.application.routes.draw do
  # letter_openerのセットアップ用
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # health check
  get "up" => "rails/health#show", as: :rails_health_check

  # トップページ
  root "top#index"

  # OAuthログインのルーティング
  post "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
  get "oauth/callback/:provider", to: "oauths#callback", as: :oauth_callback

  # ログイン、ログアウト
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"

  # ユーザー登録
  resources :users, only: %i[new create]

  # マイページ
  get "mypage", to: "mypage#index", as: :mypage
  # resource :mypage, only: %i[index], path: 'mypage', controller: 'mypage'

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
  resources :characters, only: %i[show]

  # リクエスト
  resources :requests, only: %i[new create]

  # 通知関連
  resources :notifications, only: [] do
    member do
      patch :mark_as_read
    end
  end

  # サイドバー切り替え用
  get "sidebar_mini", to: "application#sidebar_mini"
  get "sidebar_full", to: "application#sidebar_full"

  # static pages
  resources :static_pages, only: [] do
    collection do
      get :privacy_policy
      get :terms_of_use
      get :contact
    end
  end

  # admin page
  namespace :admin do
    get "/", to: "dashboard#index"
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

    resources :posts
    resources :teams
    resources :team_ratings
    resources :requests
    resources :comments

    root to: "dashboard#index"
  end
end
