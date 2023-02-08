# frozen_string_literal: true

module Candid
  module EssentialsV3
    class Configuration
      attr_writer :api_token

      def api_token
        @api_token || raise(ArgumentError, 'Candid Essentials V3 api_token must be set')
      end
    end
  end
end
