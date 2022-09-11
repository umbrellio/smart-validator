# frozen_string_literal: true

module SmartValidator
  class Result
    attr_accessor :errors, :data, :failed

    def self.build_from_state(input_data, errors_controller)
      res = new(
        data: input_data,
        errors: errors_controller.errors,
        failed: errors_controller.validation_fails?,
      )
      res.freeze
    end

    def initialize(errors:, data:, failed:)
      self.errors = errors
      self.data = data
      self.failed = failed
    end

    def success?
      !failed
    end

    def freeze
      super.tap do
        errors.freeze
        data.freeze
      end
    end

    alias failed? failed
    alias to_h data
  end
end
