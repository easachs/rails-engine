# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :items

  def self.find_name(search)
    where('name ILIKE ?', "%#{search}%")
      .order(:name).first
  end
end
