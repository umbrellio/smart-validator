# frozen_string_literal: true

module SmartValidator
  module ErrorsController
    class ErrorPerAttribute < Base
      def error_will_be_skipped?(attr_path)
        errors.attribute_already_exists?(attr_path)
      end

      private

      def apply_data_to_errors!(attr_path, *error_codes)
        errors.safely_add!(attr_path: attr_path, error_code: error_codes.first)
      end
    end
  end
end
