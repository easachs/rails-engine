# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Items' do
  it 'fetches all items' do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    items_data = items[:data]

    expect(items_data.count).to eq(3)
    expect(items_data).to be_a(Array)

    items_data.each do |item|
      items_attributes = item[:attributes]
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(items_attributes).to have_key(:name)
      expect(items_attributes[:name]).to be_a(String)
      expect(items_attributes).to have_key(:description)
      expect(items_attributes[:description]).to be_a(String)
      expect(items_attributes).to have_key(:unit_price)
      expect(items_attributes[:unit_price]).to be_a(Float)
      expect(items_attributes).to have_key(:merchant_id)
      expect(items_attributes[:merchant_id]).to be_a(Integer)
    end
  end

  it 'fetches one item' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)
    item_data = item[:data]
    item_attributes = item_data[:attributes]

    expect(response).to be_successful

    expect(item_data).to have_key(:id)
    expect(item_data[:id]).to be_a(String)
    expect(item_attributes).to have_key(:name)
    expect(item_attributes[:name]).to be_a(String)
    expect(item_attributes).to have_key(:description)
    expect(item_attributes[:description]).to be_a(String)
    expect(item_attributes).to have_key(:unit_price)
    expect(item_attributes[:unit_price]).to be_a(Float)
    expect(item_attributes).to have_key(:merchant_id)
    expect(item_attributes[:merchant_id]).to be_a(Integer)
  end

  it 'fetches one item sad path' do
    get '/api/v1/items/woops'

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

  it 'creates an item' do
    merchant = Merchant.create!(name: 'Wizards Chest')

    item_params = {
      name: 'Coconut',
      description: 'Tasty',
      unit_price: 1.50,
      merchant_id: merchant.id
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    coconut = Item.last

    expect(response).to be_successful
    expect(coconut.name).to eq(item_params[:name])
    expect(coconut.description).to eq(item_params[:description])
    expect(coconut.unit_price).to eq(item_params[:unit_price])
    expect(coconut.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'creates an item sad path' do
    item_params = {
      name: 'Coconut',
      description: 'Tasty',
      unit_price: 1.50
      # no merchant
    }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

  it 'updates an item' do
    merchant = Merchant.create!(name: 'Wizards Chest')

    id = create(:item).id

    item_params = { description: 'On sale', unit_price: 9.99 }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)

    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.description).to eq(item_params[:description])
    expect(item.unit_price).to eq(item_params[:unit_price])

    item = JSON.parse(response.body, symbolize_names: true)
    item_data = item[:data]
    item_attributes = item_data[:attributes]

    expect(item_data).to have_key(:id)
    expect(item_data[:id]).to be_a(String)
    expect(item_attributes).to have_key(:description)
    expect(item_attributes[:description]).to be_a(String)
    expect(item_attributes[:description]).to eq('On sale')
    expect(item_attributes).to have_key(:unit_price)
    expect(item_attributes[:unit_price]).to be_a(Float)
    expect(item_attributes[:unit_price]).to eq(9.99)
  end

  it 'updates an item sad path' do
    merchant = Merchant.create!(name: 'Wizards Chest')

    id = create(:item).id

    item_params = { id: 9999, unit_price: 9.99, fake_attr: 'ABC' }

    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)

    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.unit_price).to eq(item_params[:unit_price])

    item = JSON.parse(response.body, symbolize_names: true)
    item_data = item[:data]
    item_attributes = item_data[:attributes]

    expect(item_data).to have_key(:id)
    expect(item_data[:id]).to be_a(String)
    expect(item_data[:id]).to eq(id.to_s)
    expect(item_attributes).to have_key(:description)
    expect(item_attributes[:description]).to be_a(String)
    expect(item_attributes).to have_key(:unit_price)
    expect(item_attributes[:unit_price]).to be_a(Float)
    expect(item_attributes[:unit_price]).to eq(9.99)
    expect(item_attributes[:fake_attr]).to be_nil
  end

  it 'fetches an items merchant' do
    merchant = create(:merchant)
    other = create(:merchant)
    item = Item.create!(name: 'Candy', merchant_id: merchant.id)
    Item.create!(name: 'Cabbage', merchant_id: other.id)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)
    merchant_data = merchant[:data]
    merchant_attributes = merchant_data[:attributes]

    expect(merchant).to_not include('Cabbage')
    expect(merchant.count).to eq(1)
    expect(merchant_data).to be_a(Hash)
    expect(merchant_data).to have_key(:id)
    expect(merchant_data[:id]).to be_a(String)
    expect(merchant_attributes).to have_key(:name)
    expect(merchant_attributes[:name]).to be_a(String)
  end

  it 'fetches merchants items sad path' do
    get '/api/v1/items/woops/merchant'

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

  it 'destroys an item' do
    merchant = Merchant.create!(name: 'Wizards Chest')

    id = create(:item).id

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    # expect(Item.find(id)).to raise_error(ActiveRecord::RecordNotFound)
  end
end
