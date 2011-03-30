Chirp::Application.routes.draw do

  get 'login' => 'sessions#new', :as => 'log_in'
  get 'logout' => 'sessions#destroy', :as => 'log_out'
  get 'callback' => 'users#new', :as => 'callback'

  root :to => "users#update"

  resources :sessions, :only => [:new, :create, :destroy]
  resources :users
    match "/users/update/" => "users#update"
    
end
