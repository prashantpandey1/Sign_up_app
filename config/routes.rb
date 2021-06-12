Rails.application.routes.draw do

  get 'password_resets/new'
  get 'password_resets/edit'
  get 'account_activations/edit'
  root 'static_pages#home'
  get 'sessions/new'
  get 'about' => 'static_pages#about'
  get 'home' => 'static_pages#home'
  get 'help' => 'static_pages#help'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  get '/users/:id', to: 'users#destroy'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
end
