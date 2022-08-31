# frozen_string_literal: true

module Api
  module V1
    class ItemMerchantsController < ApplicationController
      def index
        item = Item.find(params[:item_id])
        render_merchant(item.merchant)
      end
    end
  end
end
