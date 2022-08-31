# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      %i[merchants items].each do |space|
        namespace space do
          get '/find', to: 'find#find'
          get '/find_all', to: 'find#find_all'
        end
      end

      resources :merchants, only: %i[index show] do
        resources :items, only: [:index], controller: :merchant_items
      end

      resources :items do
        resources :merchant, only: [:index], controller: :item_merchants
      end
    end
  end
end
