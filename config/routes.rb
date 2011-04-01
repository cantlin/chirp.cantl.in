Chirp::Application.routes.draw do

  get 'login' => 'sessions#new', :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'oauth' => 'sessions#create', :as => 'oauth'
  get 'callback' => 'users#new', :as => 'callback'
  post 'search' => 'searches#new', :as => 'search'

  root :to => "users#edit"

  resources :users
    match "/save/" => "users#update"

  resources :searches
    match "/search/" => "searches#new"
    
end
