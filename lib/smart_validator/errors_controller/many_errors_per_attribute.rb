# frozen_string_literal: true

module SmartValidator
  module ErrorsController
    class ManyErrorsPerAttribute < Base
      def error_will_be_skipped?(_attr_path)
        false
      end

      private

      def apply_data_to_errors!(attr_path, *error_codes)
        errors.safely_merge!(attr_path: attr_path, errors_enum: error_codes)
      end
    end
  end
end
