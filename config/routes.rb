Rails.application.routes.draw do
  namespace :api do
    post '/auth/login', to: 'auth#login'
    resources :products, only: [:index, :show]
    scope '/users/:user_id' do
      resource :cart, only: [:show] do
        post :add_product
        post :remove_product
      end
      resources :purchases, only: [:index, :create] do
      end
    end
  end
  root "hello#index"
end
