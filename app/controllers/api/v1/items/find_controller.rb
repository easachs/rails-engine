# frozen_string_literal: true

module Api
  module V1
    module Items
      class FindController < ApplicationController
        def find
          if something_bad || something_bad_find_item
            empty400
          elsif search_params[:name]
            render_item(Item.find_name(search_params[:name]))
          elsif search_params[:min_price] && search_params[:max_price]
            render_item(Item.price_range(search_params[:min_price], search_params[:max_price]))
          elsif search_params[:min_price]
            render_item(Item.min_price(search_params[:min_price]))
          elsif search_params[:max_price]
            render_item(Item.max_price(search_params[:max_price]))
          end
        end

        def find_all
          if something_bad || something_bad_find_all_items
            empty400
          elsif search_params[:name]
            render_item(Item.find_all_name(search_params[:name]))
          elsif search_params[:min_price] && search_params[:max_price]
            render_item(Item.price_range_all(search_params[:min_price], search_params[:max_price]))
          elsif search_params[:min_price]
            render_item(Item.min_price_all(search_params[:min_price]))
          elsif search_params[:max_price]
            render_item(Item.max_price_all(search_params[:max_price]))
          end
        end

        private

        def search_params
          params.permit(:name, :min_price, :max_price)
        end

        def something_bad
          %i[name min_price max_price].any? { |param| search_params[param] == '' } ||
            %i[name min_price max_price].none? { |param| search_params.key?(param) } ||
            (search_params[:name] && (search_params[:min_price] || search_params[:max_price])) ||
            search_params[:min_price].to_f.negative? || search_params[:max_price].to_f.negative?
        end

        def something_bad_find_all_items
          Item.find_all_name(search_params[:name]).nil? ||
            (search_params[:min_price] && search_params[:max_price] && Item.price_range_all(search_params[:min_price],
                                                                                            search_params[:max_price]).nil?) ||
            (search_params[:min_price] && Item.min_price_all(search_params[:min_price]).nil?) ||
            (search_params[:max_price] && Item.min_price_all(search_params[:max_price]).nil?)
        end

        def something_bad_find_item
          Item.find_name(search_params[:name]).nil? ||
            (search_params[:min_price] && search_params[:max_price] && Item.price_range(search_params[:min_price],
                                                                                        search_params[:max_price]).nil?) ||
            (search_params[:min_price] && Item.min_price(search_params[:min_price]).nil?) ||
            (search_params[:max_price] && Item.min_price(search_params[:max_price]).nil?)
        end
      end
    end
  end
end
