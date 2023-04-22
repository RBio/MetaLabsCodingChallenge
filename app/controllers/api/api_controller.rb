# frozen_string_literal: true

module Api
  class ApiController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_handler

    def authorize_request
      authorization_header = request.headers['Authorization']
      encoded_token = authorization_header.split(' ').last if authorization_header
      begin
        @decoded_token = JsonWebToken.decode(encoded_token)
        @current_user = User.find(@decoded_token[:user_id])
      rescue JWT::DecodeError => e
        render json: { errors: "Invalid jwt provided: #{e.message}" }, status: :unauthorized
      end
    end

    private

    def record_not_found_handler(error)
      render json: { error: error.message }, status: :not_found
    end

    def bad_request_handler(error)
      render json: { error: error.message }, status: :bad_request
    end
  end
end
