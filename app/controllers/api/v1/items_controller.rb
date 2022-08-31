# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
      def index
        render_item(Item.all)
      end

      def show
        render_item(find_item)
      end

      def create
        render json: ItemSerializer.new(Item.create!(item_params)), status: :created
      end

      def update
        find_item.update!(item_params)
        render_item(Item.find(params[:id]))
      end

      def destroy
        find_item.trash_invoices
        find_item.destroy!
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end

      def find_item
        Item.find(params[:id])
      end
    end
  end
end
