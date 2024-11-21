require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  get "up" => "rails/health#show", as: :rails_health_check

  # Rotas do carrinho
  get '/cart', to: 'carts#show'
  post '/cart', to: 'carts#create'
  post '/cart/add_items', to: 'carts#add_items'
  post '/cart/add_item', to: 'carts#add_item'
  delete '/cart/:product_id', to: 'carts#remove_product'
  
  resources :carts, only: [:show] do
    member do
      delete 'remove_product'
    end
  end

  root "rails/health#show"
end
