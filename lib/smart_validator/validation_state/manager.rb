# frozen_string_literal: true

module SmartValidator
  module ValidationState
    class Manager
      attr_reader :errors

      def initialize(configuration)
        @invalid_input = false
        @errors = Errors.new(configuration.error_code_handling_type)
      end

      def merge_validation_errors!(validation_errors)
        validation_errors.each do |attr_path, error_codes|
          add_error_for_attribute!(attr_path, error_codes)
        end
      end

      def add_error_for_attribute!(attr_path, error_codes)
        errors.add!(attr_path, *Array(error_codes))
      end

      def invalid_input?
        @invalid_input ||= errors.any?
      end

      def skip_rule_for?(attribute)
        return false unless errors.one_error_code?

        errors.invalid_attribute?(attribute)
      end
    end
  end
end
