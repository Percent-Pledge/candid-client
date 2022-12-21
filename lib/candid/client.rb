# frozen_string_literal: true

require 'candid/client/api'
require 'candid/client/version'
require 'candid/client/connect'
require 'candid/client/resource'
require 'candid/client/configuration'
require 'candid/client/resource_collection'

module Candid
  module Client
    extend self

    class Error < StandardError; end

    def configure
      yield configuration if block_given?
    end

    def configuration
      @configuration ||= Candid::Client::Configuration.new
    end

    private

    def configuration=(configuration)
      @configuration = configuration
    end
  end
end
