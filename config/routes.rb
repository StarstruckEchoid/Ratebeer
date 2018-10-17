Rails.application.routes.draw do
  root 'breweries#index'
  #Styles
  resources :styles
  #Memberships
  resources :memberships do
    post 'confirm', on: :member
  end
  #Beer Clubs
  resources :beer_clubs
  #Sessions
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  get 'auth/:provider/callback', to: 'sessions#create_oauth', as:'auth'
  resource :session, only: [:new, :create, :destroy]
  #Users
  resources :users do
    post 'toggle_banned', on: :member
  end
  get 'signup', to: 'users#new'
  #Ratings
  resources :ratings, only: [:index, :new, :create, :destroy]
  #Beers
  resources :beers
  get 'beerlist', to: 'beers#list'
  #Breweries
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  get 'brewerylist', to: 'breweries#list'
  #Places
  resources :places, only: [:index, :show]
  get 'places', to: 'places#index'
  post 'places', to:'places#search'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end