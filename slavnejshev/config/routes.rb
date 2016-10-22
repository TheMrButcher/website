Rails.application.routes.draw do
  namespace :private do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    
    resources :users
    resources :folders, only: [:create]
    resources :panoramas, only: [:create]
    
    resources :panoramas do
      resources :pano_versions, only: [:create]      
    end
    
    get 'roots', to: 'folders#index'
    get 'roots/new', to: 'folders#new'
    
    get 'files/*id', to: 'folders#show', as: 'files'
    get 'pano/*id/version/:version', to: 'panoramas#show', as: 'show_pano_version'
    get 'pano/*id', to: 'panoramas#show', as: 'show_pano'
  end
end
