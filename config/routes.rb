Rails
  .application
  .routes
  .draw do
    resources :memberships
    resources :beer_clubs
    resources :users
    resources :beers
    resources :breweries
    resources :ratings, only: %i[index new create destroy]

    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    resource :session, only: %i[new create destroy]

    root "breweries#index" # Defines the root path route ("/")

    get "signup", to: "users#new"
    get "signin", to: "sessions#new"
    delete "signout", to: "sessions#destroy"
    get "places", to: "places#index"
    post "places", to: "places#search"
  end
