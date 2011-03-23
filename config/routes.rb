Chirp::Application.routes.draw do
  
  root :to => "home#show"
 
  resources :sessions, :only => [:new, :create, :destroy]
    match '/login',  :to => 'sessions#new'
    match '/logout', :to => 'sessions#destroy'
    match '/callback', :to => 'sessions#callback'
    
end
