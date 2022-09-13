# frozen_string_literal: true

module SmartValidator
  module ErrorsController
    class Base
      attr_reader :errors

      def initialize
        @errors = SmartValidator::Errors.new
      end

      def process_smart_schema_result!(result)
        result.errors.each do |attr_path, error_codes|
          apply_data_to_errors!(attr_path, *error_codes)
        end
      end

      def process_rule!(result)
        return if result.nil?

        apply_data_to_errors!(result.attr_path, result.code)
      end

      def validation_fails?
        @validation_fails ||= errors.any?
      end

      # @!method apply_data_to_errors!
      # @!method error_will_be_skipped?
    end
  end
end
