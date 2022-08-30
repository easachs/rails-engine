# frozen_string_literal: true

module Api
  module V1
    class MerchantItemsController < ApplicationController
      def index
        items = Merchant.find(params[:merchant_id]).items
        render json: ItemSerializer.new(items)
      end
    end
  end
end
