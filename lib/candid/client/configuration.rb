# frozen_string_literal: true

module Candid
  module Client
    class Configuration
      attr_writer :api_token

      def api_token
        @api_token || raise(ArgumentError, 'Candid api_token must be set')
      end
    end
  end
end
