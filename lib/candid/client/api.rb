# frozen_string_literal: true

require 'httparty'

module Candid
  module Client
    class API
      include HTTParty

      default_timeout 180

      base_uri 'TODO'
      format :json

      def initialize(_access_token)
        self.class.default_options.merge!(headers: {
          'Content-Type' => 'application/json'
        })
      end
    end
  end
end
