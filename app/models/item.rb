# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def trash_invoices
    one_and_done = invoices.joins(:items)
                           .select('invoices.id, count(items)')
                           .group('invoices.id')
                           .having('count(items) = 1')

    one_and_done.each { |invoice| Invoice.find(invoice.id).destroy! }
  end
end
