Chirp::Application.routes.draw do

  get 'login' => 'sessions#new', :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'oauth' => 'sessions#create', :as => 'oauth'
  get 'callback' => 'users#new', :as => 'callback'

  root :to => "users#edit"

  resources :users
    match "/save/" => "users#update"
    
end
