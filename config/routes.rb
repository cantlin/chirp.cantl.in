Chirp::Application.routes.draw do
  
  root :to => "home#show"
 
  resources :sessions
    match '/login',  :to => 'sessions#new'
    match '/logout', :to => 'sessions#destroy'
    match '/callback', :to => 'sessions#callback'
    
end
