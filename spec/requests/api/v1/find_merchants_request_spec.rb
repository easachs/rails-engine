# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Find merchant' do
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

    expect(response.status).to eq(400)
    json_response = JSON.parse(response.body, symbolize_names: true)
    expect(json_response[:data]).to eq({})
  end

  it 'finds all merchants' do
    create_list(:merchant, 3)
    Merchant.create!(name: 'Pirates Chest')
    Merchant.create!(name: 'Wizards Chest')

    get '/api/v1/merchants/find_all?name=chest'

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)
    merchant_data = merchant[:data]
    expect(merchant_data.length).to eq(2)

    merchant_data.each do |merchant|
      merchant_attributes = merchant[:attributes]
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(merchant_attributes).to have_key(:name)
      expect(merchant_attributes[:name]).to be_a(String)
      expect(merchant_attributes[:name]).to include('Chest')
    end
  end

  it 'finds all merchants sad path' do
    get '/api/v1/merchants/find_all?name=unfortunatelynamedstore'

    expect(response.status).to eq(200)
    json_response = JSON.parse(response.body, symbolize_names: true)
    expect(json_response[:data]).to eq([])

    get '/api/v1/merchants/find_all?name='

    expect(response.status).to eq(400)
    json_response = JSON.parse(response.body, symbolize_names: true)
    expect(json_response[:data]).to eq({})
  end
end
