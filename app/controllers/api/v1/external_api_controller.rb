# frozen_string_literal: true

# app/controllers/api/v1/external_api_controller.rb

module Api
  module V1
    class ExternalApiController < ApplicationController
      def fetch_data
        # Fetch the API key from the environment
        api_key = ENV['REACT_MUIX_API_KEY']

        # If the API key is missing, return an error
        if api_key.blank?
          render json: { error: 'API key not set' }, status: :bad_request
        else
          # Return the API key in a JSON response
          render json: { api_key: api_key }
        end
      end
    end
  end
end
