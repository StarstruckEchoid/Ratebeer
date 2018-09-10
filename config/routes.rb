Rails.application.routes.draw do
  root 'breweries#index'
  get 'ratings', to: 'ratings#index'
  resources :beers
  resources :breweries
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end