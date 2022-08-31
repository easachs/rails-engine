# frozen_string_literal: true

module Api
  module V1
    class MerchantItemsController < ApplicationController
      def index
        merchant = Merchant.find(params[:merchant_id])
        render_item(merchant.items)
      end
    end
  end
end
