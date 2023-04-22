# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    post '/auth/login', to: 'auth#login'

    resources :products, only: %i[index show]

    scope '/user/' do
      resource :cart, only: [:show] do
        post :add_product
        post :remove_product
      end

      resources :purchases, only: %i[index create]
    end
  end
  root 'products#index'

  resources :products, only: %i[index show]

  resources :carts, only: [:show] do
    collection do
      post :add_product
      post :remove_product
    end
  end

  resources :purchases, only: %i[index create]
end
