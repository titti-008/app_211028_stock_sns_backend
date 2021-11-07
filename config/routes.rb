Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "hello_world", to: "application#hello_world"

  if Rails.env == "production"
    root to: redirect("https://app-211028-react-frontend.herokuapp.com/static_pages/home")
  else
    root to: redirect("http://localhost:3000/static_pages/home")
  end
  

  get "/home", to: "application#home"
  namespace :api do
    namespace :v1 do

      post "/login", to: "sessions#login"
      delete "/logout", to:"sessions#logout"
      get "/logged_in", to:"sessions#logged_in?"

      resources :users, only: %i[index show new create update destroy]

    end
  end
end
