Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check
  root "top#index"
  resources :users, only: %i[new create]
  get 'login', to: 'user_session#new'
  post 'login', to: 'user_session#create'
end
