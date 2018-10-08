Rails.application.routes.draw do
  resources :styles
  resources :memberships
  resources :beer_clubs
  root 'breweries#index'
  get 'places', to: 'places#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  post 'places', to:'places#search'
  delete 'signout', to: 'sessions#destroy'
  resource :session, only: [:new, :create, :destroy]
  resources :users do
    post 'toggle_banned', on: :member
  end
  resources :users
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :breweries
  resources :places, only: [:index, :show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end