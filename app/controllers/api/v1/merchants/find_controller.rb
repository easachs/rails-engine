# frozen_string_literal: true

module Api
  module V1
    module Merchants
      class FindController < ApplicationController
        def find
          if Merchant.find_name(search_params[:name]).nil? || [nil, ''].include?(search_params[:name])
            empty400
          else
            render_merchant(Merchant.find_name(search_params[:name]))
          end
        end

        def find_all
          if Merchant.find_all_name(search_params[:name]).nil? || [nil, ''].include?(search_params[:name])
            empty400
          else
            render_merchant(Merchant.find_all_name(search_params[:name]))
          end
        end

        private

        def search_params
          params.permit(:name)
        end
      end
    end
  end
end
