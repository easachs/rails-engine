# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Find items' do
  describe 'happy paths' do
    before :each do
      merchant = create(:merchant)
      merchant.items.create!(name: 'Candy', unit_price: 10.0)
      merchant.items.create!(name: 'Casserole', unit_price: 7.5)
      merchant.items.create!(name: 'Cabbage', unit_price: 6.25)
      merchant.items.create!(name: 'Sprinkles', unit_price: 5.0)
      merchant.items.create!(name: 'Rainbow', unit_price: 2.5)
      merchant.items.create!(name: 'Unicorn', unit_price: 2.0)
    end

    it 'finds an item by name' do
      get '/api/v1/items/find?name=ca'

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)
      item_data = item[:data]
      item_attributes = item_data[:attributes]

      expect(item_data).to have_key(:id)
      expect(item_data[:id]).to be_a(String)
      expect(item_attributes).to have_key(:name)
      expect(item_attributes[:name]).to be_a(String)
      expect(item_attributes[:name]).to eq('Cabbage')
      expect(item_attributes[:unit_price]).to be_a(Float)
    end

    it 'finds items by name' do
      get '/api/v1/items/find_all?name=ca'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)
      items_data = items[:data]

      items_data.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        items_attributes = item[:attributes]
        expect(items_attributes).to have_key(:name)
        expect(items_attributes[:name]).to be_a(String)
        expect(items_attributes[:name].downcase).to include('ca')
        expect(items_attributes[:unit_price]).to be_a(Float)
      end
    end

    it 'finds an item by min and max price' do
      get '/api/v1/items/find?min_price=4.75&max_price=7.50'

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)
      item_data = item[:data]
      item_attributes = item_data[:attributes]
      expect(item_data).to have_key(:id)
      expect(item_data[:id]).to be_a(String)
      expect(item_attributes).to have_key(:name)
      expect(item_attributes[:name]).to be_a(String)
      expect(item_attributes[:unit_price]).to be_a(Float)
      expect(item_attributes[:unit_price]).to be >= (4.75)
      expect(item_attributes[:unit_price]).to be <= (7.5)
    end

    it 'finds items by min and max price' do
      get '/api/v1/items/find_all?min_price=4.75&max_price=7.50'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)
      items_data = items[:data]
      expect(items_data.count).to eq(3)

      items_data.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        items_attributes = item[:attributes]
        expect(items_attributes).to have_key(:name)
        expect(items_attributes[:name]).to be_a(String)
        expect(items_attributes[:unit_price]).to be_a(Float)
        expect(items_attributes[:unit_price]).to be >= (4.75)
        expect(items_attributes[:unit_price]).to be <= (7.5)
      end
    end

    it 'finds an item by min price' do
      get '/api/v1/items/find?min_price=7.49'

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)
      item_data = item[:data]
      item_attributes = item_data[:attributes]
      expect(item_data).to have_key(:id)
      expect(item_data[:id]).to be_a(String)

      expect(item_attributes).to have_key(:name)
      expect(item_attributes[:name]).to be_a(String)
      expect(item_attributes[:unit_price]).to be_a(Float)
      expect(item_attributes[:unit_price]).to be >= (7.49)
    end

    it 'finds items by min price' do
      get '/api/v1/items/find_all?min_price=7.49'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)
      items_data = items[:data]
      expect(items_data.count).to eq(2)

      items_data.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        items_attributes = item[:attributes]
        expect(items_attributes).to have_key(:name)
        expect(items_attributes[:name]).to be_a(String)
        expect(items_attributes[:unit_price]).to be_a(Float)
        expect(items_attributes[:unit_price]).to be >= (7.49)
      end
    end

    it 'finds an item by max price' do
      get '/api/v1/items/find?max_price=6.24'

      expect(response).to be_successful
      item = JSON.parse(response.body, symbolize_names: true)
      item_data = item[:data]
      item_attributes = item_data[:attributes]

      expect(item_data).to have_key(:id)
      expect(item_data[:id]).to be_a(String)
      expect(item_attributes).to have_key(:name)
      expect(item_attributes[:name]).to be_a(String)
      expect(item_attributes[:unit_price]).to be_a(Float)
      expect(item_attributes[:unit_price]).to be <= (6.24)
    end

    it 'finds items by max price' do
      get '/api/v1/items/find_all?max_price=6.24'

      expect(response).to be_successful
      items = JSON.parse(response.body, symbolize_names: true)
      items_data = items[:data]
      expect(items_data.count).to eq(3)

      items_data.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)
        items_attributes = item[:attributes]
        expect(items_attributes).to have_key(:name)
        expect(items_attributes[:name]).to be_a(String)
        expect(items_attributes[:unit_price]).to be_a(Float)
        expect(items_attributes[:unit_price]).to be <= (6.24)
      end
    end
  end

  describe 'sad paths' do
    it 'finds an item by name sad path' do
      get '/api/v1/items/find?name=unfortunatelynameditem'

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')

      get '/api/v1/items/find?name=something&min_price=2'

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')
    end

    it 'finds items by name sad path' do
      get '/api/v1/items/find_all?name=unfortunatelynameditem'

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq([])

      get '/api/v1/items/find_all?name=something&min_price=2'

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')
    end

    it 'finds an item by min and max price sad path' do
      get '/api/v1/items/find?min_price=7.50&max_price=4.75'

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')

      get '/api/v1/items/find?min_price=2&max_price='

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')
    end

    it 'finds items by min and max price sad path' do
      get '/api/v1/items/find_all?min_price=7.50&max_price=4.75'

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq([])

      get '/api/v1/items/find_all?min_price=2&max_price='

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')
    end

    it 'finds an item by min price sad path' do
      get '/api/v1/items/find?min_price=11.0'

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')

      get '/api/v1/items/find?min_price=-1.0'

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')

      get '/api/v1/items/find?min_price='

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')
    end

    it 'finds items by min price sad path' do
      get '/api/v1/items/find_all?min_price=11.0'

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq([])

      get '/api/v1/items/find_all?min_price=-1.0'

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')

      get '/api/v1/items/find_all?min_price='

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')
    end

    it 'finds an item by max price sad path' do
      get '/api/v1/items/find?max_price=0.01'

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')

      get '/api/v1/items/find?max_price=-1.0'

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')

      get '/api/v1/items/find?max_price='

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')
    end

    it 'finds items by max price sad path' do
      get '/api/v1/items/find_all?max_price=0.01'

      expect(response.status).to eq(200)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq([])

      get '/api/v1/items/find_all?max_price=-1.0'

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')

      get '/api/v1/items/find_all?max_price='

      expect(response.status).to eq(400)
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:data]).to eq({})
      expect(json_response[:error]).to eq('No results')
    end

    it 'find one error if no params' do
      get '/api/v1/items/find'
      expect(response.status).to eq(400)
    end

    it 'find one error if name and price search' do
      get '/api/v1/items/find?name=a&min_price=1.0max_price=10.0'
      expect(response.status).to eq(400)
    end

    it 'find all error if no params' do
      get '/api/v1/items/find_all'
      expect(response.status).to eq(400)
    end

    it 'find all error if name and price search' do
      get '/api/v1/items/find_all?name=a&min_price=1.0max_price=10.0'
      expect(response.status).to eq(400)
    end
  end
end
