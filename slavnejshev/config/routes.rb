Rails.application.routes.draw do
  namespace :private do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    resources :users
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
