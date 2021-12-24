Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "posts#index"

  resources :posts
  resources :user_sessions
  get "/login", to: "user_sessions#new", as: "login"
  get "/logout", to: "user_sessions#logout", as: "logout"
  get "/portfolio", to: "static_pages#portfolio", as: "portfolio"
  get "/impressum", to: "static_pages#impressum", as: "impressum"

  get "/:year/:month/:day/:slug", {
    constraints: {
      year:   /\d{4}/,
      month:  /\d{2}/,
      day:    /\d{2}/
    },
    to: redirect { |params, request|
      slug = params[:slug].sub /\.html$/, ''
      "/posts/#{slug}"
    }
  }
end
