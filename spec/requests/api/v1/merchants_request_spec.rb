# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Merchants' do
  it 'fetches all merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)
    merchants_data = merchants[:data]

    expect(merchants_data.count).to eq(3)
    expect(merchants_data).to be_a(Array)

    merchants_data.each do |merchant|
      merchants_attributes = merchant[:attributes]
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(merchants_attributes).to have_key(:name)
      expect(merchants_attributes[:name]).to be_a(String)
    end
  end

  it 'fetches one merchant' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)
    merchant_data = merchant[:data]
    merchant_attributes = merchant_data[:attributes]

    expect(response).to be_successful

    expect(merchant_data).to have_key(:id)
    expect(merchant_data[:id]).to be_a(String)
    expect(merchant_attributes).to have_key(:name)
    expect(merchant_attributes[:name]).to be_a(String)
  end

  it 'fetches one merchant sad path' do
    get '/api/v1/merchants/woops'

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

  it 'fetches a merchants items' do
    merchant = create(:merchant)
    other = create(:merchant)
    Item.create!(name: 'Candy', merchant_id: merchant.id)
    Item.create!(name: 'Puppy', merchant_id: merchant.id)
    Item.create!(name: 'Rainbow', merchant_id: merchant.id)
    Item.create!(name: 'Cabbage', merchant_id: other.id)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    items_data = items[:data]

    expect(items).to_not include('Cabbage')

    expect(items_data.count).to eq(3)
    expect(items_data).to be_a(Array)

    items_data.each do |item|
      items_attributes = item[:attributes]
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(items_attributes).to have_key(:name)
      expect(items_attributes[:name]).to be_a(String)
      expect(items_attributes).to have_key(:description)
      expect(items_attributes).to have_key(:unit_price)
      expect(items_attributes).to have_key(:merchant_id)
      expect(items_attributes[:merchant_id]).to be_a(Integer)
    end
  end

  it 'fetches merchants items sad path' do
    get '/api/v1/merchants/woops/items'

    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  end

  it 'finds a merchant' do
    create_list(:merchant, 3)
    Merchant.create!(name: 'Pirates Chest')
    Merchant.create!(name: 'Wizards Chest')

    get '/api/v1/merchants/find?name=chest'

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)
    merchant_data = merchant[:data]
    merchant_attributes = merchant_data[:attributes]

    expect(merchant_data).to have_key(:id)
    expect(merchant_data[:id]).to be_a(String)
    expect(merchant_attributes).to have_key(:name)
    expect(merchant_attributes[:name]).to be_a(String)
    expect(merchant_attributes[:name]).to eq('Pirates Chest')
  end

  it 'finds a merchant sad path' do
    get '/api/v1/merchants/find?name=unfortunatelynamedstore'

    json_response = JSON.parse(response.body, symbolize_names: true)
    expect(json_response[:data]).to be_nil
  end
end
