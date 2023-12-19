Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resource :session, only: [:new, :create, :destroy]

  root "breweries#index" # Defines the root path route ("/")

  get "signup", to: "users#new"
  get "signin", to: "sessions#new"
  delete "signout", to: "sessions#destroy"
end
