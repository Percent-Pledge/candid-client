# frozen_string_literal: true

require 'candid/premier_v3/api'
require 'candid/premier_v3/resource'
require 'candid/premier_v3/configuration'

module Candid
  module PremierV3
    extend self

    def configure
      yield configuration if block_given?
    end

    def configuration
      @configuration ||= Candid::PremierV3::Configuration.new
    end

    def lookup_by_ein(ein)
      api.lookup_by_ein(ein)
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
