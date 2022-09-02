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

    one_and_done.destroy_all
  end

  def self.find_name(search)
    where('name ILIKE ?', "%#{search}%")
      .order(:name).first
  end

  def self.find_all_name(search)
    where('name ILIKE ?', "%#{search}%")
      .order(:name)
  end

  def self.price_range(min, max)
    where('unit_price >= ? AND unit_price <= ?', min.to_f, max.to_f)
      .order(:name).first
  end

  def self.price_range_all(min, max)
    where('unit_price >= ? AND unit_price <= ?', min.to_f, max.to_f)
      .order(:name)
  end

  def self.min_price(min)
    where('unit_price >= ?', min.to_f)
      .order(:name).first
  end

  def self.min_price_all(min)
    where('unit_price >= ?', min.to_f)
      .order(:name)
  end

  def self.max_price(max)
    where('unit_price <= ?', max.to_f)
      .order(:name).first
  end

  def self.max_price_all(max)
    where('unit_price <= ?', max.to_f)
      .order(:name)
  end
end
