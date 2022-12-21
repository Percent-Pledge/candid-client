# frozen_string_literal: true

require 'httparty'

module Candid
  module PremierV3
    class API
      include HTTParty

      default_timeout 180

      base_uri 'https://api.candid.org/premier/v3'
      format :json

      def initialize(api_token)
        self.class.default_options.merge!(headers: {
          'Content-Type' => 'application/json',
          'Subscription-Key' => api_token
        })
      end

      def lookup_by_ein(ein)
        response = self.class.get("/#{ein}")

        raise APIError.new(response.parsed_response['message'], response) unless response.success?

        Candid::PremierV3::Resource.new(response.parsed_response['data'], response)
      end

      class APIError < StandardError
        attr_reader :response

        def initialize(message, response)
          super(message)
          @response = response
        end
      end
    end
  end
end
