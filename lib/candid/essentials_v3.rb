# frozen_string_literal: true

require 'candid/shared/resource'
require 'candid/essentials_v3/api'
require 'candid/essentials_v3/configuration'

module Candid
  module EssentialsV3
    extend self

    def configure
      yield configuration if block_given?
    end

    def configuration
      @configuration ||= Candid::EssentialsV3::Configuration.new
    end

    def search_by_term(search_terms, filters: nil)
      api.search_by_term(search_terms, filters: filters)
    end

    private

    def api
      @api ||= API.new(configuration.api_token)
    end

    def configuration=(configuration)
      @configuration = configuration
    end
  end
end
