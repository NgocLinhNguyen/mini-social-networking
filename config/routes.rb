Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

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
  end

  resources :likes
  resources :posts

  resources :groups do
    resources :posts do
      resources :comments
    end
  end

  post "add_user_to_group", to: "user_groups#create"
  delete "remove_user_from_group", to: "user_groups#destroy"
  get "search", to: "search#index"
  resources :friends
  resources :notifications, only: [:index]
  get "notifications/read", to: "notifications#destroy"
  get "notification", to: "notifications#update"
  resources :chatrooms
  resources :messages
end
