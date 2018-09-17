Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  root 'breweries#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  resource :session, only: [:new, :create, :destroy]
  resources :users
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :beers
  resources :breweries
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end