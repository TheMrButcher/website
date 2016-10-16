Rails.application.routes.draw do
  namespace :private do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    
    resources :users
    
    resources :folders, only: [:create]
    
    get 'roots', to: 'folders#index'
    get 'roots/new', to: 'folders#new'
    
    get 'files/*id', to: 'folders#show', as: 'files'
  end
end
