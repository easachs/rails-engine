# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found404
  rescue_from ActiveRecord::RecordInvalid, with: :not_found404

  def not_found404
    render json: { error: 'Not found' }, status: 404
  end

  def empty400
    render json: { error: 'No results', data: {} }, status: 400
  end
end
