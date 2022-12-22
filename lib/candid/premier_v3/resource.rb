# frozen_string_literal: true

require 'httparty'

module Candid
  module PremierV3
    class Resource
      attr_reader :data, :response

      def initialize(data, response = nil)
        @raw_data = data
        @data = recursively_create_resources(data)
        @response = response
      end

      def to_h
        @raw_data
      end

      def to_s
        @raw_data.to_s
      end

      def method_missing(method_name, *arguments, &block)
        respond_to?(method_name) ? data[method_name] : super
      end

      def respond_to_missing?(method_name, include_private = false)
        data.keys.include?(method_name) || super
      end

      private

      def recursively_create_resources(data)
        data.each_with_object({}) do |(key, value), memo|
          memo[key.to_sym] =
            case value
            when Hash then Resource.new(value)
            when Array then value.map { |item| item.is_a?(Hash) ? Resource.new(item) : item }
            else value
            end
        end
      end
    end
  end
end
