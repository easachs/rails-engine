# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_404
  rescue_from ActiveRecord::RecordInvalid, with: :not_found_404

  def not_found_404
    render status: 404
  end
end
