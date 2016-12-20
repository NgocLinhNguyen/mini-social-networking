Rails.application.routes.draw do
  root "sessions#new"

  get "home", to: "home#index"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "signup", to: "users#new"
  resources :users do
    resources :posts do
      resources :comments
    end
    resources :groups, only: :index
  end

  resources :likes
  resources :posts

  resources :groups do
    resources :posts do
      resources :comments
    end
  end

  resources :user_groups
  resources :friends, only: [:index, :create, :update, :destroy]
end
