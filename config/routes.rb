# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'find#find_merchant'
      get '/items/find_all', to: 'find#find_all_items'

      resources :merchants, only: %i[index show] do
        resources :items, only: [:index], controller: :merchant_items
      end

      resources :items do
        resources :merchant, only: [:index], controller: :item_merchants
      end
    end
  end
end
