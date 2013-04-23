Zinc::Application.routes.draw do

  resources :rooms


  resources :user_sessions
  resources :users

  get "logout" => "user_sessions#destroy", :as => "logout"
  get "login"  => "user_sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"

  root :to => 'pages#landing'
end
