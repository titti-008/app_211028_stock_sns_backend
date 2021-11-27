Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "hello_world", to: "application#hello_world"

  root to: redirect(ENV["FRONT_END_URL"])

  

  get "/home", to: "application#home"
  namespace :api do
    namespace :v1 do

      post "/login", to: "sessions#login"
      delete "/logout", to:"sessions#logout"
      get "/logged_in", to:"sessions#logged_in?"

      resources :users do
        member do
          get :following, :followers
        end
      end

      resources :account_activations, only: [:edit]
      resources :password_resets, only: [:create, :update]
      resources :relationships, only: [:create, :destroy, :show]
      resources :microposts, only: [:show, :create, :destroy]
      get "/microposts/myfeed/:page", to:"microposts#myfeed"
      get "/microposts/:user_id/:page", to:"microposts#user_show"
      

    end
  end
end
