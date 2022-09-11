# frozen_string_literal: true

module SmartValidator
  module ValidationState
    class Errors
      extend Forwardable
      include Enumerable

      def_delegators :@errors_container, :each, :as_json, :to_json

      def initialize(handling_type)
        unless allowed_handling_types.include?(handling_type)
          raise ArgumentError, "invalid handling type. allowed is: #{allowed_handling_types}"
        end

        self.one_error_code = handling_type == :one
        self.errors_container = {}
      end

      def add!(attr_path, *error_codes)
        path = attr_path.to_s

        if one_error_code?
          errors_container[path] ||= error_codes.first
        else
          errors_container[path] ||= Set.new
          errors_container[path].merge(error_codes)
        end
      end

      def one_error_code?
        one_error_code
      end

      def [](attr_path)
        errors_container[attr_path.to_s]
      end

      def freeze
        super.tap { errors_container.transform_values(&:freeze) }
      end

      def to_h
        errors_container.dup
      end

      def invalid_attribute?(attribute)
        errors_container.key?(attribute.to_s)
      end

      private

      def allowed_handling_types
        SmartValidator::ERROR_CODE_HANDLING_TYPES
      end

      attr_accessor :one_error_code, :errors_container
    end
  end
end
