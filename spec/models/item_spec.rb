# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'instance methods' do
    it 'deletes empty invoices' do
      item = create(:item)
      other = create(:item)
      id = item.id
      invoice_1 = Invoice.create!
      invoice_2 = Invoice.create!
      invoice_item = InvoiceItem.create!(item: item, invoice: invoice_1)
      invoice_item = InvoiceItem.create!(item: item, invoice: invoice_2)
      invoice_item = InvoiceItem.create!(item: other, invoice: invoice_2)

      expect(Invoice.count).to eq(2)
      expect(InvoiceItem.count).to eq(3)
      item.trash_invoices
      expect(Invoice.count).to eq(1)
      expect(Invoice.first).to eq(invoice_2)
      expect(InvoiceItem.count).to eq(2)
    end
  end

  describe 'class methods' do
    it 'finds an item by name' do
      merchant = create(:merchant)
      Item.create!(name: 'Candy', unit_price: 10.0, merchant_id: merchant.id)
      Item.create!(name: 'Casserole', unit_price: 7.5, merchant_id: merchant.id)
      cabbage = Item.create!(name: 'Cabbage', unit_price: 6.25, merchant_id: merchant.id)
      Item.create!(name: 'Sprinkles', unit_price: 5.0, merchant_id: merchant.id)
      Item.create!(name: 'Rainbow', unit_price: 2.5, merchant_id: merchant.id)
      Item.create!(name: 'Unicorn', unit_price: 2.0, merchant_id: merchant.id)

      expect(Item.find_name('ca')).to eq(cabbage)
      expect(Item.find_name('abcxyz')).to be_nil
    end

    it 'finds items array by name' do
      merchant = create(:merchant)
      Item.create!(name: 'Candy', unit_price: 10.0, merchant_id: merchant.id)
      casserole = Item.create!(name: 'Casserole', unit_price: 7.5, merchant_id: merchant.id)
      cabbage = Item.create!(name: 'Cabbage', unit_price: 6.25, merchant_id: merchant.id)
      Item.create!(name: 'Sprinkles', unit_price: 5.0, merchant_id: merchant.id)
      Item.create!(name: 'Rainbow', unit_price: 2.5, merchant_id: merchant.id)
      Item.create!(name: 'Unicorn', unit_price: 2.0, merchant_id: merchant.id)

      expect(Item.find_all_name('ca').count).to eq(3)
      expect(Item.find_all_name('ca').first).to eq(cabbage)
      expect(Item.find_all_name('ca').last).to eq(casserole)
      expect(Item.find_all_name('abcxyz')).to eq([])
    end

    it 'finds an item by max and min price' do
      merchant = create(:merchant)
      Item.create!(name: 'Candy', unit_price: 10.0, merchant_id: merchant.id)
      Item.create!(name: 'Casserole', unit_price: 7.5, merchant_id: merchant.id)
      cabbage = Item.create!(name: 'Cabbage', unit_price: 6.25, merchant_id: merchant.id)
      Item.create!(name: 'Sprinkles', unit_price: 5.0, merchant_id: merchant.id)
      Item.create!(name: 'Rainbow', unit_price: 2.5, merchant_id: merchant.id)
      Item.create!(name: 'Unicorn', unit_price: 2.0, merchant_id: merchant.id)

      expect(Item.price_range(4.75, 7.50)).to eq(cabbage)
      expect(Item.price_range(10.01, 11.0)).to be_nil
      expect(Item.price_range(0.01, 1.99)).to be_nil
      expect(Item.price_range(5.0, 4.0)).to be_nil
    end

    it 'finds items array by max and min price' do
      merchant = create(:merchant)
      Item.create!(name: 'Candy', unit_price: 10.0, merchant_id: merchant.id)
      Item.create!(name: 'Casserole', unit_price: 7.5, merchant_id: merchant.id)
      cabbage = Item.create!(name: 'Cabbage', unit_price: 6.25, merchant_id: merchant.id)
      sprinkles = Item.create!(name: 'Sprinkles', unit_price: 5.0, merchant_id: merchant.id)
      Item.create!(name: 'Rainbow', unit_price: 2.5, merchant_id: merchant.id)
      Item.create!(name: 'Unicorn', unit_price: 2.0, merchant_id: merchant.id)

      expect(Item.price_range_all(4.75, 7.50).count).to eq(3)
      expect(Item.price_range_all(4.75, 7.50).first).to eq(cabbage)
      expect(Item.price_range_all(4.75, 7.50).last).to eq(sprinkles)
      expect(Item.price_range_all(10.01, 11.0)).to eq([])
      expect(Item.price_range_all(0.01, 1.99)).to eq([])
      expect(Item.price_range_all(5.0, 4.0)).to eq([])
    end

    it 'finds an item by min price' do
      merchant = create(:merchant)
      candy = Item.create!(name: 'Candy', unit_price: 10.0, merchant_id: merchant.id)
      Item.create!(name: 'Casserole', unit_price: 7.5, merchant_id: merchant.id)
      cabbage = Item.create!(name: 'Cabbage', unit_price: 6.25, merchant_id: merchant.id)
      Item.create!(name: 'Sprinkles', unit_price: 5.0, merchant_id: merchant.id)
      Item.create!(name: 'Rainbow', unit_price: 2.5, merchant_id: merchant.id)
      Item.create!(name: 'Unicorn', unit_price: 2.0, merchant_id: merchant.id)

      expect(Item.min_price(7.25)).to eq(candy)
      expect(Item.min_price(2.0)).to eq(cabbage)
      expect(Item.min_price(10.01)).to be_nil
    end

    it 'finds items array by min price' do
      merchant = create(:merchant)
      candy = Item.create!(name: 'Candy', unit_price: 10.0, merchant_id: merchant.id)
      casserole = Item.create!(name: 'Casserole', unit_price: 7.5, merchant_id: merchant.id)
      Item.create!(name: 'Cabbage', unit_price: 6.25, merchant_id: merchant.id)
      Item.create!(name: 'Sprinkles', unit_price: 5.0, merchant_id: merchant.id)
      Item.create!(name: 'Rainbow', unit_price: 2.5, merchant_id: merchant.id)
      Item.create!(name: 'Unicorn', unit_price: 2.0, merchant_id: merchant.id)

      expect(Item.min_price_all(7.25).count).to eq(2)
      expect(Item.min_price_all(7.25).first).to eq(candy)
      expect(Item.min_price_all(7.25).last).to eq(casserole)
      expect(Item.min_price_all(10.01)).to eq([])
      expect(Item.min_price_all(0.01).count).to eq(6)
    end

    it 'finds an item by max price' do
      merchant = create(:merchant)
      Item.create!(name: 'Candy', unit_price: 10.0, merchant_id: merchant.id)
      Item.create!(name: 'Casserole', unit_price: 7.5, merchant_id: merchant.id)
      cabbage = Item.create!(name: 'Cabbage', unit_price: 6.25, merchant_id: merchant.id)
      Item.create!(name: 'Sprinkles', unit_price: 5.0, merchant_id: merchant.id)
      rainbow = Item.create!(name: 'Rainbow', unit_price: 2.5, merchant_id: merchant.id)
      unicorn = Item.create!(name: 'Unicorn', unit_price: 2.0, merchant_id: merchant.id)

      expect(Item.max_price(3.0)).to eq(rainbow)
      expect(Item.max_price(2.0)).to eq(unicorn)
      expect(Item.max_price(0.01)).to be_nil
      expect(Item.max_price(20.0)).to eq(cabbage)
    end

    it 'finds items array by max price' do
      merchant = create(:merchant)
      Item.create!(name: 'Candy', unit_price: 10.0, merchant_id: merchant.id)
      Item.create!(name: 'Casserole', unit_price: 7.5, merchant_id: merchant.id)
      Item.create!(name: 'Cabbage', unit_price: 6.25, merchant_id: merchant.id)
      Item.create!(name: 'Sprinkles', unit_price: 5.0, merchant_id: merchant.id)
      rainbow = Item.create!(name: 'Rainbow', unit_price: 2.5, merchant_id: merchant.id)
      unicorn = Item.create!(name: 'Unicorn', unit_price: 2.0, merchant_id: merchant.id)

      expect(Item.max_price_all(3.0).count).to eq(2)
      expect(Item.max_price_all(3.0).first).to eq(rainbow)
      expect(Item.max_price_all(3.0).last).to eq(unicorn)
      expect(Item.max_price_all(0.01)).to eq([])
      expect(Item.max_price_all(20.0).count).to eq(6)
    end
  end
end
