Rails.application.routes.draw do
  namespace :private do
    get 'login', to: 'sessions#new'
    resources :users, only: [:index, :show, :edit, :update ]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
