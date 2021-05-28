# frozen_string_literal: true

module SmartValidator
  class Result
    attr_reader :errors

    def initialize(errors:, data:)
      @errors = errors
      @data = data
    end

    def to_h
      @data.dup
    end

    def success?
      @errors.empty?
    end

    def failed?
      !success?
    end
  end
end
