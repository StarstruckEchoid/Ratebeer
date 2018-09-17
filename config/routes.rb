Rails.application.routes.draw do
  root 'breweries#index'
  get 'signup', to: 'users#new'
  resource :session, only: [:new, :create, :destroy]
  resources :users
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :beers
  resources :breweries
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end