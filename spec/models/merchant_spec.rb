# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items) }
  end

  describe 'class methods' do
    it 'finds a merchant by name' do
      create_list(:merchant, 3)
      pc = Merchant.create!(name: 'Pirates Chest')
      wc = Merchant.create!(name: 'Wizards Chest')

      expect(Merchant.find_name('chest')).to eq(pc)
      expect(Merchant.find_name('abcxyz')).to be_nil
    end

    it 'finds merchants array by name' do
      create_list(:merchant, 3)
      pc = Merchant.create!(name: 'Pirates Chest')
      wc = Merchant.create!(name: 'Wizards Chest')

      expect(Merchant.find_all_name('chest')).to eq([pc, wc])
      expect(Merchant.find_all_name('abcxyz')).to eq([])
    end
  end
end
