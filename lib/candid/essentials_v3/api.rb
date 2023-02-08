# frozen_string_literal: true

require 'httparty'

module Candid
  module EssentialsV3
    class APIError < StandardError
      attr_reader :response

      def initialize(message, response)
        super(message)
        @response = response
      end
    end

    class API
      include HTTParty

      default_timeout 180

      base_uri 'https://api.candid.org/essentials/v3'
      format :json

      def initialize(api_token)
        self.class.default_options.merge!(headers: {
          'Content-Type' => 'application/json',
          'Subscription-Key' => api_token
        })
      end

      def search_by_term(search_terms, filters: nil)
        response = self.class.post('/', body: {
          search_terms: search_terms,
          filters: filters
        }.compact.to_json)

        raise Candid::EssentialsV3::APIError.new(response.parsed_response['message'], response) unless response.success?

        response.parsed_response['hits'].map do |hit|
          Candid::Shared::Resource.new(hit, response)
        end
      end
    end
  end
end
