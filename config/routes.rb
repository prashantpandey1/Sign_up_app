Rails.application.routes.draw do

  root 'static_pages#home'
  get 'sessions/new'
  get 'about' => 'static_pages#about'
  get 'home' => 'static_pages#home'
  get 'help' => 'static_pages#help'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  delete 'logout' => 'users#destroy'
  resources :users

end
