Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "posts#index"

  resources :posts
  resources :user_sessions
  get "/login", to: "user_sessions#new", as: "login"
  get "/logout", to: "user_sessions#logout", as: "logout"
end
