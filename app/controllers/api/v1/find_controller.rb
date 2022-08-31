# frozen_string_literal: true

module Api
  module V1
    class FindController < ApplicationController
      def find_merchant
        render json: MerchantSerializer.new(Merchant.find_name(search_params[:name]))
      end

      def find_all_merchants
        render json: MerchantSerializer.new(Merchant.find_all_name(search_params[:name]))
      end

      def find_item
        if params[:name] && (params[:min_price] || params[:max_price])
          render status: 400
        elsif params[:name]
          render json: ItemSerializer.new(Item.find_name(params[:name]))
        elsif params[:min_price] && params[:max_price]
          render json: ItemSerializer.new(Item.price_range(params[:min_price], params[:max_price]))
        elsif params[:min_price]
          render json: ItemSerializer.new(Item.min_price(params[:min_price]))
        elsif params[:max_price]
          render json: ItemSerializer.new(Item.max_price(params[:max_price]))
        else
          render status: 400
        end
      end

      def find_all_items
        if params[:name] && (params[:min_price] || params[:max_price])
          render status: 400
        elsif params[:name]
          render json: ItemSerializer.new(Item.find_all_name(params[:name]))
        elsif params[:min_price] && params[:max_price]
          render json: ItemSerializer.new(Item.price_range_all(params[:min_price], params[:max_price]))
        elsif params[:min_price]
          render json: ItemSerializer.new(Item.min_price_all(params[:min_price]))
        elsif params[:max_price]
          render json: ItemSerializer.new(Item.max_price_all(params[:max_price]))
        else
          render status: 400
        end
      end

      private

      def search_params
        params.permit(:name, :min_price, :max_price)
      end
    end
  end
end
