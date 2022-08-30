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
end
