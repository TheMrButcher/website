Rails.application.routes.draw do
  namespace :private do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    resources :users
    resources :folders, only: [:create, :update]
    resources :panoramas, only: [:create, :update, :destroy]
    
    resources :panoramas do
      resources :pano_versions, only: [:create]
    end
    resources :pano_versions, only: [:update, :destroy]
    
    get 'roots', to: 'folders#index'
    get 'roots/new', to: 'folders#new'
    
    get 'files/*id', to: 'folders#show', as: 'files'
    get 'pano/*id/version/:version/images/:image_name', to: 'panoramas#image'
    get 'pano/*id/images/:image_name', to: 'panoramas#image'
    get 'pano/*id/version/:version', to: 'panoramas#show', as: 'show_pano_version'
    get 'pano/*id', to: 'panoramas#show', as: 'show_pano'
    get 'data/*id', to: 'data#show', as: 'show_datum'
  end
end
