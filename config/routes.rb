Chirp::Application.routes.draw do

  get 'login' => 'sessions#new', :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'oauth' => 'sessions#create', :as => 'oauth'
  get 'callback' => 'users#new', :as => 'callback'
  post 'search' => 'searches#new', :as => 'search'
  get 'foo' => 'users#foo', :as => 'foo'

  resources :users, :only => [:new, :edit] do
    member do
      post 'follow'
      post 'unfollow'
    end
  end

  root :to => "users#edit"
    
end
