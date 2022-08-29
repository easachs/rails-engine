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
end
