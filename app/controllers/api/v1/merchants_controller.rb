# frozen_string_literal: true

module Api
  module V1
    class MerchantsController < ApplicationController
      def index
        render_merchant(Merchant.all)
      end

      def show
        render_merchant(Merchant.find(params[:id]))
      end
    end
  end
end
