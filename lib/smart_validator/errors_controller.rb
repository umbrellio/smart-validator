# frozen_string_literal: true

module SmartValidator
  module ErrorsController
    extend self

    ALLOWED_MANAGING_TYPES = {
      error_per_attribute: ErrorsController::ErrorPerAttribute,
      many_errors_per_attribute: ErrorsController::ManyErrorsPerAttribute,
    }.freeze

    def resolve_from(managing_type)
      unless ALLOWED_MANAGING_TYPES.key?(managing_type)
        raise ArgumentError, "invalid handling type. allowed is: #{allowed_handling_types}"
      end

      ALLOWED_MANAGING_TYPES[managing_type].new
    end
  end
end
