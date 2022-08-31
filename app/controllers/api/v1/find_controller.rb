# frozen_string_literal: true

module Api
  module V1
    class FindController < ApplicationController
      def find_merchant
        if Merchant.find_name(search_params[:name]).nil? || search_params[:name].nil? || search_params[:name] == ''
          empty400
        else
          render json: MerchantSerializer.new(Merchant.find_name(search_params[:name]))
        end
      end

      def find_all_merchants
        if Merchant.find_all_name(search_params[:name]).nil? || search_params[:name].nil? || search_params[:name] == ''
          empty400
        else
          render json: MerchantSerializer.new(Merchant.find_all_name(search_params[:name]))
        end
      end

      def find_item
        if Item.find_name(search_params[:name]).nil? || search_params[:name] == ''
          empty400
        elsif search_params[:name] && (search_params[:min_price] || search_params[:max_price])
          empty400
        elsif search_params[:name]
          render json: ItemSerializer.new(Item.find_name(search_params[:name]))
        elsif search_params[:min_price] && search_params[:max_price]
          if Item.price_range(search_params[:min_price],
                              search_params[:max_price]).nil? || search_params[:min_price] == '' || search_params[:max_price] == ''
            empty400
          else
            render json: ItemSerializer.new(Item.price_range(search_params[:min_price], search_params[:max_price]))
          end
        elsif search_params[:min_price]
          if Item.min_price(search_params[:min_price]).nil? || search_params[:min_price].to_f.negative? || search_params[:min_price] == ''
            empty400
          else
            render json: ItemSerializer.new(Item.min_price(search_params[:min_price]))
          end
        elsif search_params[:max_price]
          if search_params[:max_price].to_f.negative? || search_params[:max_price] == ''
            empty400
          else
            render json: ItemSerializer.new(Item.max_price(search_params[:max_price]))
          end
        else
          empty400
        end
      end

      def find_all_items
        if Item.find_all_name(search_params[:name]).nil? || search_params[:name] == ''
          empty400
        elsif search_params[:name] && (search_params[:min_price] || search_params[:max_price])
          empty400
        elsif search_params[:name]
          render json: ItemSerializer.new(Item.find_all_name(search_params[:name]))

        elsif search_params[:min_price] && search_params[:max_price]
          if Item.price_range_all(search_params[:min_price],
                                  search_params[:max_price]).nil? || search_params[:min_price] == '' || search_params[:max_price] == ''
            empty400
          else
            render json: ItemSerializer.new(Item.price_range_all(search_params[:min_price], search_params[:max_price]))
          end

        elsif search_params[:min_price]
          if Item.min_price_all(search_params[:min_price]).nil? || search_params[:min_price].to_f.negative? || search_params[:min_price] == ''
            empty400
          else
            render json: ItemSerializer.new(Item.min_price_all(search_params[:min_price]))
          end

        elsif search_params[:max_price]
          if search_params[:max_price].to_f.negative? || search_params[:max_price] == ''
            empty400
          else
            render json: ItemSerializer.new(Item.max_price_all(search_params[:max_price]))
          end
          
        else
          empty400
        end
      end

      private

      def search_params
        params.permit(:name, :min_price, :max_price)
      end
    end
  end
end
