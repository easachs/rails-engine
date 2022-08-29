# frozen_string_literal: true

class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  # has_many :items
end
